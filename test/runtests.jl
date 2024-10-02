total_time = time()

using NShapes
using Test
using Aqua

println("loading dependencies took $(time() - total_time) seconds")

@testset "NShapes.jl" begin
    println("Testing Code quality (Aqua.jl)")
    aqua_time = time()
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(NShapes; unbound_args=false)
    end
    println("Code quality tests took $(time() - aqua_time) seconds")

    println("Testing math.jl")
    math_time = time()
    @testset "math.jl" begin
        include("./math.jl")
    end
    println("math.jl tests took $(time() - math_time) seconds")

    println("Testing Linears")
    linear_time = time()
    @testset "Linears" begin
        include("./linear.jl")
    end
    println("Linear tests took $(time() - linear_time) seconds")
end

println("Total test time: $(time() - total_time) seconds")
