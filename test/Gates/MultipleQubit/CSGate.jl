using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

cs_gate = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 im]

@testset "CSGate" begin
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CSGate(q1, q2))
		@test simulate_unitary(qc) == cs_gate

		qc = QuantumCircuit(q1, q2)
		push!(qc, CSGate(q2, q1))
		@test simulate_unitary(qc) == cs_gate
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CSGate(q1, q2))
		push!(qc, inverse(CSGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CSGate(q1, q2)))
		push!(qc, CSGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CSGate(q2, q1))
		push!(qc, inverse(CSGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CSGate(q2, q1)))
		push!(qc, CSGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
