using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const cu_0_0_0_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
const cu_0_0_pi_4_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 (1 + im) / sqrt(Sym(2))]
const cu_0_pi_4_0_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 (1 + im) / sqrt(Sym(2))]
const cu_0_pi_4_pi_4_mat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 im]

# We need to help SymPy with element comparison by calling expr.rewrite(SymPy.cos) in some test cases
@testset "CUGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError CUGate(0, 0, 0, q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# U(0,0,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, 0, 0, q1, q2))
		@test simulate_unitary(qc) == cu_0_0_0_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, 0, 0, q2, q1))
		@test simulate_unitary(qc) == cu_0_0_0_mat

		# U(0,0,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, 0, π / 4, q1, q2))
		@test simulate_unitary(qc) == cu_0_0_pi_4_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, 0, π / 4, q2, q1))
		@test simulate_unitary(qc) == cu_0_0_pi_4_mat

		# U(0,π/4,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, π / 4, 0, q1, q2))
		@test simulate_unitary(qc) == cu_0_pi_4_0_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, π / 4, 0, q2, q1))
		@test simulate_unitary(qc) == cu_0_pi_4_0_mat

		# U(0,π/4,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, π / 4, π / 4, q1, q2))
		@test simulate_unitary(qc) == cu_0_pi_4_pi_4_mat

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, π / 4, π / 4, q2, q1))
		@test simulate_unitary(qc) == cu_0_pi_4_pi_4_mat

		# U(π/2,0,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, 0, 0, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(2)) / 2 -sqrt(Sym(2)) / 2; 0 0 sqrt(Sym(2)) / 2 sqrt(Sym(2)) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, 0, 0, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 sqrt(Sym(2)) / 2 0 -sqrt(Sym(2)) / 2; 0 0 1 0; 0 sqrt(Sym(2)) / 2 0 sqrt(Sym(2)) / 2]

		# U(π/2,0,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, 0, π / 4, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(2)) / 2 (-1 - im) / 2; 0 0 sqrt(Sym(2)) / 2 (1 + im) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, 0, π / 4, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 sqrt(Sym(2)) / 2 0 (-1 - im) / 2; 0 0 1 0; 0 sqrt(Sym(2)) / 2 0 (1 + im) / 2]

		# U(π/2,π/4,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, π / 4, 0, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(2)) / 2 -sqrt(Sym(2)) / 2; 0 0 (1 + im) / 2 (1 + im) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, π / 4, 0, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 sqrt(Sym(2)) / 2 0 -sqrt(Sym(2)) / 2; 0 0 1 0; 0 (1 + im) / 2 0 (1 + im) / 2]

		# U(π/2,π/4,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, π / 4, π / 4, q1, q2))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 1 0 0; 0 0 sqrt(Sym(2)) / 2 (-1 - im) / 2; 0 0 (1 + im) / 2 im * sqrt(Sym(2)) / 2]

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, π / 4, π / 4, q2, q1))
		@test map(x -> x.rewrite(SymPy.cos), simulate_unitary(qc)) == [1 0 0 0; 0 sqrt(Sym(2)) / 2 0 (-1 - im) / 2; 0 0 1 0; 0 (1 + im) / 2 0 im * sqrt(Sym(2)) / 2]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		# U(0,0,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, 0, 0, q1, q2))
		push!(qc, inverse(CUGate(0, 0, 0, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(0, 0, 0, q1, q2)))
		push!(qc, CUGate(0, 0, 0, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, 0, 0, q2, q1))
		push!(qc, inverse(CUGate(0, 0, 0, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(0, 0, 0, q2, q1)))
		push!(qc, CUGate(0, 0, 0, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(0,0,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, 0, π / 4, q1, q2))
		push!(qc, inverse(CUGate(0, 0, π / 4, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(0, 0, π / 4, q1, q2)))
		push!(qc, CUGate(0, 0, π / 4, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, 0, π / 4, q2, q1))
		push!(qc, inverse(CUGate(0, 0, π / 4, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(0, 0, π / 4, q2, q1)))
		push!(qc, CUGate(0, 0, π / 4, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(0,π/4,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, π / 4, 0, q1, q2))
		push!(qc, inverse(CUGate(0, π / 4, 0, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(0, π / 4, 0, q1, q2)))
		push!(qc, CUGate(0, π / 4, 0, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, π / 4, 0, q2, q1))
		push!(qc, inverse(CUGate(0, π / 4, 0, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(0, π / 4, 0, q2, q1)))
		push!(qc, CUGate(0, π / 4, 0, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(0,π/4,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, π / 4, π / 4, q1, q2))
		push!(qc, inverse(CUGate(0, π / 4, π / 4, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(0, π / 4, π / 4, q1, q2)))
		push!(qc, CUGate(0, π / 4, π / 4, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(0, π / 4, π / 4, q2, q1))
		push!(qc, inverse(CUGate(0, π / 4, π / 4, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(0, π / 4, π / 4, q2, q1)))
		push!(qc, CUGate(0, π / 4, π / 4, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(π/2,0,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, 0, 0, q1, q2))
		push!(qc, inverse(CUGate(π / 2, 0, 0, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(π / 2, 0, 0, q1, q2)))
		push!(qc, CUGate(π / 2, 0, 0, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, 0, 0, q2, q1))
		push!(qc, inverse(CUGate(π / 2, 0, 0, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(π / 2, 0, 0, q2, q1)))
		push!(qc, CUGate(π / 2, 0, 0, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(π/2,0,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, 0, π / 4, q1, q2))
		push!(qc, inverse(CUGate(π / 2, 0, π / 4, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(π / 2, 0, π / 4, q1, q2)))
		push!(qc, CUGate(π / 2, 0, π / 4, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, 0, π / 4, q2, q1))
		push!(qc, inverse(CUGate(π / 2, 0, π / 4, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(π / 2, 0, π / 4, q2, q1)))
		push!(qc, CUGate(π / 2, 0, π / 4, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(π/2,π/4,0)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, π / 4, 0, q1, q2))
		push!(qc, inverse(CUGate(π / 2, π / 4, 0, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(π / 2, π / 4, 0, q1, q2)))
		push!(qc, CUGate(π / 2, π / 4, 0, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, π / 4, 0, q2, q1))
		push!(qc, inverse(CUGate(π / 2, π / 4, 0, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(π / 2, π / 4, 0, q2, q1)))
		push!(qc, CUGate(π / 2, π / 4, 0, q2, q1))
		@test simulate_unitary(qc) == 1.0I

		# U(π/2,π/4,π/4)
		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, π / 4, π / 4, q1, q2))
		push!(qc, inverse(CUGate(π / 2, π / 4, π / 4, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(π / 2, π / 4, π / 4, q1, q2)))
		push!(qc, CUGate(π / 2, π / 4, π / 4, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CUGate(π / 2, π / 4, π / 4, q2, q1))
		push!(qc, inverse(CUGate(π / 2, π / 4, π / 4, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CUGate(π / 2, π / 4, π / 4, q2, q1)))
		push!(qc, CUGate(π / 2, π / 4, π / 4, q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
