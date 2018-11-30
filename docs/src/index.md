# SubmodularUtilities.jl Documentation

## Maximization

This subset contains functions related to submodular maximization.

- `lazy_greedy`

## Rounding

This subset contains functions related to rounding a fractional vector between 0 and 1 into a binary vector (equivalently, a discrete set).

```@docs
pipage_round(x)
```

```@docs
random_round(x)
```



## Multilinear Extension

This subset contains functions related to multilinear extension of submodular set functions.

- `get_random_evaluation_of_multilinear_extension`
- `get_random_gradient_of_multilinear_extension`

## Submodular Functions

This subset contains several examples of submodular functions. Given input data, the functions named `get_function_...` below return a submodular function. 

- `get_function_exemplar_based_clustering`: generates objective function of exemplar-based clustering.
- `get_function_active_set_selection`: generates objective function of active set selection.