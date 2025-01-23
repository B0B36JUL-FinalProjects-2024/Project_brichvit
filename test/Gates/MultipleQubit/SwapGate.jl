using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

swap_gate = [1 0 0 0; 0 0 1 0; 0 1 0 0; 0 0 0 1]

@testset "SwapGate" begin
	@testset "Constructor" begin
		q1 = Qubit("q1")

		@test_throws ArgumentError SwapGate(q1, q1)
	end
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, SwapGate(q1, q2))
		@test simulate_unitary(qc) == swap_gate

		qc = QuantumCircuit(q1, q2)
		push!(qc, SwapGate(q2, q1))
		@test simulate_unitary(qc) == swap_gate
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, SwapGate(q1, q2))
		push!(qc, inverse(SwapGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(SwapGate(q1, q2)))
		push!(qc, SwapGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, SwapGate(q2, q1))
		push!(qc, inverse(SwapGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(SwapGate(q2, q1)))
		push!(qc, SwapGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2, q3 = Qubit("q1"), Qubit("q2"), Qubit("q3")
		
		qc1 = QuantumCircuit(q1, q2, q3)
		push!(qc1, controlled(SwapGate(q2, q3), q1))

		qc2 = QuantumCircuit(q1, q2, q3)
		push!(qc2, CSwapGate(q1, q2, q3))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
