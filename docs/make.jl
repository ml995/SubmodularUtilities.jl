push!(LOAD_PATH, "src")
using Documenter, SubmodularUtilities

makedocs(sitename="SubmodularUtilities.jl", doctest = false)
# makedocs(sitename="SubmodularUtilities.jl", 
# 	 repo="https://github.com/lchen91/Submodular_Utilities/blob/master{path}#{line}")

# deploydocs(
# 	repo = "github.com/lchen91/Submodular_Utilities.git",
# )

deploydocs(
    repo   = "github.com/lchen91/SubmodularUtilities.jl.git",
    branch = "gh-pages",
    devbranch = "master",
)
