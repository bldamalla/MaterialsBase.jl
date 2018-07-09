module MaterialsBase

export matimage
export size, length, unique, eltype, segmented, normal
export ==, !=, +, /, mean, normalize!, normal_mean

export otsu_thresh, segment!

include("MaterialImage.jl")

include("segment.jl")

end # module
