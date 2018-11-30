# Submodular Utilities

Our implementation was developed under Julia 0.6.2. The algorithms that have been implemented are listed as below.

## How to Cite Submodular Utilities

If you use our code in your project, we would be grateful if you could cite

#### [![DOI](https://zenodo.org/badge/159565266.svg)](https://zenodo.org/badge/latestdoi/159565266)

## Maximization

Submodule: `Maximization`. This submodule contains functions related to submodular maximization.

- `lazy_greedy`

## Rounding

Submodule: `Rounding`. This submodule contains functions related to rounding a fractional vector between 0 and 1 into a binary vector (equivalently, a discrete set).

- `pipage_round`
- `random_round`

## Multilinear Extension

Submodule: `Multilinear`. This submodule contains functions related to multilinear extension of submodular set functions.

- `get_random_evaluation_of_multilinear_extension`
- `get_random_gradient_of_multilinear_extension`

## Submodular Functions

Submodule: `Functions`. This submodule contains several examples of submodular functions. Given input data, the functions named `get_function_...` below return a submodular function. 

- `get_function_exemplar_based_clustering`: generates objective function of exemplar-based clustering.
- `get_function_active_set_selection`: generates objective function of active set selection.