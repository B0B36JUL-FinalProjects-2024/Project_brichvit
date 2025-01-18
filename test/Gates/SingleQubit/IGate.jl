using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

@testset "IGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, IGate(q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, IGate(q1))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, IGate(q2))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		qc = QuantumCircuit(q1)
		push!(qc, IGate(q1))
		push!(qc, inverse(IGate(q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(IGate(q1)))
		push!(qc, IGate(q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
