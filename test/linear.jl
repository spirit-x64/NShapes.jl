p1, p2, p1_floated, p2_floated, p1_mixed, p2_mixed,
p_inner, p_before, p_after, p_non_collinear = ([] for _ ∈ 1:typemax(Int))

linears = NamedTuple((i => NamedTuple((i => [] for i ∈ (
    :original, :floated, :mixed, :flipped,
    :degenerate, :non_collinear, :parallel,
    :contained, :extended_start, :extended_end
))) for i ∈ (:Line, :LineSegment, :Ray)))

for D ∈ 1:4
    _p1, _p2 = ntuple(_ -> 0, D), ntuple(_ -> 2, D)
    push!(p1, _p1)
    push!(p2, _p2)

    push!(p1_floated, float.(_p1))
    push!(p2_floated, float.(_p2))

    push!(p1_mixed, (0, float.(_p1[2:end])...))
    push!(p2_mixed, (2, float.(_p2[2:end])...))

    push!(p_inner, ntuple(one, D))
    push!(p_before, _p1 .- 1)
    push!(p_after, _p2 .+ 0.5)

    push!(p_non_collinear, ntuple(i -> i, D))

    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i)

        push!(l.original, L(p1[D], p2[D]))

        push!(l.floated, L(float.(p1[D]), float.(p2[D])))
        push!(l.mixed, L((0, float.(p1[D][2:end])...), (2, float.(p2[D][2:end])...)))
        push!(l.flipped, L(p2[D], p1[D]))

        push!(l.degenerate, L(p2[D], p2[D]))

        push!(l.non_collinear, L(p1[D], p_non_collinear[D]))
        push!(l.parallel, L(p_non_collinear[D], p_non_collinear[D] .+ 1))

        push!(l.extended_start, L(p_before[D], p2[D]))
        push!(l.extended_end, L(p1[D], p_after[D]))

        push!(l.contained, L(p1[D] .+ 0.5, p2[D] .- 0.5))
    end
end

@testset "construction" begin
    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i).original[2]

        @test L((), ()) isa L{0,Union{}}
        @test l isa L{2,Int}
        @test L(p1[2], p2_floated[2]) isa L{2,Float64} # type promotion tuple level
        @test L(p1[2], p2_mixed[2]) isa L{2,Real} # type promotion element level
    end
end

@testset "printing" begin
    @test sprint(show, Line((0, 0), (1, 1))) === "<(0, 0)↔(1, 1)>"
    @test sprint(show, LineSegment((0, 0), (1, 1))) === "<(0, 0)―(1, 1)>"
    @test sprint(show, Ray((0, 0), (1, 1))) === "<(0, 0)→(1, 1)>"
end

@testset "Indexing and Iteration" begin
    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i).original[2]

        @test l[1] === p1[2]
        @test l[2] === p2[2]
        @test_throws BoundsError l[3]
        @test length(l) === 2
        @test collect(l) == [p1[2], p2[2]]
        @test length(collect(l)) === 2
        @test collect(L((), ())) == [(), ()]
    end
end

@testset "conversion" begin
    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i).original[2]

        @test convert(L{2,Int}, l) === l
        @test convert(L{2,Float64}, l) isa L{2,Float64}
        @test convert(L{2,Float64}, l).point1 === p1_floated[2]
        @test convert(L{2,Float64}, l).point2 === p2_floated[2]
    end

    @test convert(Line{2,Int}, LineSegment((1.0, 2.0), (3.0, 4.0))) isa Line{2,Int}
    @test convert(Line{2,Int}, Ray((1.0, 2.0), (3, 4))) isa Line{2,Int}
    @test convert(LineSegment{2,Int}, Line((1.0, 2), (3, 4))) isa LineSegment{2,Int}
    @test convert(LineSegment{2,Int}, Ray((1.0, 2.0), (3, 4.0))) isa LineSegment{2,Int}
    @test convert(Ray{2,Int}, Line((1, 2), (3, 4))) isa Ray{2,Int}
    @test convert(Ray{2,Int}, LineSegment((1, 2), (3, 4))) isa Ray{2,Int}
end

@testset "in(Point, Linear) - ∈ and ∉ operators" begin
    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i)

        @test () ∈ L((), ()) # 0D case

        p_non_collinear[1] ∈ l.original[1]

        for D ∈ 1:4
            @test p1[D] ∈ l.original[D] # first endpoint
            @test p2[D] ∈ l.original[D] # last endpoint
            @test p_inner[D] ∈ l.original[D]

            @test p2[D] ∈ l.degenerate[D]
            @test p_before[D] ∉ l.degenerate[D]
            @test p_after[D] ∉ l.degenerate[D]

            D > 1 && @test p_non_collinear[D] ∉ l.original[D]
        end
    end

    for D ∈ 1:4
        @test p_before[D] ∈ linears.Line.original[D]
        @test p_after[D] ∈ linears.Line.original[D]

        @test p_before[D] ∉ linears.LineSegment.original[D]
        @test p_after[D] ∉ linears.LineSegment.original[D]

        @test p_before[D] ∉ linears.Ray.original[D]
        @test p_after[D] ∈ linears.Ray.original[D]
    end
end

@testset "equality" begin
    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i)

        @test L((), ()) == L((), ())

        for D ∈ 1:2
            @test l.original[D] != L((), ())
            @test l.original[D] == l.floated[D]
            @test l.original[D] != l.degenerate[D]
        end

        @test l.original[2] == l.mixed[2]

        @test l.original[2] != l.non_collinear[2]
        @test l.original[2] != l.parallel[2]
    end

    for D ∈ 1:2
        @test linears.Line.original[D] == linears.Line.flipped[D]
        @test linears.Line.original[D] == linears.Line.extended_start[D]
        @test linears.Line.original[D] == linears.Line.extended_end[D]
        @test linears.Line.original[D] == linears.Line.contained[D]

        @test linears.LineSegment.original[D] == linears.LineSegment.flipped[D]
        @test linears.LineSegment.original[D] != linears.LineSegment.extended_start[D]
        @test linears.LineSegment.original[D] != linears.LineSegment.extended_end[D]
        @test linears.LineSegment.original[D] != linears.LineSegment.contained[D]

        @test linears.Ray.original[D] != linears.Ray.flipped[D]
        @test linears.Ray.original[D] != linears.Ray.extended_start[D]
        @test linears.Ray.original[D] == linears.Ray.extended_end[D]
        @test linears.Ray.original[D] != linears.Ray.contained[D]
    end

    @test Line((), ()) != LineSegment((), ())
    @test Line((), ()) != Ray((), ())
    @test LineSegment((), ()) != Ray((), ())
end

@testset "distance(Linear)" begin
    for i ∈ keys(linears)
        L = getproperty(NShapes, i)
        @test distance(L((), ())) == 0
    end

    for D ∈ 1:2
        @test distance(linears.Line.original[D]) |> isinf
        @test distance(linears.LineSegment.original[D]) === √(reduce((i, j) -> i + j^2, p2[D]; init=0)) # expecting p1 to be at 0
        @test distance(linears.Ray.original[D]) |> isinf
    end
end

@testset "isdegenerate(Linear)" begin
    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i)

        @test isdegenerate(L((), ())) # 0D case

        for D ∈ 1:2
            @test isdegenerate(l.degenerate[D])

            for not_degenerate ∈ (l.floated[D], l.mixed[D], l.flipped[D], l.parallel[D], l.extended_start[D], l.extended_end[D], l.contained[D])
                @test !isdegenerate(not_degenerate)
            end
        end
    end
end

@testset "isparallel(Linear, Linear)" begin
    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i)

        @test isparallel(L((), ()), L((), ())) # 0D case

        for D ∈ 1:3
            for parallel ∈ (l.floated[D], l.mixed[D], l.flipped[D], l.degenerate[D], l.parallel[D], l.extended_start[D], l.extended_end[D], l.contained[D])
                @test isparallel(l.original[D], parallel)
            end

            D > 1 && @test !isparallel(l.original[D], l.non_collinear[D])
        end

        @test isparallel(l.original[1], l.non_collinear[1])
    end
end

@testset "iscollinear(Linear, Linear)" begin
    for i ∈ keys(linears)
        L, l = getproperty(NShapes, i), getfield(linears, i)

        @test iscollinear(L((), ()), L((), ())) # 0D case

        for D ∈ 1:3
            for collinear ∈ (l.floated[D], l.mixed[D], l.flipped[D], l.degenerate[D], l.extended_start[D], l.extended_end[D], l.contained[D])
                @test iscollinear(l.original[D], collinear)
            end

            if D > 1
                @test !iscollinear(l.original[D], l.non_collinear[D])
                @test !iscollinear(l.original[D], l.parallel[D])
            end
        end

        @test iscollinear(l.original[1], l.non_collinear[1])
        @test iscollinear(l.original[1], l.parallel[1])
    end
end
