using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

or_gate_output_1 = [1 0 0 0 0 0 0 0; 0 0 0 0 0 1 0 0; 0 0 0 0 0 0 1 0; 0 0 0 0 0 0 0 1; 0 0 0 0 1 0 0 0; 0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 1 0 0 0 0]
or_gate_output_2 = [1 0 0 0 0 0 0 0; 0 0 0 1 0 0 0 0; 0 0 1 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 0 0 0 0 1 0; 0 0 0 0 0 0 0 1; 0 0 0 0 1 0 0 0; 0 0 0 0 0 1 0 0]
or_gate_output_3 = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 0 1 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 0 0 1 0 0; 0 0 0 0 1 0 0 0; 0 0 0 0 0 0 0 1; 0 0 0 0 0 0 1 0]

@testset "OrGate" begin
	@testset "Constructor" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		@test_throws ArgumentError OrGate(q1)
		@test_throws ArgumentError OrGate(q1, q1, q2)
		@test_throws ArgumentError OrGate(q1, q2, q1)
		@test_throws ArgumentError OrGate(q2, q1, q1)
	end
	@testset "Three qubits" begin
		q1, q2, q3 = Qubit("q1"), Qubit("q2"), Qubit("q3")

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q1, q2, q3))
		@test simulate_unitary(qc) == or_gate_output_3

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q1, q3, q2))
		@test simulate_unitary(qc) == or_gate_output_2

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q2, q1, q3))
		@test simulate_unitary(qc) == or_gate_output_3

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q2, q3, q1))
		@test simulate_unitary(qc) == or_gate_output_1

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q3, q1, q2))
		@test simulate_unitary(qc) == or_gate_output_2

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q3, q2, q1))
		@test simulate_unitary(qc) == or_gate_output_1
	end
	@testset "inverse" begin
		q1, q2, q3 = Qubit("q1"), Qubit("q2"), Qubit("q3")

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q1, q2, q3))
		push!(qc, inverse(OrGate(q1, q2, q3)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(OrGate(q1, q2, q3)))
		push!(qc, OrGate(q1, q2, q3))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q1, q3, q2))
		push!(qc, inverse(OrGate(q1, q3, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(OrGate(q1, q3, q2)))
		push!(qc, OrGate(q1, q3, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q2, q1, q3))
		push!(qc, inverse(OrGate(q2, q1, q3)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(OrGate(q2, q1, q3)))
		push!(qc, OrGate(q2, q1, q3))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q2, q3, q1))
		push!(qc, inverse(OrGate(q2, q3, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(OrGate(q2, q3, q1)))
		push!(qc, OrGate(q2, q3, q1))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q3, q1, q2))
		push!(qc, inverse(OrGate(q3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(OrGate(q3, q1, q2)))
		push!(qc, OrGate(q3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, OrGate(q3, q2, q1))
		push!(qc, inverse(OrGate(q3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(OrGate(q3, q2, q1)))
		push!(qc, OrGate(q3, q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
end
