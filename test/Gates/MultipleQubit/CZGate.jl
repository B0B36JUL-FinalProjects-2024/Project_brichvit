using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

cz_gate = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 -1]

@testset "CZGate" begin
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CZGate(q1, q2))
		@test simulate_unitary(qc) == cz_gate

		qc = QuantumCircuit(q1, q2)
		push!(qc, CZGate(q2, q1))
		@test simulate_unitary(qc) == cz_gate
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CZGate(q1, q2))
		push!(qc, inverse(CZGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CZGate(q1, q2)))
		push!(qc, CZGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CZGate(q2, q1))
		push!(qc, inverse(CZGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CZGate(q2, q1)))
		push!(qc, CZGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
