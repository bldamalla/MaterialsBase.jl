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
      img = matimage(rand(1000), (20, 50))
      @test size(img) == (20, 50)
      @test length(img) == 1000
      @test unique(img) == 2
      @test eltype(img) <: AbstractFloat
      @test segmented(img) == false
    end

    @testset "20 x 50 noise 3 discs non-normal" begin
      img = matimage(rand(1000), (20, 50), 3)
      @test size(img) == (20, 50)
      @test length(img) == 1000
      @test unique(img) == 3
      @test eltype(img) <: AbstractFloat
      @test segmented(img) == false
    end

    @testset "25 x 40 noise 5 discs normal" begin
      img = matimage(rand(linspace(0.0, 1.0, 4), 25, 40), 5)
      @test size(img) == (25, 40)
      @test length(img) == 1000
      @test unique(img) == 4
      @test eltype(img) <: AbstractFloat
      @test segmented(img) == true
      @test normal(img) == true
    end
  end

  # test if proper errors are thrown
  @testset "Improper images" begin
    @test_throws InexactError img = matimage(rand(1000), (20, 51), 2)
    @test_throws ArgumentError img = matimage(randn(1000), (20, 50), 2)
    @test_throws ArgumentError img = matimage(rand(1000), (20, 50), 1)
  end

  # test for equality for math operations
  @testset "Math Operations" begin
    @testset "Comparison Operators" begin
      @test matimage(rand(1000), (25, 40)) == matimage(rand(1000), (25, 40), 2)
      @test matimage(rand(1000), (25, 40)) != matimage(rand(1000), (25, 40), 3)
      @test matimage(rand(1000), (25, 40)) != matimage(rand(1000), (20, 50))
    end
    @testset "Compute Operators" begin
      case_mat = [1.0 2.0 3.0 2.0 1.0;
                  3.0 2.0 1.0 2.0 3.0]
      case_trans = transpose(case_mat)
      case_norm = [0.0 0.5 1.0 0.5 0.0;
                   1.0 0.5 0.0 0.5 1.0]
      A = matimage(case_mat, 3)
      ens_pass = [matimage(case_mat, 3), matimage(case_mat, 3), matimage(case_norm, 3), matimage(case_norm, 3)]
      ens_fail = [matimage(case_trans, 3), matimage(case_mat, 3), matimage(case_trans, 3), matimage(case_norm, 3)]
      @test begin normalize!(A); normal(A) end
      @test begin normalize!(A); (A == matimage(case_norm, 3)) & (A.states == vec(case_norm)) end
      @test_throws InexactError matimage(case_trans, 3) + matimage(case_mat, 3)
      @test (matimage(case_norm, 3) + matimage(case_norm, 3)) == (matimage(case_mat, 3) + matimage(case_mat, 3))
      @test normal(normal_mean(ens_pass)) == true
      @test_throws InexactError mean(ens_fail)
    end
  end
end
