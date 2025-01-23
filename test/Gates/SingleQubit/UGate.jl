using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const u_0_0_0_mat = [1 0; 0 1]
const u_0_0_pi_4_mat = [1 0; 0 (1 + im) / sqrt(Sym(2))]
const u_0_pi_4_0_mat = [1 0; 0 (1 + im) / sqrt(Sym(2))]
const u_0_pi_4_pi_4_mat = [1 0; 0 im]
const u_pi_2_0_0_mat = [sqrt(Sym(2)) / 2 -sqrt(Sym(2)) / 2; sqrt(Sym(2)) / 2 sqrt(Sym(2)) / 2]
const u_pi_2_0_pi_4_mat = [sqrt(Sym(2)) / 2 (-1 - im) / 2; sqrt(Sym(2)) / 2 (1 + im) / 2]
const u_pi_2_pi_4_0_mat = [sqrt(Sym(2)) / 2 -sqrt(Sym(2)) / 2; (1 + im) / 2 (1 + im) / 2]
const u_pi_2_pi_4_pi_4_mat = [sqrt(Sym(2)) / 2 (-1 - im) / 2; (1 + im) / 2 im * sqrt(Sym(2)) / 2]

# We need to help SymPy with element comparison by calling expr.rewrite(SymPy.cos) in some test cases
@testset "UGate" begin
	@testset "One qubit" begin
		q1 = Qubit("q1")

		# U(0,0,0)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(0, 0, 0, q1))
		@test simulate_unitary(qc) == u_0_0_0_mat

		# U(0,0,π/4)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(0, 0, π / 4, q1))
		@test simulate_unitary(qc) == u_0_0_pi_4_mat

		# U(0,π/4,0)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(0, π / 4, 0, q1))
		@test simulate_unitary(qc) == u_0_pi_4_0_mat

		# U(0,π/4,π/4)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(0, π / 4, π / 4, q1))
		@test simulate_unitary(qc) == u_0_pi_4_pi_4_mat

		# U(π/2,0,0)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(π / 2, 0, 0, q1))
		@test simulate_unitary(qc) == u_pi_2_0_0_mat

		# U(π/2,0,π/4)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(π / 2, 0, π / 4, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == u_pi_2_0_pi_4_mat

		# U(π/2,π/4,0)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(π / 2, π / 4, 0, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == u_pi_2_pi_4_0_mat

		# U(π/2,π/4,π/4)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(π / 2, π / 4, π / 4, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == u_pi_2_pi_4_pi_4_mat
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# U(0,0,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(0, 0, 0, q1))
		@test simulate_unitary(qc) == kron(u_0_0_0_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(0, 0, 0, q2))
		@test simulate_unitary(qc) == kron(I(2), u_0_0_0_mat)

		# U(0,0,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(0, 0, π / 4, q1))
		@test simulate_unitary(qc) == kron(u_0_0_pi_4_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(0, 0, π / 4, q2))
		@test simulate_unitary(qc) == kron(I(2), u_0_0_pi_4_mat)

		# U(0,π/4,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(0, π / 4, 0, q1))
		@test simulate_unitary(qc) == kron(u_0_pi_4_0_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(0, π / 4, 0, q2))
		@test simulate_unitary(qc) == kron(I(2), u_0_pi_4_0_mat)

		# U(0,π/4,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(0, π / 4, π / 4, q1))
		@test simulate_unitary(qc) == kron(u_0_pi_4_pi_4_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(0, π / 4, π / 4, q2))
		@test simulate_unitary(qc) == kron(I(2), u_0_pi_4_pi_4_mat)

		# U(π/2,0,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(π / 2, 0, 0, q1))
		@test simulate_unitary(qc) == kron(u_pi_2_0_0_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(π / 2, 0, 0, q2))
		@test simulate_unitary(qc) == kron(I(2), u_pi_2_0_0_mat)

		# U(π/2,0,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(π / 2, 0, π / 4, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(u_pi_2_0_pi_4_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(π / 2, 0, π / 4, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), u_pi_2_0_pi_4_mat)

		# U(π/2,π/4,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(π / 2, π / 4, 0, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(u_pi_2_pi_4_0_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(π / 2, π / 4, 0, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), u_pi_2_pi_4_0_mat)

		# U(π/2,π/4,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(π / 2, π / 4, π / 4, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(u_pi_2_pi_4_pi_4_mat, I(2))

		qc = QuantumCircuit(q1, q2)
		push!(qc, UGate(π / 2, π / 4, π / 4, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == kron(I(2), u_pi_2_pi_4_pi_4_mat)
	end
	@testset "inverse" begin
		q1 = Qubit("q1")

		# U(0,0,0)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(0, 0, 0, q1))
		push!(qc, inverse(UGate(0, 0, 0, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(UGate(0, 0, 0, q1)))
		push!(qc, UGate(0, 0, 0, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(0,0,π/4)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(0, 0, π / 4, q1))
		push!(qc, inverse(UGate(0, 0, π / 4, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(UGate(0, 0, π / 4, q1)))
		push!(qc, UGate(0, 0, π / 4, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(0,π/4,0)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(0, π / 4, 0, q1))
		push!(qc, inverse(UGate(0, π / 4, 0, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(UGate(0, π / 4, 0, q1)))
		push!(qc, UGate(0, π / 4, 0, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(0,π/4,π/4)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(0, π / 4, π / 4, q1))
		push!(qc, inverse(UGate(0, π / 4, π / 4, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(UGate(0, π / 4, π / 4, q1)))
		push!(qc, UGate(0, π / 4, π / 4, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(π/2,0,0)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(π / 2, 0, 0, q1))
		push!(qc, inverse(UGate(π / 2, 0, 0, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(UGate(π / 2, 0, 0, q1)))
		push!(qc, UGate(π / 2, 0, 0, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(π/2,0,π/4)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(π / 2, 0, π / 4, q1))
		push!(qc, inverse(UGate(π / 2, 0, π / 4, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(UGate(π / 2, 0, π / 4, q1)))
		push!(qc, UGate(π / 2, 0, π / 4, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(π/2,π/4,0)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(π / 2, π / 4, 0, q1))
		push!(qc, inverse(UGate(π / 2, π / 4, 0, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(UGate(π / 2, π / 4, 0, q1)))
		push!(qc, UGate(π / 2, π / 4, 0, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(π/2,π/4,π/4)
		qc = QuantumCircuit(q1)
		push!(qc, UGate(π / 2, π / 4, π / 4, q1))
		push!(qc, inverse(UGate(π / 2, π / 4, π / 4, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, inverse(UGate(π / 2, π / 4, π / 4, q1)))
		push!(qc, UGate(π / 2, π / 4, π / 4, q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2 = Qubit("q1"), Qubit("q2")
		
		qc1 = QuantumCircuit(q1, q2)
		push!(qc1, controlled(UGate(π / 2, π / 4, π / 4, q2), q1))

		qc2 = QuantumCircuit(q1, q2)
		push!(qc2, CUGate(π / 2, π / 4, π / 4, q1, q2))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
