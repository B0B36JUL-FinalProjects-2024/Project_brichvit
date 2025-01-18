using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

ct_gate = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 exp(im * PI / 4)]

@testset "CTGate" begin
	@testset "Two qubits" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CTGate(q1, q2))
		@test simulate_unitary(qc) == ct_gate

		qc = QuantumCircuit(q1, q2)
		push!(qc, CTGate(q2, q1))
		@test simulate_unitary(qc) == ct_gate
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc = QuantumCircuit(q1, q2)
		push!(qc, CTGate(q1, q2))
		push!(qc, inverse(CTGate(q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CTGate(q1, q2)))
		push!(qc, CTGate(q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, CTGate(q2, q1))
		push!(qc, inverse(CTGate(q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2)
		push!(qc, inverse(CTGate(q2, q1)))
		push!(qc, CTGate(q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
