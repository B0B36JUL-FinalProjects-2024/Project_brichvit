module SymbolicQuantumSimulator

using PyCall
using SymPy

export Qubit
export QuantumRegister
export Instruction, is_unitary
export Measurement
export Barrier
export Gate, inverse, controlled
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
export CHGate
export CPGate
export CRXGate
export CRYGate
export CRZGate
export CSGate
export CTGate
export CUGate
export CXGate
export CYGate
export CZGate
export CCXGate
export SwapGate
export CSwapGate
export NegGate
export AndGate
export OrGate
export QuantumCircuit, simulate_measurements, simulate_state_vector, simulate_unitary
export circuit_to_gate
export draw

include("Qubit.jl")
include("QuantumRegister.jl")
include("Instruction.jl")
include("Measurement.jl")
include("Barrier.jl")
include("Gate.jl")
include("Gates/SingleQubit/SingleQubitGate.jl")
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
include("Gates/MultipleQubit/ControlledGate.jl")
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
include("Gates/Boolean/NegGate.jl")
include("Gates/Boolean/AndGate.jl")
include("Gates/Boolean/OrGate.jl")
include("QuantumCircuit.jl")
include("Gates/CompositeGate.jl")
include("Gates/MultipleQubit/ControlledCompositeGate.jl")
include("Visualization/Draw.jl")

# Function definition for the StatsPlotsExt extension
function plot_measurements end

export plot_measurements

end
