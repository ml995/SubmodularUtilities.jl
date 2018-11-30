
<a id='SubmodularUtilities.jl-Documentation-1'></a>

# SubmodularUtilities.jl Documentation


<a id='Maximization-1'></a>

## Maximization


This subset contains functions related to submodular maximization.


  * `lazy_greedy`


<a id='Rounding-1'></a>

## Rounding


This subset contains functions related to rounding a fractional vector between 0 and 1 into a binary vector (equivalently, a discrete set).

<a id='SubmodularUtilities.pipage_round-Tuple{Any}' href='#SubmodularUtilities.pipage_round-Tuple{Any}'>#</a>
**`SubmodularUtilities.pipage_round`** &mdash; *Method*.



```
pipage_round(x)
```

Given an array x whose every entry is between 0 and 1, round x into a binary vector using the pipage rounding algorithm presented in [^ccpv].

[^ccpv]: Calinescu, Gruia, et al. "Maximizing a monotone submodular function subject to a matroid constraint." SIAM Journal on Computing 40.6 (2011): 1740-1766.


<a target='_blank' href='https://github.com/lchen91/Submodular_Utilities/blob/master/src/SubmodularUtilities.jl#L33-L40' class='documenter-source'>source</a><br>

<a id='SubmodularUtilities.random_round-Tuple{Any}' href='#SubmodularUtilities.random_round-Tuple{Any}'>#</a>
**`SubmodularUtilities.random_round`** &mdash; *Method*.



```
random_round(x)
```

Given an array x whose every entry is between 0 and 1, round x into a binary vector.  The i-th entry of the output vector is 1 with probability x[i] and is 0 otherwise.


<a target='_blank' href='https://github.com/lchen91/Submodular_Utilities/blob/master/src/SubmodularUtilities.jl#L100-L105' class='documenter-source'>source</a><br>


<a id='Multilinear-Extension-1'></a>

## Multilinear Extension


This subset contains functions related to multilinear extension of submodular set functions.


  * `get_random_evaluation_of_multilinear_extension`
  * `get_random_gradient_of_multilinear_extension`


<a id='Submodular-Functions-1'></a>

## Submodular Functions


This subset contains several examples of submodular functions. Given input data, the functions named `get_function_...` below return a submodular function. 


  * `get_function_exemplar_based_clustering`: generates objective function of exemplar-based clustering.
  * `get_function_active_set_selection`: generates objective function of active set selection.

