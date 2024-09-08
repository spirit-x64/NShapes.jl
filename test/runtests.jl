using NShapes
using Test
using Aqua

@testset "NShapes.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(NShapes; unbound_args = false)
    end
    # Write your tests here.
end
