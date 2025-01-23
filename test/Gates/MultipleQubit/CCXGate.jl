using SymbolicQuantumSimulator
using Test
using SymPy
using LinearAlgebra

ccx_gate_control_1 = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 0 0 0 0 1; 0 0 0 0 1 0 0 0; 0 0 0 0 0 1 0 0; 0 0 0 0 0 0 1 0; 0 0 0 1 0 0 0 0]
ccx_gate_control_2 = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 1 0 0 0 0; 0 0 0 0 1 0 0 0; 0 0 0 0 0 0 0 1; 0 0 0 0 0 0 1 0; 0 0 0 0 0 1 0 0]
ccx_gate_control_3 = [1 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 1 0 0 0 0; 0 0 0 0 1 0 0 0; 0 0 0 0 0 1 0 0; 0 0 0 0 0 0 0 1; 0 0 0 0 0 0 1 0]

@testset "CCXGate" begin
	@testset "Constructor" begin
		q1, q2 = Qubit("q1"), Qubit("q2")

		@test_throws ArgumentError CCXGate(q1, q1, q2)
		@test_throws ArgumentError CCXGate(q1, q2, q1)
		@test_throws ArgumentError CCXGate(q2, q1, q1)
	end
	@testset "Three qubits" begin
		q1, q2, q3 = Qubit("q1"), Qubit("q2"), Qubit("q3")

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q1, q2, q3))
		@test simulate_unitary(qc) == ccx_gate_control_3

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q1, q3, q2))
		@test simulate_unitary(qc) == ccx_gate_control_2

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q2, q1, q3))
		@test simulate_unitary(qc) == ccx_gate_control_3

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q2, q3, q1))
		@test simulate_unitary(qc) == ccx_gate_control_1

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q3, q1, q2))
		@test simulate_unitary(qc) == ccx_gate_control_2

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q3, q2, q1))
		@test simulate_unitary(qc) == ccx_gate_control_1
	end
	@testset "inverse" begin
		q1, q2, q3 = Qubit("q1"), Qubit("q2"), Qubit("q3")

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q1, q2, q3))
		push!(qc, inverse(CCXGate(q1, q2, q3)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CCXGate(q1, q2, q3)))
		push!(qc, CCXGate(q1, q2, q3))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q1, q3, q2))
		push!(qc, inverse(CCXGate(q1, q3, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CCXGate(q1, q3, q2)))
		push!(qc, CCXGate(q1, q3, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q2, q1, q3))
		push!(qc, inverse(CCXGate(q2, q1, q3)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CCXGate(q2, q1, q3)))
		push!(qc, CCXGate(q2, q1, q3))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q2, q3, q1))
		push!(qc, inverse(CCXGate(q2, q3, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CCXGate(q2, q3, q1)))
		push!(qc, CCXGate(q2, q3, q1))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q3, q1, q2))
		push!(qc, inverse(CCXGate(q3, q1, q2)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CCXGate(q3, q1, q2)))
		push!(qc, CCXGate(q3, q1, q2))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, CCXGate(q3, q2, q1))
		push!(qc, inverse(CCXGate(q3, q2, q1)))
		@test simulate_unitary(qc) == 1.0I

		qc = QuantumCircuit(q1, q2, q3)
		push!(qc, inverse(CCXGate(q3, q2, q1)))
		push!(qc, CCXGate(q3, q2, q1))
		@test simulate_unitary(qc) == 1.0I
	end
	@testset "controlled" begin
		q1, q2, q3 = Qubit("q1"), Qubit("q2"), Qubit("q3")
		
		qc1 = QuantumCircuit(q1, q2, q3)
		push!(qc1, controlled(CXGate(q2, q3), q1))

		qc2 = QuantumCircuit(q1, q2, q3)
		push!(qc2, CCXGate(q1, q2, q3))
		@test simulate_unitary(qc1) == simulate_unitary(qc2)
	end
end
