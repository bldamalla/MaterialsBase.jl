using MaterialsBase
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
@testset "MaterialsBase" begin
  # test structure basic functions
  include("image_struct.jl")
  # add segmentation functions
  include("segment.jl")
end
