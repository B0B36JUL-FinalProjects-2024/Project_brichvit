using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

@testset "CRYGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError CRYGate(0, q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# CRY(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(0, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(0, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]

		# CRY(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π / 3, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(3)) / 2 -1 / 2; 0 0 1 / 2 sqrt(Sym(3)) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π / 3, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 sqrt(Sym(3)) / 2 0 -1 / 2; 0 0 1 0; 0 1 / 2 0 sqrt(Sym(3)) / 2]

		# CRY(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π / 2, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(2)) / 2 -sqrt(Sym(2)) / 2; 0 0 sqrt(Sym(2)) / 2 sqrt(Sym(2)) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π / 2, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 sqrt(Sym(2)) / 2 0 -sqrt(Sym(2)) / 2; 0 0 1 0; 0 sqrt(Sym(2)) / 2 0 sqrt(Sym(2)) / 2]

		# CRY(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(2 * π / 3, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 1 / 2 -sqrt(Sym(3)) / 2; 0 0 sqrt(Sym(3)) / 2 1 / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(2 * π / 3, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 / 2 0 -sqrt(Sym(3)) / 2; 0 0 1 0; 0 sqrt(Sym(3)) / 2 0 1 / 2]

		# CRY(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 0 -1; 0 0 1 0]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 0 0 -1; 0 0 1 0; 0 1 0 0]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# CRY(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(0, q1, q2))
		push!(qc, inverse(CRYGate(0, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(0, q1, q2)))
		push!(qc, CRYGate(0, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(0, q2, q1))
		push!(qc, inverse(CRYGate(0, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(0, q2, q1)))
		push!(qc, CRYGate(0, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRY(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π / 3, q1, q2))
		push!(qc, inverse(CRYGate(π / 3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(π / 3, q1, q2)))
		push!(qc, CRYGate(π / 3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π / 3, q2, q1))
		push!(qc, inverse(CRYGate(π / 3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(π / 3, q2, q1)))
		push!(qc, CRYGate(π / 3, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRY(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π / 2, q1, q2))
		push!(qc, inverse(CRYGate(π / 2, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(π / 2, q1, q2)))
		push!(qc, CRYGate(π / 2, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π / 2, q2, q1))
		push!(qc, inverse(CRYGate(π / 2, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(π / 2, q2, q1)))
		push!(qc, CRYGate(π / 2, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRY(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(2 * π / 3, q1, q2))
		push!(qc, inverse(CRYGate(2 * π / 3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(2 * π / 3, q1, q2)))
		push!(qc, CRYGate(2 * π / 3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(2 * π / 3, q2, q1))
		push!(qc, inverse(CRYGate(2 * π / 3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(2 * π / 3, q2, q1)))
		push!(qc, CRYGate(2 * π / 3, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRY(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π, q1, q2))
		push!(qc, inverse(CRYGate(π, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(π, q1, q2)))
		push!(qc, CRYGate(π, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRYGate(π, q2, q1))
		push!(qc, inverse(CRYGate(π, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRYGate(π, q2, q1)))
		push!(qc, CRYGate(π, q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
