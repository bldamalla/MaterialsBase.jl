using MaterialsBase
@static if VERSION < v"0.7.0-DEV.2005"
  using Base.Test
else
  using Test
end

@testset "Image segmentation" begin
  @testset "Otsu thresholding" begin
    @testset "Image histogram" begin
      img = matimage(rand(100000), (250, 400), 2)
      hist = MaterialsBase.imagehist(img)
      @test hist[end] == 1
      @test sum(hist) == length(img)
      @test typeof(hist) <: Vector{Int}
    end
  end
end
