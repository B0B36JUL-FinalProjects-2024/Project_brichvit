using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const s_mat = [1 0; 0 im]

@testset "SGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, SGate(q1))
		@test simulate_unitary(qc) == s_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, SGate(q1))
		@test simulate_unitary(qc) == kron(s_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, SGate(q2))
		@test simulate_unitary(qc) == kron(I(2), s_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, SGate(q1))
		push!(qc, inverse(SGate(q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(SGate(q1)))
		push!(qc, SGate(q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2 = Qubit("q1"), Qubit("q2")
		
		qc1 = QuantumCircuit(q1, q2)
		push!(qc1, controlled(SGate(q2), q1))

		qc2 = QuantumCircuit(q1, q2)
		push!(qc2, CSGate(q1, q2))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
