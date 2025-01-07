using SymbolicQuantumSimulator
using Test
using Aqua

@testset "SymbolicQuantumSimulator.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(SymbolicQuantumSimulator)
    end
    # Write your tests here.
end
