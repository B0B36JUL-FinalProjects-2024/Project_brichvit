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
	include("Gates/MultipleQubit/CHGate.jl")
	include("Gates/MultipleQubit/CPGate.jl")
	include("Gates/MultipleQubit/CRXGate.jl")
	include("Gates/MultipleQubit/CRYGate.jl")
	include("Gates/MultipleQubit/CRZGate.jl")
	include("Gates/MultipleQubit/CSGate.jl")
	include("Gates/MultipleQubit/CTGate.jl")
	include("Gates/MultipleQubit/CUGate.jl")
	include("Gates/MultipleQubit/CXGate.jl")
	include("Gates/MultipleQubit/CYGate.jl")
	include("Gates/MultipleQubit/CZGate.jl")
	include("Gates/MultipleQubit/CCXGate.jl")
	include("Gates/MultipleQubit/SwapGate.jl")
	include("Gates/MultipleQubit/CSwapGate.jl")
end
