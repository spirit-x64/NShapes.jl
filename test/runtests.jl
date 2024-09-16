total_time = time()

using NShapes
using Test
using Aqua

println("loading dependencies took $(time() - total_time) seconds")

@testset "NShapes.jl" begin
    aqua_time = time()
    println("Testing Code quality (Aqua.jl)")
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(NShapes; unbound_args=false)
    end
    println("Code quality tests took $(time() - aqua_time) seconds")

    math_time = time()
    println("Testing math.jl")
    @testset "math.jl" begin
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
            @test normalize((), ()) == () # empty tuples
            @test normalize((1, 0, 0)) == (1, 0, 0) # normalize vector
            @test normalize((1.0, 0, 0)) == (1, 0, 0) # different types
            @test normalize((1, 1, 1, 1), (2, 3, 4, 5)) == (1 / √30, 2 / √30, 3 / √30, 4 / √30) # normalize vector from origin
            @test normalize((1, 1, 1, 1.0), (2.0, 3, 4, 5)) == (1 / √30, 2 / √30, 3 / √30, 4 / √30) # different types
            @test normalize((-0.5, -0.5, -0.5), (0.5, 0.5, 0.5)) == (1 / √3, 1 / √3, 1 / √3) # fractional normalize
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
    end
    println("math.jl tests took $(time() - math_time) seconds")
    linear_time = time()
    @testset "Linear" begin
        for L in (Line, LineSegment, Ray)
            @test L((), ()) isa L{0,Union{}}
            @test L((1, 2), (3, 4)) isa L{2,Int}
            @test L((1, 2), (3.0, 4.0)) isa L{2,Float64} # type promotion tuple level
            @test L((1, 2), (3, 4.0)) isa L{2,Real} # type promotion element level

            l = L((0, 0), (1, 1))
            l2 = convert(L{2,Float64}, l)
            @test convert(L{2,Int}, l) === l
            @test l2 isa L{2,Float64}
            @test l2.first_point == (0.0, 0.0)
            @test l2.last_point == (1.0, 1.0)

            l = L((0, 0), (1, 1))
            @test l[1] == (0, 0)
            @test l[2] == (1, 1)
            @test_throws BoundsError l[3]
            @test length(l) == 2
            @test collect(l) == [(0, 0), (1, 1)]
            @test length(collect(l)) == 2
            @test collect(L((), ())) == [(), ()] # 0D
        end
        @test convert(Line{2,Int}, LineSegment((1.0, 2.0), (3.0, 4.0))) isa Line{2,Int}
        @test convert(Line{2,Int}, Ray((1.0, 2.0), (3, 4))) isa Line{2,Int}
        @test convert(LineSegment{2,Int}, Line((1.0, 2), (3, 4))) isa LineSegment{2,Int}
        @test convert(LineSegment{2,Int}, Ray((1.0, 2.0), (3, 4.0))) isa LineSegment{2,Int}
        @test convert(Ray{2,Int}, Line((1, 2), (3, 4))) isa Ray{2,Int}
        @test convert(Ray{2,Int}, LineSegment((1, 2), (3, 4))) isa Ray{2,Int}

        @test sprint(show, Line((0, 0), (1, 1))) == "<(0, 0)↔(1, 1)>"
        @test sprint(show, LineSegment((0, 0), (1, 1))) == "<(0, 0)―(1, 1)>"
        @test sprint(show, Ray((0, 0), (1, 1))) == "<(0, 0)→(1, 1)>"
    end
    println("Linear tests took $(time() - linear_time) seconds")
end

println("Total test time: $(time() - total_time) seconds")
