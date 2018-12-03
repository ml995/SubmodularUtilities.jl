# SubmodularUtilities.jl

## Getting Started

Our implementation was developed under Julia v0.7/v1.0.

### Installation

To install the package, in the package mode of Julia REPL, enter the following command `add https://github.com/lchen91/SubmodularUtilities.jl`.

### How to Cite Submodular Utilities

If you use our code in your project, we would be grateful if you could cite

#### [![DOI](https://zenodo.org/badge/159565266.svg)](https://zenodo.org/badge/latestdoi/159565266)

## Maximization

This subset contains functions related to submodular maximization.

### Lazy Greedy
```@docs
lazy_greedy(f, ground_set, k)
```

### Constraint
```@docs
Constraint
```

### Meta-Frank-Wolfe with Variance Reduction
The Meta-Frank-Wolfe algorithm solves the online maximization problem of monotone continuous DR-submodular functions. The vanilla Meta-Frank-Wolfe algorithm is proposed in [^CHK] and works when accurate gradient is available. The verison with variance reduction is proposed in [^CHHK] and solves the problem when only an unbiased estimate of gradient is available.

[^CHK]: Lin Chen, Hamed Hassani, and Amin Karbasi, “Online Continuous Submodular Maximization”, in Proc. of AISTATS 2018.
[^CHHK]: Lin Chen, Christopher Harshaw, Hamed Hassani, and Amin Karbasi, “Projection-Free Online Optimization with Stochastic Gradient: From Convexity to Submodularity“, in Proc. of ICML 2018.

```@docs
meta_frank_wolfe(dim_x, f_list, g_list, eta, K, constraint; variance_reduction = false, n0 = rand(dim_x))
```

An example about the use of `meta-frank-wolfe` and `online_gradient_ascent` is presented below.

```julia
using PyPlot
using MathProgBase
using SubmodularUtilities

# Non-convex/non-concave quadratic programming
dim_x = 5
T = 100

H_list = [-rand(dim_x, dim_x) for i in 1:T]
n_constraints = 2
A = rand(n_constraints, dim_x)
b = 1.0
constraint = Constraint(A, '<', b, 0., 1.)

function get_f_nqp(H)
    return x->((x / 2 .- 1)' * H * x)
end

function get_g_nqp(H)
    return x->(H + H') / 2 * x - H' * ones(dim_x) + 100 * randn(size(x))
end

proj = get_projection_operator(constraint)
f_list = [get_f_nqp(H) for H in H_list]
g_list = [get_g_nqp(H) for H in H_list]

reward_fw = zeros(T)
reward_fwvr = zeros(T)
reward_oga = zeros(T)
n_trials = 10
for iter in 1:n_trials
    reward_fw += meta_frank_wolfe(dim_x, f_list, g_list, 0.1, T, constraint);
    reward_fwvr += meta_frank_wolfe(dim_x, f_list, g_list, 0.1, T, constraint, variance_reduction = true);
    reward_oga += online_gradient_ascent(zeros(dim_x), f_list, g_list, proj, step_size = t->0.1);
end
reward_fw ./= n_trials;
reward_fwvr ./= n_trials;
reward_oga ./= n_trials;

plot(1:T, cumsum(reward_fw), label = "No VR")
plot(1:T, cumsum(reward_fwvr), label = "VR")
plot(1:T, cumsum(reward_oga), label = "OGA")
legend()
```
### Projection Operator
```@docs
get_projection_operator(constraint; dim_x = size(constraint.A)[2])
```
### Online Gradient Ascent
```@docs
online_gradient_ascent(x0, f_list, g_list, projection; step_size = t->1/t)
```

## Rounding

This subset contains functions related to rounding a fractional vector between 0 and 1 into a binary vector (equivalently, a discrete set).

### Pipage Rounding

```@docs
pipage_round(x)
```

### Random Rounding

```@docs
random_round(x)
```


## Multilinear Extension

This subset contains functions related to multilinear extension of submodular set functions.

### Random Evaluation of Multilinear Extension
```@docs
get_random_evaluation_of_multilinear_extension
```

### Random Gradient of Multilinear Extension
```@docs
get_random_gradient_of_multilinear_extension
```

## Submodular Functions

This subset contains several examples of submodular functions. Given input data, the functions named `get_function_...` below return a submodular function. 

### Exemplar-Based Clustering
```@docs
get_function_exemplar_based_clustering
```

### Active Set Selection
```@docs
get_function_active_set_selection
```