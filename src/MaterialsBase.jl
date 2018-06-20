module MaterialsBase

export matimage
export size, length, unique, eltype, segmented, normal
export ==, !=, +, /, mean, normalize!, normal_mean

include("MaterialImage.jl")

end # module
