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
    end
    println("math.jl tests took $(time() - math_time) seconds")
    println("Testing Linear")
    linear_time = time()
    @testset "Linear" begin
        for L ∈ (Line, LineSegment, Ray)
            p1, p2, p_0D = (0, 0), (1, 1), ()
            p1_floated, p2_floated, p1_mixed, p2_mixed = (0.0, 0.0), (1.0, 1.0), (0.0, 0), (1, 1.0)
            l, l_0D = L(p1, p2), L(p_0D, p_0D)

            @test l_0D isa L{0,Union{}}
            @test l isa L{2,Int}
            @test L(p1, p2_floated) isa L{2,Float64} # type promotion tuple level
            @test L(p1, p2_mixed) isa L{2,Real} # type promotion element level

            l2 = convert(L{2,Float64}, l)
            @test convert(L{2,Int}, l) === l
            @test l2 isa L{2,Float64}
            @test l2.point1 === p1_floated
            @test l2.point2 === p2_floated

            @test l[1] === p1
            @test l[2] === p2
            @test_throws BoundsError l[3]
            @test length(l) === 2
            @test collect(l) == [p1, p2]
            @test length(collect(l)) === 2
            @test collect(l_0D) == [p_0D, p_0D]

            @test p_0D ∈ l_0D

            @test isdegenerate(l_0D)
            for D ∈ 1:4
                p1, p2 = ntuple(zero, D), ntuple(_ -> 2, D)
                p_non_collinear, p_inner, p_before, p_after = ntuple(i -> i, D), ntuple(one, D), p1 .- 1, p2 .+ 0.5
                l, l_floated, l_flipped, l_degenerate = L(p1, p2), L(float.(p1), float.(p2)), L(p2, p1), L(p2, p2)
                l_non_collinear, l_parallel, l_extended_start, l_extended_end, l_contained = L(p1, p_non_collinear), L(p_non_collinear, p_non_collinear .+ 1), L(p_before, p2), L(p1, p_after), L(p1 .+ 0.5, p2 .- 0.5)

                @test p1 ∈ l # first endpoint
                @test p2 ∈ l # last endpoint
                @test p_inner ∈ l
                @test p2 ∈ l_degenerate

                @test l != l_0D
                @test l == l_floated # mixed types
                @test l != l_degenerate

                @test !any(isdegenerate, (l_floated, l_flipped, l_parallel, l_extended_start, l_extended_end, l_contained))
                @test isdegenerate(l_degenerate)

                @test all((i) -> isparallel(l, i), (l_floated, l_flipped, l_degenerate, l_parallel, l_extended_start, l_extended_end, l_contained))

                @test reduce(((acc, a), b) -> (acc &= iscollinear(a, b), b), (l_floated, l_flipped, l_degenerate, l_extended_start, l_extended_end, l_contained); init=(true, l))[1]

                if D == 1 # all points are collinear in 1D
                    @test isparallel(l, l_non_collinear)

                    @test iscollinear(l, l_non_collinear)
                    @test iscollinear(l, l_parallel)
                elseif D > 1
                    @test p_non_collinear ∉ l

                    @test l != l_non_collinear
                    @test l != l_parallel

                    @test !isparallel(l, l_non_collinear)

                    @test !iscollinear(l, l_non_collinear)
                    @test !iscollinear(l, l_parallel)
                end

                if L === Line
                    @test p_before ∈ l
                    @test p_after ∈ l

                    @test l == l_flipped
                    @test l == l_extended_start
                    @test l == l_extended_end
                    @test l == l_contained

                    @test distance(l) |> isinf
                elseif L === LineSegment
                    @test p_before ∉ l
                    @test p_after ∉ l

                    @test l == l_flipped
                    @test l != l_extended_start
                    @test l != l_extended_end
                    @test l != l_contained

                    @test distance(l) == √(reduce((i, j) -> i + j^2, p2; init=0))
                elseif L === Ray
                    @test p_before ∉ l
                    @test p_after ∈ l

                    @test l != l_flipped
                    @test l != l_extended_start
                    @test l == l_extended_end
                    @test l != l_contained

                    @test distance(l) |> isinf
                end
            end
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

        @test Line((), ()) != LineSegment((), ())
        @test Line((), ()) != Ray((), ())
        @test LineSegment((), ()) != Ray((), ())
    end
    println("Linear tests took $(time() - linear_time) seconds")
end

println("Total test time: $(time() - total_time) seconds")
