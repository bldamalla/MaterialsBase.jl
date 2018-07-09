using MaterialsBase, StatsBase
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
      @test hist.sum == length(img)
      @test typeof(hist) <: FrequencyWeights
    end
    @testset "Otsu threshold" begin
      img = matimage(rand(250, 400), 2)
      thresh = otsu_thresh(img)
      @test typeof(thresh) <: Integer
      @test 1 <= thresh <= 256
      @test_throws ArgumentError otsu_thresh(matimage(rand(250, 400), 3))
    end
    @testset "Segment" begin
      img_ = matimage(rand(250, 400), 3)
      img = matimage(rand(250, 400), 2)
      segment!(img)
      @test_throws ArgumentError segment!(img_)
      @test normal(img)
      @test segmented(img)
    end
  end
end
