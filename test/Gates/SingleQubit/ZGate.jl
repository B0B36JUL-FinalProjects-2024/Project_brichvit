using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const z_mat = [1 0; 0 -1]

@testset "ZGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, ZGate(q1))
		@test simulate_unitary(qc) == z_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, ZGate(q1))
		@test simulate_unitary(qc) == kron(z_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, ZGate(q2))
		@test simulate_unitary(qc) == kron(I(2), z_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, ZGate(q1))
		push!(qc, inverse(ZGate(q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(ZGate(q1)))
		push!(qc, ZGate(q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2 = Qubit("q1"), Qubit("q2")
		
		qc1 = QuantumCircuit(q1, q2)
		push!(qc1, controlled(ZGate(q2), q1))

		qc2 = QuantumCircuit(q1, q2)
		push!(qc2, CZGate(q1, q2))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
