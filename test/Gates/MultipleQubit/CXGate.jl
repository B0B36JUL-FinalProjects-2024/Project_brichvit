using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

@testset "CXGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError CXGate(q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CXGate(q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 0 1; 0 0 1 0]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CXGate(q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 0 0 1; 0 0 1 0; 0 1 0 0]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CXGate(q1, q2))
		push!(qc, inverse(CXGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CXGate(q1, q2)))
		push!(qc, CXGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CXGate(q2, q1))
		push!(qc, inverse(CXGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CXGate(q2, q1)))
		push!(qc, CXGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
