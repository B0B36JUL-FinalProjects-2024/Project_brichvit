using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

@testset "CHGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError CHGate(q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CHGate(q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(2)) / 2 sqrt(Sym(2)) / 2; 0 0 sqrt(Sym(2)) / 2 -sqrt(Sym(2)) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CHGate(q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 sqrt(Sym(2)) / 2 0 sqrt(Sym(2)) / 2; 0 0 1 0; 0 sqrt(Sym(2)) / 2 0 -sqrt(Sym(2)) / 2]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CHGate(q1, q2))
		push!(qc, inverse(CHGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CHGate(q1, q2)))
		push!(qc, CHGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CHGate(q2, q1))
		push!(qc, inverse(CHGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CHGate(q2, q1)))
		push!(qc, CHGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
