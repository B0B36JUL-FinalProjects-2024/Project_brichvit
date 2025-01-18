using SymbolicQuantumSimulator
using Test
using Aqua

@testset "SymbolicQuantumSimulator.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(SymbolicQuantumSimulator)
    end

    include("QuantumCircuit.jl")
	include("Gates/SingleQubit/HGate.jl")
	include("Gates/SingleQubit/IGate.jl")
	include("Gates/SingleQubit/PGate.jl")
	include("Gates/SingleQubit/RXGate.jl")
	include("Gates/SingleQubit/RYGate.jl")
	include("Gates/SingleQubit/RZGate.jl")
	include("Gates/SingleQubit/SGate.jl")
	include("Gates/SingleQubit/TGate.jl")
	include("Gates/SingleQubit/UGate.jl")
	include("Gates/SingleQubit/XGate.jl")
	include("Gates/SingleQubit/YGate.jl")
	include("Gates/SingleQubit/ZGate.jl")
end
