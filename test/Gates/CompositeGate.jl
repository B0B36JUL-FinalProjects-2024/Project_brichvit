using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

const x_mat = [0 1; 1 0]

@testset "CompositeGate" begin
	@testset "One qubit" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc1 = QuantumCircuit(q1)
		push!(qc1, XGate(q1))
		push!(qc1, HGate(q1))
		push!(qc1, XGate(q1))
		push!(qc1, HGate(q1))

		qc2 = QuantumCircuit(q1)
		push!(qc2, circuit_to_gate(qc1, q1))
		@test simulate_unitary(qc2) == [0 1; -1 0]

		qc3 = QuantumCircuit(q2)
		push!(qc3, circuit_to_gate(qc1, q2))
		@test simulate_unitary(qc3) == [0 1; -1 0]
	end
	@testset "Two qubits" begin
		q1, q2, q3, q4 = Qubit("q1"), Qubit("q2"), Qubit("q3"), Qubit("q4")

		qc1 = QuantumCircuit(q1, q2)
		push!(qc1, HGate(q1))
		push!(qc1, CXGate(q1, q2))

		qc2 = QuantumCircuit(q3, q4)
		push!(qc2, circuit_to_gate(qc1, q3, q4))
		@test simulate_unitary(qc2) == 1 / sqrt(Sym(2)) * [1 0 1 0; 0 1 0 1; 0 1 0 -1; 1 0 -1 0]
	end
	@testset "inverse" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		qc1 = QuantumCircuit(q1)
		push!(qc1, XGate(q1))
		push!(qc1, HGate(q1))
		push!(qc1, XGate(q1))
		push!(qc1, HGate(q1))

		qc2 = QuantumCircuit(q2)
		push!(qc2, circuit_to_gate(qc1, q2))
		push!(qc2, inverse(circuit_to_gate(qc1, q2)))
		@test simulate_unitary(qc2) == 1.0I

		qc2 = QuantumCircuit(q2)
		push!(qc2, inverse(circuit_to_gate(qc1, q2)))
		push!(qc2, circuit_to_gate(qc1, q2))
		@test simulate_unitary(qc2) == 1.0I
	end
end
