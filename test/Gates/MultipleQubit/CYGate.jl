using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

@testset "CYGate" begin
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CYGate(q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 0 -im; 0 0 im 0]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CYGate(q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 0 0 -im; 0 0 1 0; 0 im 0 0]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CYGate(q1, q2))
		push!(qc, inverse(CYGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CYGate(q1, q2)))
		push!(qc, CYGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CYGate(q2, q1))
		push!(qc, inverse(CYGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CYGate(q2, q1)))
		push!(qc, CYGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
