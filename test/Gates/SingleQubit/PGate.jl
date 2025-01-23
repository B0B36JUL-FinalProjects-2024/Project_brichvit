using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const p_0_mat = [1 0; 0 1]
const p_pi_6_mat = [1 0; 0 (sqrt(Sym(3)) / 2 + im / 2)]
const p_pi_4_mat = [1 0; 0 (sqrt(Sym(2)) / 2 + im * sqrt(Sym(2)) / 2)]
const p_pi_3_mat = [1 0; 0 (1 / 2 + im * sqrt(Sym(3)) / 2)]
const p_pi_2_mat = [1 0; 0 im]

# We need to help SymPy with element comparison by calling expr.rewrite(SymPy.cos) in some test cases
@testset "PGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		# P(0)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(0, q1))
		@test simulate_unitary(qc) == p_0_mat

		# P(π/6)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(π / 6, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == p_pi_6_mat

		# P(π/4)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(π / 4, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == p_pi_4_mat

		# P(π/3)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(π / 3, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == p_pi_3_mat

		# P(π/2)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(π / 2, q1))
		@test simulate_unitary(qc) == p_pi_2_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# P(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(0, q1))
		@test simulate_unitary(qc) == kron(p_0_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(0, q2))
		@test simulate_unitary(qc) == kron(I(2), p_0_mat)

		# P(π/6)
		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(π / 6, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(p_pi_6_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(π / 6, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), p_pi_6_mat)

		# P(π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(π / 4, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(p_pi_4_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(π / 4, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), p_pi_4_mat)

		# P(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(π / 3, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(p_pi_3_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(π / 3, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), p_pi_3_mat)

		# P(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(π / 2, q1))
		@test simulate_unitary(qc) == kron(p_pi_2_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, PGate(π / 2, q2))
		@test simulate_unitary(qc) == kron(I(2), p_pi_2_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		# P(0)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(0, q1))
		push!(qc, inverse(PGate(0, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(PGate(0, q1)))
		push!(qc, PGate(0, q1))
		@test simulate_unitary(qc) == 1.0I

		# P(π/6)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(π / 6, q1))
		push!(qc, inverse(PGate(π / 6, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(PGate(π / 6, q1)))
		push!(qc, PGate(π / 6, q1))
		@test simulate_unitary(qc) == 1.0I

		# P(π/4)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(π / 4, q1))
		push!(qc, inverse(PGate(π / 4, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(PGate(π / 4, q1)))
		push!(qc, PGate(π / 4, q1))
		@test simulate_unitary(qc) == 1.0I

		# P(π/3)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(π / 3, q1))
		push!(qc, inverse(PGate(π / 3, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(PGate(π / 3, q1)))
		push!(qc, PGate(π / 3, q1))
		@test simulate_unitary(qc) == 1.0I

		# P(π/2)
		qc = QuantumCircuit(q1)
		push!(qc, PGate(π / 2, q1))
		push!(qc, inverse(PGate(π / 2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(PGate(π / 2, q1)))
		push!(qc, PGate(π / 2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2 = Qubit("q1"), Qubit("q2")
		
		qc1 = QuantumCircuit(q1, q2)
		push!(qc1, controlled(PGate(π / 2, q2), q1))

		qc2 = QuantumCircuit(q1, q2)
		push!(qc2, CPGate(π / 2, q1, q2))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
