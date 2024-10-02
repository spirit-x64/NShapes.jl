@testset "distance² and distance" begin
    @test distance²(()) ≈ 0 # empty tuple
    @test distance²((), ()) ≈ 0 # empty tuples
    @test distance²((3, 4)) ≈ 25 # magnitude_sq
    @test distance²((3, 4.0)) ≈ 25 # magnitude_sq diffrent types
    @test distance²((-1, -1), (1, 1)) ≈ 8 # distance_sq
    @test distance²((-1, -1.0), (1.0, 1)) ≈ 8 # distance_sq diffrent types
    @test distance²((0, 0, 0)) ≈ 0 # zero magnitude_sq
    @test distance²((1, 2, 3), (1, 2, 3)) ≈ 0 # zero distance_sq (same point)
    @test distance(()) ≈ 0 # empty tuple
    @test distance((), ()) ≈ 0 # empty tuples
    @test distance((3, 4)) ≈ 5 # magnitude
    @test distance((3.0, 4)) ≈ 5 # magnitude diffrent types
    @test distance((1, 1), (4, 5)) ≈ 5 # distance
    @test distance((1.0, 1), (4, 5.0)) ≈ 5 # distance diffrent types
    @test distance((-1, -1), (1, 1)) ≈ 2 * √2 # fractional distance
    @test distance((0, 0, 0)) ≈ 0 # zero magnitude
    @test distance((1, 2, 3), (1, 2, 3)) ≈ 0 # zero distance (same point)
end

@testset "normalize" begin
    @test normalize(()) == () # empty tuple
    @test normalize((1, 0, 0)) == (1, 0, 0) # normalize vector
    @test normalize((1.0, 0, 0)) == (1, 0, 0) # different types
    @test normalize((1, 1, 1)) == (1 / √3, 1 / √3, 1 / √3) # fractional normalize
end

@testset "iscollinear" begin
    # iscollinear(Vector, Vector)

    @test iscollinear((), ()) # always true
    @test iscollinear((1,), (2,)) # always true

    @test iscollinear((1, 2), (2, 4))
    @test iscollinear((1.0, 2.0), (2, 4))  # Different types
    @test iscollinear((1, 0, -3), (-2, 0, 6))

    @test iscollinear((0, 0), (0, 0))
    @test iscollinear((0, 0, 0), (0, 0, 0))

    @test !iscollinear((1, 2), (2, 3))
    @test !iscollinear((1, 0, -3), (0, 1, 0))
    @test !iscollinear((1.0, 2.0, 3), (2, 4, 5.0))

    # iscollinear(Point, Point, Point)

    # always true for 0D and 1D
    @test iscollinear((), (), ())
    @test iscollinear((1,), (2,), (3,))

    @test iscollinear((1, 2), (3, 4), (5, 6))
    @test iscollinear((1, 2), (3.0, 4.0), (5.0, 6))  # Different types
    @test iscollinear((1, 0, -3), (-2, 0, 6), (-3, 0, 9))
    @test iscollinear((4, 4, 4, 4), (1, 1, 1, 1), (-2, -2, -2, -2))

    @test iscollinear((0, 0), (0, 0), (0, 0))
    @test iscollinear((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0))

    @test !iscollinear((1, 2), (3, 4), (5, 7))
    @test !iscollinear((1, 0, -3), (0, 1, 0), (-3, 0, 1))
end

@testset "norm" begin
    @test NShapes.norm(()) ≈ 0 # empty tuple
    @test NShapes.norm((1, 2, 3)) ≈ 6
    @test NShapes.norm((-1, -2, -3)) ≈ 6
    @test NShapes.norm((0, 0, 0)) ≈ 0
    @test NShapes.norm((5,)) ≈ 5
end

@testset "lerp" begin
    @test NShapes.lerp(10, 20, 0.5) == 15
    @test NShapes.lerp(10, 20, 0) == 10
    @test NShapes.lerp(10, 20, 1) == 20
    @test NShapes.lerp(10, 20, -1) == 0
    @test NShapes.lerp(10, 20, 2) == 30
    @test NShapes.lerp(1, 5, Inf) |> isinf
end

@testset "dot" begin
    @test NShapes.dot((), ()) ≈ 0 # empty tuples
    @test NShapes.dot((1, 2), (3, 4)) ≈ 11
    @test NShapes.dot((1, 2, 3), (4, 5, 6)) ≈ 32
    @test NShapes.dot((0, 0), (1, 1)) ≈ 0
    @test NShapes.dot((-1, -2), (1, 2)) ≈ -5
    @test NShapes.dot((1, 2, 3), (4, 5, Inf)) |> isinf
    @test NShapes.dot((Inf, 2), (-Inf, 4)) |> isinf
end

@testset "det" begin
    @test NShapes.det((1, 2), (3, 4)) ≈ -2
    @test NShapes.det((0, 0), (1, 1), (2, 2)) ≈ 0
    @test NShapes.det((1, 0), (0, 1), (0, 0)) ≈ 1
    @test NShapes.det((1, 0, 0), (0, 1, 0), (0, 0, 1)) ≈ 1
    @test NShapes.det((2, 3, 4), (5, 6, 7), (8, 9, 10)) ≈ 0
    @test NShapes.det((1, 0), (0, 0.5)) ≈ 0.5
    @test NShapes.det((Inf, 0), (0, 1)) |> isinf
end

@testset "cross" begin
    @test NShapes.cross((1, 2), (3, 4)) == -2
    @test NShapes.cross((-2, 5), (1, -3)) == 1
    # Zero vectors
    @test NShapes.cross((0, 0), (1, 2)) == 0
    @test NShapes.cross((3, 4), (0, 0)) == 0
    # Collinear vectors
    @test NShapes.cross((1, 1), (2, 2)) == 0
    @test NShapes.cross((-3, -6), (1, 2)) == 0
    # Orthogonal vectors
    @test NShapes.cross((1, 0), (0, 1)) == 1
    @test NShapes.cross((0, -1), (1, 0)) == 1

    @test NShapes.cross((1, 2, 3), (4, 5, 6)) == (-3, 6, -3)
    @test NShapes.cross((-2, 0, 1), (3, -1, 4)) == (1, 11, 2)
    # Zero vectors
    @test NShapes.cross((0, 0, 0), (1, 2, 3)) == (0, 0, 0)
    @test NShapes.cross((3, 4, 5), (0, 0, 0)) == (0, 0, 0)
    # Collinear vectors
    @test NShapes.cross((1, 1, 1), (2, 2, 2)) == (0, 0, 0)
    @test NShapes.cross((-3, -6, -9), (1, 2, 3)) == (0, 0, 0)
    # Orthogonal vectors (standard basis vectors)
    @test NShapes.cross((1, 0, 0), (0, 1, 0)) == (0, 0, 1)
    @test NShapes.cross((0, 1, 0), (0, 0, 1)) == (1, 0, 0)
    @test NShapes.cross((0, 0, 1), (1, 0, 0)) == (0, 1, 0)
end

@testset "div_no_inf" begin
    @test NShapes.div_no_inf(Inf, 1) == 0 # `a` is Inf
    @test NShapes.div_no_inf(1, 0) == 0 # Division by zero
    @test NShapes.div_no_inf(4, 2) == 2 # Normal division
    @test NShapes.div_no_inf(NaN, 1) |> isnan
    @test NShapes.div_no_inf(1, NaN) |> isnan
end

@testset "isproportional" begin
    # always true for 0D and 1D
    @test NShapes.isproportional((), ())
    @test NShapes.isproportional((1,), (2,))

    @test NShapes.isproportional((0, 0), (0, 0))
    @test NShapes.isproportional((0, 0, 0), (0, 0, 0))

    @test NShapes.isproportional((1, -2), (-2, 4))
    @test NShapes.isproportional((1.0, 2), (2, 4.0))

    @test NShapes.isproportional((1, 2, 3), (2, 4, 6))
    @test NShapes.isproportional((1, -1, 0, 3), (-2, 2, 0, -6))

    @test !NShapes.isproportional((1, 2), (2, 3))
    @test !NShapes.isproportional((1, 0), (0, 1))
    @test !NShapes.isproportional((1, 2, 3), (2, 4, 5))
end
