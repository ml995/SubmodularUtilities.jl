var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#SubmodularUtilities.jl-1",
    "page": "Home",
    "title": "SubmodularUtilities.jl",
    "category": "section",
    "text": ""
},

{
    "location": "#Getting-Started-1",
    "page": "Home",
    "title": "Getting Started",
    "category": "section",
    "text": "Our implementation was developed under Julia v0.7/v1.0."
},

{
    "location": "#Installation-1",
    "page": "Home",
    "title": "Installation",
    "category": "section",
    "text": "To install the package, in the package mode of Julia REPL, enter the following command add https://github.com/lchen91/SubmodularUtilities.jl."
},

{
    "location": "#How-to-Cite-Submodular-Utilities-1",
    "page": "Home",
    "title": "How to Cite Submodular Utilities",
    "category": "section",
    "text": "If you use our code in your project, we would be grateful if you could cite"
},

{
    "location": "#[![DOI](https://zenodo.org/badge/159565266.svg)](https://zenodo.org/badge/latestdoi/159565266)-1",
    "page": "Home",
    "title": "(Image: DOI)",
    "category": "section",
    "text": ""
},

{
    "location": "#Maximization-1",
    "page": "Home",
    "title": "Maximization",
    "category": "section",
    "text": "This subset contains functions related to submodular maximization."
},

{
    "location": "#SubmodularUtilities.lazy_greedy-Tuple{Any,Any,Any}",
    "page": "Home",
    "title": "SubmodularUtilities.lazy_greedy",
    "category": "method",
    "text": "lazy_greedy(f, ground_set, k)\n\nground_set should be an array of unique integers, which denotes the ground  set of monotone submodular function f. f represents a monotone submodular  function. If T is an array whose elements constitute a subset of ground_set,  f(T) is the function value of T. k is the cardinality constraint.  lazy_greedy outputs an array of length k using the lazy greedy algorithm.\n\n\n\n\n\n"
},

{
    "location": "#Lazy-Greedy-1",
    "page": "Home",
    "title": "Lazy Greedy",
    "category": "section",
    "text": "lazy_greedy(f, ground_set, k)"
},

{
    "location": "#SubmodularUtilities.Constraint",
    "page": "Home",
    "title": "SubmodularUtilities.Constraint",
    "category": "type",
    "text": "Constraint(A, sense, b, lb, ub)\n\nThe constraints are A*x sense b and lb <= x <= ub.  sense is a vector of constraint sense characters <, =, and >. A is a 2-dimensional array, which denotes the constraint matrix. b is the right-hand side vector.\n\n\n\n\n\n"
},

{
    "location": "#Constraint-1",
    "page": "Home",
    "title": "Constraint",
    "category": "section",
    "text": "Constraint"
},

{
    "location": "#SubmodularUtilities.meta_frank_wolfe-NTuple{6,Any}",
    "page": "Home",
    "title": "SubmodularUtilities.meta_frank_wolfe",
    "category": "method",
    "text": "meta_frank_wolfe(dim_x, f_list, g_list, eta, K, constraint; variance_reduction = false, n0 = rand(dim_x))\n\nArgs:\n\ndim_x: The dimension of the variables that we optimize.\nf_list: List of continuous DR-submodular functions [f_1, f_2, ..., f_T].\ng_list: List of (unbiased estimates of) the gradients of functions in f_list.\neta: This implementation uses Follow-Perturbed-Leader (FPL) for linear losses (which can be found in Hazan\'s book Introduction to Online Convex Optimization) as the online linear maximization algorithm. eta is the parameter of FPL.\nK: Number of instances of the chosen online linear maximization algorithm.\nconstraint: Constraint set. It is an object of type Constraint.\nvariance_reduction: Boolean variable which is true if variance reduction is enabled\nn0: the value of n0 in FPL for linear losses.\n\nReturns:\n\nArray of rewards [f_1(x_1), f_2(x_2), ..., f_T(f_T)].\n\n\n\n\n\n"
},

{
    "location": "#Meta-Frank-Wolfe-with-Variance-Reduction-1",
    "page": "Home",
    "title": "Meta-Frank-Wolfe with Variance Reduction",
    "category": "section",
    "text": "The Meta-Frank-Wolfe algorithm solves the online maximization problem of monotone continuous DR-submodular functions. The vanilla Meta-Frank-Wolfe algorithm is proposed in [CHK] and works when accurate gradient is available. The verison with variance reduction is proposed in [CHHK] and solves the problem when only an unbiased estimate of gradient is available.[CHK]: Lin Chen, Hamed Hassani, and Amin Karbasi, “Online Continuous Submodular Maximization”, in Proc. of AISTATS 2018.[CHHK]: Lin Chen, Christopher Harshaw, Hamed Hassani, and Amin Karbasi, “Projection-Free Online Optimization with Stochastic Gradient: From Convexity to Submodularity“, in Proc. of ICML 2018.meta_frank_wolfe(dim_x, f_list, g_list, eta, K, constraint; variance_reduction = false, n0 = rand(dim_x))An example about the use of meta-frank-wolfe and online_gradient_ascent is presented below.using PyPlot\nusing MathProgBase\nusing SubmodularUtilities\n\n# Non-convex/non-concave quadratic programming\ndim_x = 5\nT = 100\n\nH_list = [-rand(dim_x, dim_x) for i in 1:T]\nn_constraints = 2\nA = rand(n_constraints, dim_x)\nb = 1.0\nconstraint = Constraint(A, \'<\', b, 0., 1.)\n\nfunction get_f_nqp(H)\n    return x->((x / 2 .- 1)\' * H * x)\nend\n\nfunction get_g_nqp(H)\n    return x->(H + H\') / 2 * x - H\' * ones(dim_x) + 100 * randn(size(x))\nend\n\nproj = get_projection_operator(constraint)\nf_list = [get_f_nqp(H) for H in H_list]\ng_list = [get_g_nqp(H) for H in H_list]\n\nreward_fw = zeros(T)\nreward_fwvr = zeros(T)\nreward_oga = zeros(T)\nn_trials = 10\nfor iter in 1:n_trials\n    reward_fw += meta_frank_wolfe(dim_x, f_list, g_list, 0.1, T, constraint);\n    reward_fwvr += meta_frank_wolfe(dim_x, f_list, g_list, 0.1, T, constraint, variance_reduction = true);\n    reward_oga += online_gradient_ascent(zeros(dim_x), f_list, g_list, proj, step_size = t->0.1);\nend\nreward_fw ./= n_trials;\nreward_fwvr ./= n_trials;\nreward_oga ./= n_trials;\n\nplot(1:T, cumsum(reward_fw), label = \"No VR\")\nplot(1:T, cumsum(reward_fwvr), label = \"VR\")\nplot(1:T, cumsum(reward_oga), label = \"OGA\")\nlegend()"
},

{
    "location": "#SubmodularUtilities.get_projection_operator-Tuple{Any}",
    "page": "Home",
    "title": "SubmodularUtilities.get_projection_operator",
    "category": "method",
    "text": "get_projection_operator(constraint; dim_x = size(constraint.A)[2])\n\nArgs:\n\nconstraint: Constraint set. It is an object of type Constraint.\ndim_x: the dimension of the point. The default value is deduced from the size of constraint.A.\n\nReturns:\n\nA function projection such that projection(x) outputs the projection of x\n\nonto the set constraint.\n\n\n\n\n\n"
},

{
    "location": "#Projection-Operator-1",
    "page": "Home",
    "title": "Projection Operator",
    "category": "section",
    "text": "get_projection_operator(constraint; dim_x = size(constraint.A)[2])"
},

{
    "location": "#SubmodularUtilities.online_gradient_ascent-NTuple{4,Any}",
    "page": "Home",
    "title": "SubmodularUtilities.online_gradient_ascent",
    "category": "method",
    "text": "online_gradient_ascent(x0, f_list, g_list, projection; step_size = t->1/t)\n\nArgs: \n\nx0: the initial value\nf_list: List of continuous DR-submodular functions [f_1, f_2, ..., f_T].\ng_list: List of (unbiased estimates of) the gradients of functions in f_list.\nprojection: Projection operator of the constraint set. You may want to get it by calling get_projection_operator.\nstep_size: A function such that step_size(t) is the step size at the t-th iteration.\n\nReturns:\n\nArray of rewards [f_1(x_1), f_2(x_2), ..., f_T(f_T)].\n\n\n\n\n\n"
},

{
    "location": "#Online-Gradient-Ascent-1",
    "page": "Home",
    "title": "Online Gradient Ascent",
    "category": "section",
    "text": "online_gradient_ascent(x0, f_list, g_list, projection; step_size = t->1/t)"
},

{
    "location": "#Rounding-1",
    "page": "Home",
    "title": "Rounding",
    "category": "section",
    "text": "This subset contains functions related to rounding a fractional vector between 0 and 1 into a binary vector (equivalently, a discrete set)."
},

{
    "location": "#SubmodularUtilities.pipage_round-Tuple{Any}",
    "page": "Home",
    "title": "SubmodularUtilities.pipage_round",
    "category": "method",
    "text": "pipage_round(x)\n\nGiven an array x whose every entry is between 0 and 1, round x into a binary vector using the pipage rounding algorithm presented in [CCPV].\n\n[CCPV]: Calinescu, Gruia, et al. \"Maximizing a monotone submodular function subject to a matroid constraint.\" SIAM Journal on Computing 40.6 (2011): 1740-1766.\n\n\n\n\n\n"
},

{
    "location": "#Pipage-Rounding-1",
    "page": "Home",
    "title": "Pipage Rounding",
    "category": "section",
    "text": "pipage_round(x)"
},

{
    "location": "#SubmodularUtilities.random_round-Tuple{Any}",
    "page": "Home",
    "title": "SubmodularUtilities.random_round",
    "category": "method",
    "text": "random_round(x)\n\nGiven an array x whose every entry is between 0 and 1, round x into a binary vector.  The i-th entry of the output vector is 1 with probability x[i] and is 0 otherwise.\n\n\n\n\n\n"
},

{
    "location": "#Random-Rounding-1",
    "page": "Home",
    "title": "Random Rounding",
    "category": "section",
    "text": "random_round(x)"
},

{
    "location": "#Multilinear-Extension-1",
    "page": "Home",
    "title": "Multilinear Extension",
    "category": "section",
    "text": "This subset contains functions related to multilinear extension of submodular set functions."
},

{
    "location": "#SubmodularUtilities.get_random_evaluation_of_multilinear_extension",
    "page": "Home",
    "title": "SubmodularUtilities.get_random_evaluation_of_multilinear_extension",
    "category": "function",
    "text": "get_random_evaluation_of_multilinear_extension(f_discrete)\n\nThe input f_discrete is assumed to be a monotone submodular function defined  on the ground set 1:n, where n is some positive integer. Given an array T  whose elements are chosen from 1:n, f_discrete(T) is the function value of  the subset T. get_random_evaluation_of_multilinear_extension returns a  function that takes a size-n array x as input and outputs an unbiased estimate of  the function value of the multilinear extension of f_discrete at x. In other  words, the output is a function that maps x to f_discrete(random_round(x)).\n\n\n\n\n\n"
},

{
    "location": "#Random-Evaluation-of-Multilinear-Extension-1",
    "page": "Home",
    "title": "Random Evaluation of Multilinear Extension",
    "category": "section",
    "text": "get_random_evaluation_of_multilinear_extension"
},

{
    "location": "#SubmodularUtilities.get_random_gradient_of_multilinear_extension",
    "page": "Home",
    "title": "SubmodularUtilities.get_random_gradient_of_multilinear_extension",
    "category": "function",
    "text": "get_random_gradient_of_multilinear_extension(f_discrete)\n\nThe input f_discrete is assumed to be a monotone submodular function defined  on the ground set 1:n, where n is some positive integer. Given an array T  whose elements are chosen from 1:n, f_discrete(T) is the function value of  the subset T. get_random_gradient_of_multilinear_extension returns a  function that takes a size-n array x as input and outputs an unbiased estimate of  the gradient of the multilinear extension of f_discrete at x. \n\nIn other words, the output function first computes S = random_round(x). Then  the i-th partial derivative is  f_discrete(vcat(S, i)) - f_discrete(setdiff(S, i)).\n\n\n\n\n\n"
},

{
    "location": "#Random-Gradient-of-Multilinear-Extension-1",
    "page": "Home",
    "title": "Random Gradient of Multilinear Extension",
    "category": "section",
    "text": "get_random_gradient_of_multilinear_extension"
},

{
    "location": "#Submodular-Functions-1",
    "page": "Home",
    "title": "Submodular Functions",
    "category": "section",
    "text": "This subset contains several examples of submodular functions. Given input data, the functions named get_function_... below return a submodular function. "
},

{
    "location": "#SubmodularUtilities.get_function_exemplar_based_clustering",
    "page": "Home",
    "title": "SubmodularUtilities.get_function_exemplar_based_clustering",
    "category": "function",
    "text": "get_function_exemplar_based_clustering(data)\n\nReturns the objective function of exemplar-based clustering defined on the  ground set 1:size(data)[1]. The argument data is a 2-dimensional array.  Each row represents a data point and each column represents an attribute. \n\n\n\n\n\n"
},

{
    "location": "#Exemplar-Based-Clustering-1",
    "page": "Home",
    "title": "Exemplar-Based Clustering",
    "category": "section",
    "text": "get_function_exemplar_based_clustering"
},

{
    "location": "#SubmodularUtilities.get_function_active_set_selection",
    "page": "Home",
    "title": "SubmodularUtilities.get_function_active_set_selection",
    "category": "function",
    "text": "get_function_active_set_selection(data; sigma = 1., h = 0.75)\n\nReturns the objective function of active set selection defined on the ground set 1:size(data)[2]. The argument data is a 2-dimensional array.  Each row represents a data point and each column represents an attribute.  The covariance matrix uses a Gaussian kernel  exp(-norm(data[:, i] - data[:, j])^2 / h^2). The function value of the  objective function evaluated at the subset S is  0.5 * log(det(eye(length(S)) + cov_matrix[S, S] / sigma^2)).\n\n\n\n\n\n"
},

{
    "location": "#Active-Set-Selection-1",
    "page": "Home",
    "title": "Active Set Selection",
    "category": "section",
    "text": "get_function_active_set_selection"
},

]}
