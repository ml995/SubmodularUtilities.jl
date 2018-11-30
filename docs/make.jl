push!(LOAD_PATH, "../src")
using Documenter, SubmodularUtilities

makedocs(sitename="SubmodularUtilities.jl", 
	 repo="https://github.com/lchen91/Submodular_Utilities/blob/master{path}#{line}")
