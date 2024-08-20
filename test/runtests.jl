using NShapes
using Test
using Aqua

@testset "NShapes.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(NShapes)
    end
    # Write your tests here.
end
