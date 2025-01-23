using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

swap_gate = [1 0 0 0; 0 0 1 0; 0 1 0 0; 0 0 0 1]

@testset "SwapGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError SwapGate(q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, SwapGate(q1, q2))
		@test simulate_unitary(qc) == swap_gate

		qc = QuantumCircuit(q1, q2)
		push!(qc, SwapGate(q2, q1))
		@test simulate_unitary(qc) == swap_gate
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, SwapGate(q1, q2))
		push!(qc, inverse(SwapGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(SwapGate(q1, q2)))
		push!(qc, SwapGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, SwapGate(q2, q1))
		push!(qc, inverse(SwapGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(SwapGate(q2, q1)))
		push!(qc, SwapGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
