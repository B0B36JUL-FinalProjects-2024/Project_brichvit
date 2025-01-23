using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const rz_0_mat = [1 0; 0 1]
const rz_pi_3_mat = [(sqrt(Sym(3)) / 2 - im / 2) 0; 0 (sqrt(Sym(3)) / 2 + im / 2)]
const rz_pi_2_mat = [(sqrt(Sym(2)) / 2 - im * sqrt(Sym(2)) / 2) 0; 0 (sqrt(Sym(2)) / 2 + im * sqrt(Sym(2)) / 2)]
const rz_2_pi_3_mat = [(1 / 2 - im * sqrt(Sym(3)) / 2) 0; 0 (1 / 2 + im * sqrt(Sym(3)) / 2)]
const rz_pi_mat = [-im 0; 0 im]

# We need to help SymPy with element comparison by calling expr.rewrite(SymPy.cos) in some test cases
@testset "RZGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		# RZ(0)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(0, q1))
		@test simulate_unitary(qc) == rz_0_mat

		# RZ(π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(π / 3, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == rz_pi_3_mat

		# RZ(π/2)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(π / 2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == rz_pi_2_mat

		# RZ(2*π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(2 * π / 3, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == rz_2_pi_3_mat

		# RZ(π)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(π, q1))
		@test simulate_unitary(qc) == rz_pi_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# RZ(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(0, q1))
		@test simulate_unitary(qc) == kron(rz_0_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(0, q2))
		@test simulate_unitary(qc) == kron(I(2), rz_0_mat)

		# RZ(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(π / 3, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(rz_pi_3_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(π / 3, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), rz_pi_3_mat)

		# RZ(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(π / 2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(rz_pi_2_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(π / 2, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), rz_pi_2_mat)

		# RZ(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(2 * π / 3, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(rz_2_pi_3_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(2 * π / 3, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), rz_2_pi_3_mat)

		# RZ(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(π, q1))
		@test simulate_unitary(qc) == kron(rz_pi_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RZGate(π, q2))
		@test simulate_unitary(qc) == kron(I(2), rz_pi_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		# RZ(0)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(0, q1))
		push!(qc, inverse(RZGate(0, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RZGate(0, q1)))
		push!(qc, RZGate(0, q1))
		@test simulate_unitary(qc) == 1.0I

		# RZ(π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(π / 3, q1))
		push!(qc, inverse(RZGate(π / 3, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RZGate(π / 3, q1)))
		push!(qc, RZGate(π / 3, q1))
		@test simulate_unitary(qc) == 1.0I

		# RZ(π/2)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(π / 2, q1))
		push!(qc, inverse(RZGate(π / 2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RZGate(π / 2, q1)))
		push!(qc, RZGate(π / 2, q1))
		@test simulate_unitary(qc) == 1.0I

		# RZ(2*π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(2 * π / 3, q1))
		push!(qc, inverse(RZGate(2 * π / 3, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RZGate(2 * π / 3, q1)))
		push!(qc, RZGate(2 * π / 3, q1))
		@test simulate_unitary(qc) == 1.0I

		# RZ(π)
		qc = QuantumCircuit(q1)
		push!(qc, RZGate(π, q1))
		push!(qc, inverse(RZGate(π, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RZGate(π, q1)))
		push!(qc, RZGate(π, q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2 = Qubit("q1"), Qubit("q2")
		
		qc1 = QuantumCircuit(q1, q2)
		push!(qc1, controlled(RZGate(π / 2, q2), q1))

		qc2 = QuantumCircuit(q1, q2)
		push!(qc2, CRZGate(π / 2, q1, q2))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
