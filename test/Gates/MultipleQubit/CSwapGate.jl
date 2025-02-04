using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

cswap_gate_control_1 = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 1 0 0 0 0; 0 0 0 0 1 0 0 0; 0 0 0 0 0 0 1 0; 0 0 0 0 0 1 0 0; 0 0 0 0 0 0 0 1]
cswap_gate_control_2 = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 0 0 0 1 0; 0 0 0 0 1 0 0 0; 0 0 0 0 0 1 0 0; 0 0 0 1 0 0 0 0; 0 0 0 0 0 0 0 1]
cswap_gate_control_3 = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 0 0 1 0 0; 0 0 0 0 1 0 0 0; 0 0 0 1 0 0 0 0; 0 0 0 0 0 0 1 0; 0 0 0 0 0 0 0 1]

@testset "CSwapGate" begin
	@testset "Constructor" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		@test_throws ArgumentError CSwapGate(q1, q1, q1)
		@test_throws ArgumentError CSwapGate(q1, q1, q2)
		@test_throws ArgumentError CSwapGate(q1, q2, q1)
		@test_throws ArgumentError CSwapGate(q2, q1, q1)
	end
	@testset "Three qubits" begin
		q1, q2, q3 = Qubit("q1"), Qubit("q2"), Qubit("q3")

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q1, q2, q3))
		@test simulate_unitary(qc) == cswap_gate_control_1

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q1, q3, q2))
		@test simulate_unitary(qc) == cswap_gate_control_1

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q2, q1, q3))
		@test simulate_unitary(qc) == cswap_gate_control_2

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q2, q3, q1))
		@test simulate_unitary(qc) == cswap_gate_control_2

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q3, q1, q2))
		@test simulate_unitary(qc) == cswap_gate_control_3

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q3, q2, q1))
		@test simulate_unitary(qc) == cswap_gate_control_3
	end
	@testset "inverse" begin
		q1, q2, q3 = Qubit("q1"), Qubit("q2"), Qubit("q3")

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q1, q2, q3))
		push!(qc, inverse(CSwapGate(q1, q2, q3)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CSwapGate(q1, q2, q3)))
		push!(qc, CSwapGate(q1, q2, q3))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q1, q3, q2))
		push!(qc, inverse(CSwapGate(q1, q3, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CSwapGate(q1, q3, q2)))
		push!(qc, CSwapGate(q1, q3, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q2, q1, q3))
		push!(qc, inverse(CSwapGate(q2, q1, q3)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CSwapGate(q2, q1, q3)))
		push!(qc, CSwapGate(q2, q1, q3))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q2, q3, q1))
		push!(qc, inverse(CSwapGate(q2, q3, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CSwapGate(q2, q3, q1)))
		push!(qc, CSwapGate(q2, q3, q1))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q3, q1, q2))
		push!(qc, inverse(CSwapGate(q3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CSwapGate(q3, q1, q2)))
		push!(qc, CSwapGate(q3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CSwapGate(q3, q2, q1))
		push!(qc, inverse(CSwapGate(q3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CSwapGate(q3, q2, q1)))
		push!(qc, CSwapGate(q3, q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
