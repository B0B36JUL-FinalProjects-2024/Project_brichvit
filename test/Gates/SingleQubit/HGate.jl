using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const h_mat = sqrt(Sym(2)) / 2 * [1 1; 1 -1]

@testset "HGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, HGate(q1))
		@test simulate_unitary(qc) == h_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, HGate(q1))
		@test simulate_unitary(qc) == kron(h_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, HGate(q2))
		@test simulate_unitary(qc) == kron(I(2), h_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, HGate(q1))
		push!(qc, inverse(HGate(q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(HGate(q1)))
		push!(qc, HGate(q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2 = Qubit("q1"), Qubit("q2")
		
		qc1 = QuantumCircuit(q1, q2)
		push!(qc1, controlled(HGate(q2), q1))

		qc2 = QuantumCircuit(q1, q2)
		push!(qc2, CHGate(q1, q2))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
