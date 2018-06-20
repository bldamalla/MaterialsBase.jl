using MaterialsBase
@static if VERSION < v"0.7.0-DEV.2005"
  using Base.Test
else
  using Test
end

@testset "MaterialImage struct" begin

  # test if an image is properly produced
  @testset "Proper images" begin
    @testset "20 x 50 noise non-normal" begin
      @test img = MaterialImage(rand(1000), (20, 50))
      @test size(img) == (20, 50)
      @test length(img) == 1000
      @test unique(img) == 2
      @test eltype(img) <: AbstractFloat
      @test segmented(img) == false
    end

    @testset "20 x 50 noise 3 discs non-normal" begin
      @test img = MaterialImage(rand(1000), (20, 50), 3)
      @test size(img) == (20, 50)
      @test length(img) == 1000
      @test unique(img) == 3
      @test eltype(img) <: AbstractFloat
      @test segmented(img) == false
    end

    @testset "25 x 40 noise 5 discs normal" begin
      @test img = MaterialImage([rand(linspace(0.0, 1.0, 4), 25, 40], 5)
      @test size(img) == (25, 40)
      @test length(img) == 1000
      @test unique(img) == 4
      @test eltype(img) <: AbstractFloat
      @test segmented(img) == true
    end
  end

  # test if proper errors are thrown
  @testset "Improper images" begin
    @test_throws InitError img = MaterialImage(rand(1000), (20, 51), 2)
    @test_throws InitError img = MaterialImage(randn(1000), (20, 50), 2)
  end

  # test for equality for math operations

  # test if errors are thrown when necessary

end
