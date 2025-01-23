using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const cp_0_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
const cp_pi_6_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 (sqrt(Sym(3)) / 2 + im / 2)]
const cp_pi_4_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 (sqrt(Sym(2)) / 2 + im * sqrt(Sym(2)) / 2)]
const cp_pi_3_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 (1 / 2 + im * sqrt(Sym(3)) / 2)]
const cp_pi_2_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 im]

# We need to help SymPy with element comparison by calling expr.rewrite(SymPy.cos) in some test cases
@testset "CPGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError CPGate(0, q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# CP(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(0, q1, q2))
		@test simulate_unitary(qc) == cp_0_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(0, q2, q1))
		@test simulate_unitary(qc) == cp_0_mat

		# CP(π/6)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 6, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == cp_pi_6_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 6, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == cp_pi_6_mat

		# CP(π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 4, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == cp_pi_4_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 4, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == cp_pi_4_mat

		# CP(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 3, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == cp_pi_3_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 3, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == cp_pi_3_mat

		# CP(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 2, q1, q2))
		@test simulate_unitary(qc) == cp_pi_2_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 2, q2, q1))
		@test simulate_unitary(qc) == cp_pi_2_mat
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# CP(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(0, q1, q2))
		push!(qc, inverse(CPGate(0, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(0, q1, q2)))
		push!(qc, CPGate(0, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(0, q2, q1))
		push!(qc, inverse(CPGate(0, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(0, q2, q1)))
		push!(qc, CPGate(0, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CP(π/6)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 6, q1, q2))
		push!(qc, inverse(CPGate(π / 6, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(π / 6, q1, q2)))
		push!(qc, CPGate(π / 6, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 6, q2, q1))
		push!(qc, inverse(CPGate(π / 6, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(π / 6, q2, q1)))
		push!(qc, CPGate(π / 6, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CP(π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 4, q1, q2))
		push!(qc, inverse(CPGate(π / 4, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(π / 4, q1, q2)))
		push!(qc, CPGate(π / 4, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 4, q2, q1))
		push!(qc, inverse(CPGate(π / 4, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(π / 4, q2, q1)))
		push!(qc, CPGate(π / 4, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CP(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 3, q1, q2))
		push!(qc, inverse(CPGate(π / 3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(π / 3, q1, q2)))
		push!(qc, CPGate(π / 3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 3, q2, q1))
		push!(qc, inverse(CPGate(π / 3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(π / 3, q2, q1)))
		push!(qc, CPGate(π / 3, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# CP(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 2, q1, q2))
		push!(qc, inverse(CPGate(π / 2, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(π / 2, q1, q2)))
		push!(qc, CPGate(π / 2, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CPGate(π / 2, q2, q1))
		push!(qc, inverse(CPGate(π / 2, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CPGate(π / 2, q2, q1)))
		push!(qc, CPGate(π / 2, q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
