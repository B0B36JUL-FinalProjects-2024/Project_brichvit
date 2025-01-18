using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const t_mat = [1 0; 0 exp(im * PI / 4)]

@testset "TGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, TGate(q1))
		@test simulate_unitary(qc) == t_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, TGate(q1))
		@test simulate_unitary(qc) == kron(t_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, TGate(q2))
		@test simulate_unitary(qc) == kron(I(2), t_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, TGate(q1))
		push!(qc, inverse(TGate(q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(TGate(q1)))
		push!(qc, TGate(q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
