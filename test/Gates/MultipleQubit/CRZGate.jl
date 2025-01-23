using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

# We need to help SymPy with element comparison by calling expr.rewrite(SymPy.cos) in some test cases
@testset "CRZGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError CRZGate(0, q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# CRZ(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(0, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(0, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]

		# CRZ(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π / 3, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 1 0 0; 0 0 (sqrt(Sym(3)) / 2 - im / 2) 0; 0 0 0 (sqrt(Sym(3)) / 2 + im / 2)]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π / 3, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 (sqrt(Sym(3)) / 2 - im / 2) 0 0; 0 0 1 0; 0 0 0 (sqrt(Sym(3)) / 2 + im / 2)]

		# CRZ(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π / 2, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 1 0 0; 0 0 (sqrt(Sym(2)) / 2 - im * sqrt(Sym(2)) / 2) 0; 0 0 0 (sqrt(Sym(2)) / 2 + im * sqrt(Sym(2)) / 2)]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π / 2, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 (sqrt(Sym(2)) / 2 - im * sqrt(Sym(2)) / 2) 0 0; 0 0 1 0; 0 0 0 (sqrt(Sym(2)) / 2 + im * sqrt(Sym(2)) / 2)]

		# CRZ(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(2 * π / 3, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 1 0 0; 0 0 (1 / 2 - im * sqrt(Sym(3)) / 2) 0; 0 0 0 (1 / 2 + im * sqrt(Sym(3)) / 2)]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(2 * π / 3, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 (1 / 2 - im * sqrt(Sym(3)) / 2) 0 0; 0 0 1 0; 0 0 0 (1 / 2 + im * sqrt(Sym(3)) / 2)]

		# CRZ(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π, q1, q2))
		@test simulate_unitary(qc) == [1 0 0 0; 0 1 0 0; 0 0 -im 0; 0 0 0 im]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π, q2, q1))
		@test simulate_unitary(qc) == [1 0 0 0; 0 -im 0 0; 0 0 1 0; 0 0 0 im]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# CRZ(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(0, q1, q2))
		push!(qc, inverse(CRZGate(0, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(0, q1, q2)))
		push!(qc, CRZGate(0, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(0, q2, q1))
		push!(qc, inverse(CRZGate(0, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(0, q2, q1)))
		push!(qc, CRZGate(0, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRZ(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π / 3, q1, q2))
		push!(qc, inverse(CRZGate(π / 3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(π / 3, q1, q2)))
		push!(qc, CRZGate(π / 3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π / 3, q2, q1))
		push!(qc, inverse(CRZGate(π / 3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(π / 3, q2, q1)))
		push!(qc, CRZGate(π / 3, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRZ(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π / 2, q1, q2))
		push!(qc, inverse(CRZGate(π / 2, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(π / 2, q1, q2)))
		push!(qc, CRZGate(π / 2, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π / 2, q2, q1))
		push!(qc, inverse(CRZGate(π / 2, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(π / 2, q2, q1)))
		push!(qc, CRZGate(π / 2, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRZ(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(2 * π / 3, q1, q2))
		push!(qc, inverse(CRZGate(2 * π / 3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(2 * π / 3, q1, q2)))
		push!(qc, CRZGate(2 * π / 3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(2 * π / 3, q2, q1))
		push!(qc, inverse(CRZGate(2 * π / 3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(2 * π / 3, q2, q1)))
		push!(qc, CRZGate(2 * π / 3, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CRZ(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π, q1, q2))
		push!(qc, inverse(CRZGate(π, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(π, q1, q2)))
		push!(qc, CRZGate(π, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CRZGate(π, q2, q1))
		push!(qc, inverse(CRZGate(π, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CRZGate(π, q2, q1)))
		push!(qc, CRZGate(π, q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
