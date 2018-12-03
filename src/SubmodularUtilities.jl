# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module SubmodularUtilities

using LinearAlgebra

export lazy_greedy
using Base.Order
using DataStructures
"""
    lazy_greedy(f, ground_set, k)

`ground_set` should be an array of unique integers, which denotes the ground 
set of monotone submodular function `f`. `f` represents a monotone submodular 
function. If `T` is an array whose elements constitute a subset of `ground_set`, 
`f(T)` is the function value of `T`. `k` is the cardinality constraint. 
`lazy_greedy` outputs an array of length `k` using the lazy greedy algorithm.
"""
function lazy_greedy(f, ground_set, k)
    uppers = [(Inf, i) for i in ground_set]
    myorder = ReverseOrdering(By(x->x[1]))
    heapify!(uppers, myorder)
    s = []
    current = 0.
    for i in 1:k
        while true
            v, e = heappop!(uppers, myorder)
            new_upper_bound = f(vcat(s, e)) - current
            if new_upper_bound >= uppers[1][1]
                push!(s, e)
                current += new_upper_bound
                break
            else
                heappush!(uppers, (new_upper_bound, e), myorder)
            end
        end
    end
    return s
end

mutable struct FPL
    x
    eta
    accumulated_gradient
    n0
end

export Constraint
"""
    Constraint(A, sense, b, lb, ub)

The constraints are A*x sense b and lb <= x <= ub. 
`sense` is a vector of constraint sense characters `<`, `=`, and `>`.
`A` is a 2-dimensional array, which denotes the constraint matrix.
`b` is the right-hand side vector.
"""
struct Constraint
    A
    sense
    b
    lb
    ub
end

using MathProgBase, Clp
function update(fpl, gradient, constraint)
    fpl.accumulated_gradient .-= gradient
    sol = linprog(fpl.eta * fpl.accumulated_gradient + fpl.n0, 
        constraint.A, constraint.sense, constraint.b, constraint.lb, constraint.ub, ClpSolver())
    if sol.status == :Optimal
        fpl.x = sol.sol
    else
        error("No solution was found.")
    end
end

function get_vector(fpl)
    return fpl.x
end

export meta_frank_wolfe
"""
    meta_frank_wolfe(dim_x, f_list, g_list, eta, K, constraint; variance_reduction = false, n0 = rand(dim_x))

Args:
- `dim_x`: The dimension of the variables that we optimize.
- `f_list`: List of continuous DR-submodular functions `[f_1, f_2, ..., f_T]`.
- `g_list`: List of (unbiased estimates of) the gradients of functions in `f_list`.
- `eta`: This implementation uses Follow-Perturbed-Leader (FPL) for linear losses (which can be found in Hazan's book Introduction to Online Convex Optimization) as the online linear maximization algorithm. `eta` is the parameter of FPL.
- `K`: Number of instances of the chosen online linear maximization algorithm.
- `constraint`: Constraint set. It is an object of type `Constraint`.
- `variance_reduction`: Boolean variable which is `true` if variance reduction is enabled
- `n0`: the value of n0 in FPL for linear losses.

Returns:
- Array of rewards `[f_1(x_1), f_2(x_2), ..., f_T(f_T)]`.
"""
function meta_frank_wolfe(dim_x, f_list, g_list, eta, K, constraint; 
    variance_reduction = false, n0 = rand(dim_x))
    sol = linprog(-n0, 
        constraint.A, constraint.sense, constraint.b, constraint.lb, constraint.ub, ClpSolver())
    if sol.status != :Optimal
        error("No solution was found.")
    end
    x0 = sol.sol
    fpl = [FPL(x0, eta, zeros(dim_x), n0) for k in 1:K]
    @assert length(f_list) == length(g_list)
    T = length(f_list)
    reward = zeros(T)

    for t in 1:T
        v = [get_vector(fpl[k]) for k in 1:K]
        x = zeros(K + 1, dim_x)
        for k in 1:K
            x[k + 1, :] = x[k, :] + v[k] / K
        end
        reward[t] = f_list[t](x[K + 1, :])
        d = zeros(dim_x)
        for k in 1:K
            if variance_reduction
                rho = 0.5 * k^(-2/3)
                d = (1 - rho) * d + rho * g_list[t](x[k, :])
            else
                d = g_list[t](x[k, :])
            end
            update(fpl[k], d, constraint)
        end
    end
    return reward
end

using Ipopt
export get_projection_operator
"""
    get_projection_operator(constraint; dim_x = size(constraint.A)[2])

Args:
- `constraint`: Constraint set. It is an object of type `Constraint`.
- `dim_x`: the dimension of the point. The default value is deduced from the size of `constraint.A`.

Returns:
- A function `projection` such that `projection(x)` outputs the projection of `x`
onto the set `constraint`.
"""
function get_projection_operator(constraint; dim_x = size(constraint.A)[2])
    function projection(x0)
        sol = quadprog(-x0, eye(dim_x), constraint.A, constraint.sense, constraint.b, constraint.lb, constraint.ub, IpoptSolver(print_level=0))
        if sol.status == :Optimal
            return sol.sol
        end
        error("No projection of $x0 is found.")
    end
    return projection
end

export online_gradient_ascent
"""
    online_gradient_ascent(x0, f_list, g_list, projection; step_size = t->1/t)

Args: 
- `x0`: the initial value
- `f_list`: List of continuous DR-submodular functions `[f_1, f_2, ..., f_T]`.
- `g_list`: List of (unbiased estimates of) the gradients of functions in `f_list`.
- `projection`: Projection operator of the constraint set. You may want to get it by calling `get_projection_operator`.
- `step_size`: A function such that `step_size(t)` is the step size at the t-th iteration.

Returns:
- Array of rewards `[f_1(x_1), f_2(x_2), ..., f_T(f_T)]`.
"""
function online_gradient_ascent(x0, f_list, g_list, projection; step_size = t->1/t)
    @assert length(f_list) == length(g_list)
    T = length(f_list)
    reward = zeros(T)
    x = copy(x0)
    for t in 1:T
        reward[t] = f_list[t](x)
        x = projection(x + g_list[t](x) * step_size(t))
    end
    return reward
end

export pipage_round
"""
    pipage_round(x)

Given an array `x` whose every entry is between 0 and 1, round x into a binary vector
using the pipage rounding algorithm presented in [^CCPV].

[^CCPV]: Calinescu, Gruia, et al. "Maximizing a monotone submodular function subject to a matroid constraint." SIAM Journal on Computing 40.6 (2011): 1740-1766.
"""
function pipage_round(x)
    function pipage_round_raw(x)
        y = copy(x)
        T = []
        for i in 1:length(y)
            if 0 < y[i] < 1
                push!(T, i)
            end
        end
    
        try
            while length(T) > 0
                i, j = T[1], T[2]
                if y[i] + y[j] < 1
                    p = y[j] / (y[i] + y[j])
                    if rand() < p
                        y[j] += y[i]
                        y[i] = 0.
                        deleteat!(T, 1)
                    else
                        y[i] += y[j]
                        y[j] = 0.
                        deleteat!(T, 2)
                    end
                else
                    p = (1. - y[i]) / (2. - y[i] - y[j])
                    if rand() < p
                        y[i] += y[j] - 1.
                        y[j] = 1.
                        deleteat!(T, 2)
                        if y[i] == 0.
                            deleteat!(T, 1)
                        end
                    else
                        y[j] += y[i] - 1.
                        y[i] = 1.
                        deleteat!(T, 1)
                        if y[j] == 0.
                            deleteat!(T, 1)
                        end
                    end
                end
            end
        catch
            return y
        end
        return y
    end
    function regularize_answer(ans)
        pp = pipage_round_raw(ans)
        pp[pp .< 1] = 0.
        return pp
    end
    px = regularize_answer(x)
    v = [i for i in 1:length(x) if px[i] != 0]
    return v
end

export random_round
"""
    random_round(x)

Given an array `x` whose every entry is between 0 and 1, round `x` into a binary vector. 
The i-th entry of the output vector is 1 with probability `x[i]` and is 0 otherwise.
"""
function random_round(x)
    p = rand(size(x));
    return find(p .< x)
end

export get_random_evaluation_of_multilinear_extension
"""
    get_random_evaluation_of_multilinear_extension(f_discrete)

The input `f_discrete` is assumed to be a monotone submodular function defined 
on the ground set `1:n`, where n is some positive integer. Given an array `T` 
whose elements are chosen from `1:n`, `f_discrete(T)` is the function value of 
the subset `T`. `get_random_evaluation_of_multilinear_extension` returns a 
function that takes a size-n array `x` as input and outputs an unbiased estimate of 
the function value of the multilinear extension of `f_discrete` at `x`. In other
 words, the output is a function that maps `x` to `f_discrete(random_round(x))`.
"""
function get_random_evaluation_of_multilinear_extension(f_discrete)
    return x->f_discrete(random_round(x))
end

export get_random_gradient_of_multilinear_extension
"""
    get_random_gradient_of_multilinear_extension(f_discrete)

The input `f_discrete` is assumed to be a monotone submodular function defined 
on the ground set `1:n`, where n is some positive integer. Given an array `T` 
whose elements are chosen from `1:n`, `f_discrete(T)` is the function value of 
the subset `T`. `get_random_gradient_of_multilinear_extension` returns a 
function that takes a size-n array `x` as input and outputs an unbiased estimate of 
the gradient of the multilinear extension of `f_discrete` at `x`. 

In other words, the output function first computes `S = random_round(x)`. Then 
the i-th partial derivative is 
`f_discrete(vcat(S, i)) - f_discrete(setdiff(S, i))`.
"""
function get_random_gradient_of_multilinear_extension(f_discrete)
    function stochastic_gradient(x)
        S = random_round(x);
        grad = zeros(x);
        for i in 1:length(x)
            grad[i] = f_discrete(vcat(S, i)) - f_discrete(setdiff(S, i));
        end
        return grad
    end
    return stochastic_gradient
end

export get_function_exemplar_based_clustering
"""
    get_function_exemplar_based_clustering(data)

Returns the objective function of exemplar-based clustering defined on the 
ground set `1:size(data)[1]`. The argument `data` is a 2-dimensional array. 
Each row represents a data point and each column represents an attribute. 
"""
function get_function_exemplar_based_clustering(data)
    function f_exemplar(S)
        n_V = size(data)[1];
        function L(S)
            return sum([minimum([norm(data[e, :] - (v > 0 ? data[v, :] : 0))^2 for v in S])
                for e in 1:n_V]) / n_V
        end
        return L([0]) - L(vcat(S, 0))
    end
    return f_exemplar
end

export get_function_active_set_selection
"""
    get_function_active_set_selection(data; sigma = 1., h = 0.75)

Returns the objective function of active set selection defined on the ground set
`1:size(data)[2]`. The argument `data` is a 2-dimensional array. 
Each row represents a data point and each column represents an attribute. 
The covariance matrix uses a Gaussian kernel 
`exp(-norm(data[:, i] - data[:, j])^2 / h^2)`. The function value of the 
objective function evaluated at the subset `S` is 
`0.5 * log(det(eye(length(S)) + cov_matrix[S, S] / sigma^2))`.
"""
function get_function_active_set_selection(data; sigma = 1., h = 0.75)
    n_attr = size(data)[2];
    cov_matrix = zeros(n_attr, n_attr);
    for i in 1:n_attr
        for j in 1:i
            cov_matrix[i, j] = exp(-norm(data[:, i] - data[:, j])^2 / h^2)
            if j != i
                cov_matrix[j, i] = cov_matrix[i, j]
            end
        end
    end
    function f_active_set_discrete(S)
        if isempty(S)
            return 0.;
        end
        return 0.5 * log(det(eye(length(S)) + cov_matrix[S, S] / sigma^2))
    end
    return f_active_set_discrete
end
end # end of module SubmodularUtilities