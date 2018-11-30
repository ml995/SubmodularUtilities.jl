
<a id='Documentation-of-SubmodularUtilities.jl-1'></a>

# Documentation of SubmodularUtilities.jl


<a id='Maximization-1'></a>

## Maximization


This subset contains functions related to submodular maximization.


<a id='Lazy-Greedy-1'></a>

### Lazy Greedy

<a id='SubmodularUtilities.lazy_greedy-Tuple{Any,Any,Any}' href='#SubmodularUtilities.lazy_greedy-Tuple{Any,Any,Any}'>#</a>
**`SubmodularUtilities.lazy_greedy`** &mdash; *Method*.



```
lazy_greedy(f, ground_set, k)
```

`ground_set` should be an array of unique integers, which denotes the ground  set of monotone submodular function `f`. `f` represents a monotone submodular  function. If `T` is an array whose elements constitute a subset of `ground_set`,  `f(T)` is the function value of `T`. `k` is the cardinality constraint.  `lazy_greedy` outputs an array of length `k` using the lazy greedy algorithm.


<a target='_blank' href='https://github.com/lchen91/Submodular_Utilities/blob/master/src/SubmodularUtilities.jl#L10-L18' class='documenter-source'>source</a><br>


<a id='Rounding-1'></a>

## Rounding


This subset contains functions related to rounding a fractional vector between 0 and 1 into a binary vector (equivalently, a discrete set).


<a id='Pipage-Rounding-1'></a>

### Pipage Rounding

<a id='SubmodularUtilities.pipage_round-Tuple{Any}' href='#SubmodularUtilities.pipage_round-Tuple{Any}'>#</a>
**`SubmodularUtilities.pipage_round`** &mdash; *Method*.



```
pipage_round(x)
```

Given an array `x` whose every entry is between 0 and 1, round x into a binary vector using the pipage rounding algorithm presented in [^ccpv].

[^ccpv]: Calinescu, Gruia, et al. "Maximizing a monotone submodular function subject to a matroid constraint." SIAM Journal on Computing 40.6 (2011): 1740-1766.


<a target='_blank' href='https://github.com/lchen91/Submodular_Utilities/blob/master/src/SubmodularUtilities.jl#L42-L49' class='documenter-source'>source</a><br>


<a id='Random-Rounding-1'></a>

### Random Rounding

<a id='SubmodularUtilities.random_round-Tuple{Any}' href='#SubmodularUtilities.random_round-Tuple{Any}'>#</a>
**`SubmodularUtilities.random_round`** &mdash; *Method*.



```
random_round(x)
```

Given an array `x` whose every entry is between 0 and 1, round `x` into a binary vector.  The i-th entry of the output vector is 1 with probability `x[i]` and is 0 otherwise.


<a target='_blank' href='https://github.com/lchen91/Submodular_Utilities/blob/master/src/SubmodularUtilities.jl#L109-L114' class='documenter-source'>source</a><br>


<a id='Multilinear-Extension-1'></a>

## Multilinear Extension


This subset contains functions related to multilinear extension of submodular set functions.


<a id='Random-Evaluation-of-Multilinear-Extension-1'></a>

### Random Evaluation of Multilinear Extension


`get_random_evaluation_of_multilinear_extension`


<a id='Random-Gradient-of-Multilinear-Extension-1'></a>

### Random Gradient of Multilinear Extension


`get_random_gradient_of_multilinear_extension`


<a id='Submodular-Functions-1'></a>

## Submodular Functions


This subset contains several examples of submodular functions. Given input data, the functions named `get_function_...` below return a submodular function. 


<a id='Exemplar-Based-Clustering-1'></a>

### Exemplar-Based Clustering


`get_function_exemplar_based_clustering`: generates objective function of exemplar-based clustering.


<a id='Active-Set-Selection-1'></a>

### Active Set Selection


`get_function_active_set_selection`: generates objective function of active set selection.

