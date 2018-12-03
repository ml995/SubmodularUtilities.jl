# SubmodularUtilities.jl

## Installation

To install the package, in the package mode, enter the following command `add https://github.com/lchen91/SubmodularUtilities.jl`.

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