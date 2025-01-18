using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const i_mat = [1 0; 0 1]
const rx_0_mat = [1 0; 0 1]
const rx_pi_3_mat = [sqrt(Sym(3)) / 2 -im / 2; -im / 2 sqrt(Sym(3)) / 2]
const rx_pi_2_mat = [sqrt(Sym(2)) / 2 -im * sqrt(Sym(2)) / 2; -im * sqrt(Sym(2)) / 2 sqrt(Sym(2)) / 2]
const rx_2_pi_3_mat = [1 / 2 -im * sqrt(Sym(3)) / 2; -im * sqrt(Sym(3)) / 2 1 / 2]
const rx_pi_mat = [0 -im; -im 0]

@testset "RXGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		# RX(0)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(0, q1))
		@test simulate_unitary(qc) == rx_0_mat

		# RX(π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(π / 3, q1))
		@test simulate_unitary(qc) == rx_pi_3_mat

		# RX(π/2)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(π / 2, q1))
		@test simulate_unitary(qc) == rx_pi_2_mat

		# RX(2*π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(2 * π / 3, q1))
		@test simulate_unitary(qc) == rx_2_pi_3_mat

		# RX(π)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(π, q1))
		@test simulate_unitary(qc) == rx_pi_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# RX(0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(0, q1))
		@test simulate_unitary(qc) == kron(rx_0_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(0, q2))
		@test simulate_unitary(qc) == kron(I(2), rx_0_mat)

		# RX(π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(π / 3, q1))
		@test simulate_unitary(qc) == kron(rx_pi_3_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(π / 3, q2))
		@test simulate_unitary(qc) == kron(I(2), rx_pi_3_mat)

		# RX(π/2)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(π / 2, q1))
		@test simulate_unitary(qc) == kron(rx_pi_2_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(π / 2, q2))
		@test simulate_unitary(qc) == kron(I(2), rx_pi_2_mat)

		# RX(2*π/3)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(2 * π / 3, q1))
		@test simulate_unitary(qc) == kron(rx_2_pi_3_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(2 * π / 3, q2))
		@test simulate_unitary(qc) == kron(I(2), rx_2_pi_3_mat)

		# RX(π)
		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(π, q1))
		@test simulate_unitary(qc) == kron(rx_pi_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, RXGate(π, q2))
		@test simulate_unitary(qc) == kron(I(2), rx_pi_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		# RX(0)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(0, q1))
		push!(qc, inverse(RXGate(0, q1)))
		@test simulate_unitary(qc) == i_mat

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RXGate(0, q1)))
		push!(qc, RXGate(0, q1))
		@test simulate_unitary(qc) == i_mat

		# RX(π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(π / 3, q1))
		push!(qc, inverse(RXGate(π / 3, q1)))
		@test simulate_unitary(qc) == i_mat

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RXGate(π / 3, q1)))
		push!(qc, RXGate(π / 3, q1))
		@test simulate_unitary(qc) == i_mat

		# RX(π/2)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(π / 2, q1))
		push!(qc, inverse(RXGate(π / 2, q1)))
		@test simulate_unitary(qc) == i_mat

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RXGate(π / 2, q1)))
		push!(qc, RXGate(π / 2, q1))
		@test simulate_unitary(qc) == i_mat

		# RX(2*π/3)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(2 * π / 3, q1))
		push!(qc, inverse(RXGate(2 * π / 3, q1)))
		@test simulate_unitary(qc) == i_mat

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RXGate(2 * π / 3, q1)))
		push!(qc, RXGate(2 * π / 3, q1))
		@test simulate_unitary(qc) == i_mat

		# RX(π)
		qc = QuantumCircuit(q1)
		push!(qc, RXGate(π, q1))
		push!(qc, inverse(RXGate(π, q1)))
		@test simulate_unitary(qc) == i_mat

		qc = QuantumCircuit(q1)
		push!(qc, inverse(RXGate(π, q1)))
		push!(qc, RXGate(π, q1))
		@test simulate_unitary(qc) == i_mat
	end
end
