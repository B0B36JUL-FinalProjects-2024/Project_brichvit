module SymbolicQuantumSimulator

using PyCall
using SymPy

export Qubit
export QuantumCircuit, simulate_state_vector, simulate_unitary
export Instruction, is_unitary
export Gate, inverse
export HGate
export IGate
export PGate
export RXGate
export RYGate
export RZGate
export SGate
export TGate
export UGate
export XGate
export YGate
export ZGate

include("Qubit.jl")
include("Instruction.jl")
include("Gate.jl")
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
include("QuantumCircuit.jl")

end
