using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const ry_0_mat = [1 0; 0 1]
const ry_pi_3_mat = [sqrt(Sym(3)) / 2 -1 / 2; 1 / 2 sqrt(Sym(3)) / 2]
const ry_pi_2_mat = [sqrt(Sym(2)) / 2 -sqrt(Sym(2)) / 2; sqrt(Sym(2)) / 2 sqrt(Sym(2)) / 2]
const ry_2_pi_3_mat = [1 / 2 -sqrt(Sym(3)) / 2; sqrt(Sym(3)) / 2 1 / 2]
const ry_pi_mat = [0 -1; 1 0]

@testset "RYGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		# RY(0)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(0, q1))
		@test simulate_unitary(qc) == ry_0_mat

		# RY(π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(π / 3, q1))
		@test simulate_unitary(qc) == ry_pi_3_mat

		# RY(π/2)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(π / 2, q1))
		@test simulate_unitary(qc) == ry_pi_2_mat

		# RY(2*π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(2 * π / 3, q1))
		@test simulate_unitary(qc) == ry_2_pi_3_mat

		# RY(π)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(π, q1))
		@test simulate_unitary(qc) == ry_pi_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# RY(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(0, q1))
		@test simulate_unitary(qc) == kron(ry_0_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(0, q2))
		@test simulate_unitary(qc) == kron(I(2), ry_0_mat)

		# RY(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(π / 3, q1))
		@test simulate_unitary(qc) == kron(ry_pi_3_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(π / 3, q2))
		@test simulate_unitary(qc) == kron(I(2), ry_pi_3_mat)

		# RY(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(π / 2, q1))
		@test simulate_unitary(qc) == kron(ry_pi_2_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(π / 2, q2))
		@test simulate_unitary(qc) == kron(I(2), ry_pi_2_mat)

		# RY(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(2 * π / 3, q1))
		@test simulate_unitary(qc) == kron(ry_2_pi_3_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(2 * π / 3, q2))
		@test simulate_unitary(qc) == kron(I(2), ry_2_pi_3_mat)

		# RY(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(π, q1))
		@test simulate_unitary(qc) == kron(ry_pi_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RYGate(π, q2))
		@test simulate_unitary(qc) == kron(I(2), ry_pi_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		# RY(0)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(0, q1))
		push!(qc, inverse(RYGate(0, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RYGate(0, q1)))
		push!(qc, RYGate(0, q1))
		@test simulate_unitary(qc) == 1.0I

		# RY(π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(π / 3, q1))
		push!(qc, inverse(RYGate(π / 3, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RYGate(π / 3, q1)))
		push!(qc, RYGate(π / 3, q1))
		@test simulate_unitary(qc) == 1.0I

		# RY(π/2)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(π / 2, q1))
		push!(qc, inverse(RYGate(π / 2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RYGate(π / 2, q1)))
		push!(qc, RYGate(π / 2, q1))
		@test simulate_unitary(qc) == 1.0I

		# RY(2*π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(2 * π / 3, q1))
		push!(qc, inverse(RYGate(2 * π / 3, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RYGate(2 * π / 3, q1)))
		push!(qc, RYGate(2 * π / 3, q1))
		@test simulate_unitary(qc) == 1.0I

		# RY(π)
		qc = QuantumCircuit(q1)
		push!(qc, RYGate(π, q1))
		push!(qc, inverse(RYGate(π, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RYGate(π, q1)))
		push!(qc, RYGate(π, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
