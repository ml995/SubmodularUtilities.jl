# Documentation of SubmodularUtilities.jl

## Maximization

This subset contains functions related to submodular maximization.

### Lazy Greedy
```@docs
lazy_greedy(f, ground_set, k)
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