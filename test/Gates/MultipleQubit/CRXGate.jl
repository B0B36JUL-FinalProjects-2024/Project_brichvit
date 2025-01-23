using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

@testset "CRXGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError CRXGate(0, q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# CRX(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(0, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(0, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]

		# CRX(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π / 3, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(3)) / 2 -im / 2; 0 0 -im / 2 sqrt(Sym(3)) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π / 3, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 sqrt(Sym(3)) / 2 0 -im / 2; 0 0 1 0; 0 -im / 2 0 sqrt(Sym(3)) / 2]

		# CRX(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π / 2, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(2)) / 2 -im * sqrt(Sym(2)) / 2; 0 0 -im * sqrt(Sym(2)) / 2 sqrt(Sym(2)) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π / 2, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 sqrt(Sym(2)) / 2 0 -im * sqrt(Sym(2)) / 2; 0 0 1 0; 0 -im * sqrt(Sym(2)) / 2 0 sqrt(Sym(2)) / 2]

		# CRX(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(2 * π / 3, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 1 / 2 -im * sqrt(Sym(3)) / 2; 0 0 -im * sqrt(Sym(3)) / 2 1 / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(2 * π / 3, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 / 2 0 -im * sqrt(Sym(3)) / 2; 0 0 1 0; 0 -im * sqrt(Sym(3)) / 2 0 1 / 2]

		# CRX(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 0 -im; 0 0 -im 0]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 0 0 -im; 0 0 1 0; 0 -im 0 0]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# CRX(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(0, q1, q2))
		push!(qc, inverse(CRXGate(0, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(0, q1, q2)))
		push!(qc, CRXGate(0, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(0, q2, q1))
		push!(qc, inverse(CRXGate(0, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(0, q2, q1)))
		push!(qc, CRXGate(0, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRX(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π / 3, q1, q2))
		push!(qc, inverse(CRXGate(π / 3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(π / 3, q1, q2)))
		push!(qc, CRXGate(π / 3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π / 3, q2, q1))
		push!(qc, inverse(CRXGate(π / 3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(π / 3, q2, q1)))
		push!(qc, CRXGate(π / 3, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRX(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π / 2, q1, q2))
		push!(qc, inverse(CRXGate(π / 2, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(π / 2, q1, q2)))
		push!(qc, CRXGate(π / 2, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π / 2, q2, q1))
		push!(qc, inverse(CRXGate(π / 2, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(π / 2, q2, q1)))
		push!(qc, CRXGate(π / 2, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRX(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(2 * π / 3, q1, q2))
		push!(qc, inverse(CRXGate(2 * π / 3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(2 * π / 3, q1, q2)))
		push!(qc, CRXGate(2 * π / 3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(2 * π / 3, q2, q1))
		push!(qc, inverse(CRXGate(2 * π / 3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(2 * π / 3, q2, q1)))
		push!(qc, CRXGate(2 * π / 3, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRX(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π, q1, q2))
		push!(qc, inverse(CRXGate(π, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(π, q1, q2)))
		push!(qc, CRXGate(π, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRXGate(π, q2, q1))
		push!(qc, inverse(CRXGate(π, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRXGate(π, q2, q1)))
		push!(qc, CRXGate(π, q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
