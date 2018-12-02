push!(LOAD_PATH, "../src")
using Documenter, SubmodularUtilities

makedocs()
# makedocs(sitename="SubmodularUtilities.jl", 
# 	 repo="https://github.com/lchen91/Submodular_Utilities/blob/master{path}#{line}")

deploydocs(
	repo = "github.com/lchen91/Submodular_Utilities.git",
)
