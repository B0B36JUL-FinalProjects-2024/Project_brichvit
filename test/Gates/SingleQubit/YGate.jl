using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const y_mat = [0 -im; im 0]

@testset "YGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, YGate(q1))
		@test simulate_unitary(qc) == y_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, YGate(q1))
		@test simulate_unitary(qc) == kron(y_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, YGate(q2))
		@test simulate_unitary(qc) == kron(I(2), y_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, YGate(q1))
		push!(qc, inverse(YGate(q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(YGate(q1)))
		push!(qc, YGate(q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2 = Qubit("q1"), Qubit("q2")
		
		qc1 = QuantumCircuit(q1, q2)
		push!(qc1, controlled(YGate(q2), q1))

		qc2 = QuantumCircuit(q1, q2)
		push!(qc2, CYGate(q1, q2))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
