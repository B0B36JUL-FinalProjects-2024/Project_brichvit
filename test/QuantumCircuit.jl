using SymbolicQuantumSimulator
using SymbolicQuantumSimulator: create_quantum_state_vector
using Test
using LinearAlgebra
using SymPy

struct DummyInstruction <: Instruction end

@testset "QuantumCircuit" begin
	@testset "QuantumCircuit constructor" begin
		q1 = Qubit("q1")
		q2 = Qubit("q2")

		qc = QuantumCircuit(q1)
		@test qc.qubits == [q1]

		qc = QuantumCircuit(q2)
		@test qc.qubits == [q2]

		qc = QuantumCircuit(q1, q2)
		@test qc.qubits == [q1, q2]
	end
	@testset "push!" begin
		q1 = Qubit("q1")
		qc = QuantumCircuit(q1)
		@test length(qc.instructions) == 0
		
		push!(qc, DummyInstruction())
		@test length(qc.instructions) == 1

		push!(qc, DummyInstruction())
		@test length(qc.instructions) == 2
	end
	@testset "append!" begin
		q1 = Qubit("q1")
		qc = QuantumCircuit(q1)
		@test length(qc.instructions) == 0
		
		append!(qc, [DummyInstruction(), DummyInstruction()])
		@test length(qc.instructions) == 2

		append!(qc, [DummyInstruction()])
		@test length(qc.instructions) == 3
	end
	@testset "create_quantum_state_vector" begin
		q1 = Qubit("q1")
		q2 = Qubit("q2")
		q3 = Qubit("q3")

		@test create_quantum_state_vector(QuantumCircuit(q1)) == [1, 0]
		@test create_quantum_state_vector(QuantumCircuit(q1, q2)) == [1, 0, 0, 0]
		@test create_quantum_state_vector(QuantumCircuit(q1, q2, q3)) == [1, 0, 0, 0, 0, 0, 0, 0]
	end
	@testset "simulate_state_vector" begin
		q1 = Qubit("q1")
		q2 = Qubit("q2")
		q3 = Qubit("q3")

		@test simulate_state_vector(QuantumCircuit(q1)) == [1, 0]
		@test simulate_state_vector(QuantumCircuit(q1, q2)) == [1, 0, 0, 0]
		@test simulate_state_vector(QuantumCircuit(q1, q2, q3)) == [1, 0, 0, 0, 0, 0, 0, 0]
	end
	@testset "simulate_unitary" begin
		q1 = Qubit("q1")
		q2 = Qubit("q2")
		q3 = Qubit("q3")

		@test SymPy.N.(simulate_unitary(QuantumCircuit(q1))) == I(2)
		@test SymPy.N.(simulate_unitary(QuantumCircuit(q1, q2))) == I(4)
		@test SymPy.N.(simulate_unitary(QuantumCircuit(q1, q2, q3))) == I(8)

		qc = QuantumCircuit(q1)
		push!(qc, DummyInstruction())

		@test_throws ArgumentError simulate_unitary(qc)
	end
end
