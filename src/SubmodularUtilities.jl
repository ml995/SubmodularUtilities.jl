# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module SubmodularUtilities

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

export pipage_round
"""
    pipage_round(x)

Given an array `x` whose every entry is between 0 and 1, round x into a binary vector
using the pipage rounding algorithm presented in [^ccpv].

[^ccpv]: Calinescu, Gruia, et al. "Maximizing a monotone submodular function subject to a matroid constraint." SIAM Journal on Computing 40.6 (2011): 1740-1766.
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