using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

@testset "NegGate" begin
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, NegGate(q1, q2))
		@test simulate_unitary(qc) == [0 1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1]

		qc = QuantumCircuit(q1, q2)
		push!(qc, NegGate(q2, q1))
		@test simulate_unitary(qc) == [0 0 1 0; 0 1 0 0; 1 0 0 0; 0 0 0 1]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, NegGate(q1, q2))
		push!(qc, inverse(NegGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(NegGate(q1, q2)))
		push!(qc, NegGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, NegGate(q2, q1))
		push!(qc, inverse(NegGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(NegGate(q2, q1)))
		push!(qc, NegGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
