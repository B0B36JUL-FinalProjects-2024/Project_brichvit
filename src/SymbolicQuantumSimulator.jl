module SymbolicQuantumSimulator

using SymPy

export Qubit
export QuantumCircuit, simulate_state_vector, simulate_unitary
export Instruction, is_unitary
export Gate

include("Qubit.jl")
include("Instruction.jl")
include("Gate.jl")
include("QuantumCircuit.jl")

end
