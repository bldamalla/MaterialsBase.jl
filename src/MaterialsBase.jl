module MaterialsBase

export matimage
export size, length, unique, eltype, segmented, normal
export ==, !=, +, /, mean, normalize!, normal_mean

export otsu_thresh

include("MaterialImage.jl")

include("segment.jl")

end # module
