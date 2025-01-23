using SymbolicQuantumSimulator
using SymbolicQuantumSimulator: create_quantum_state_vector
using Test
using LinearAlgebra
using SymPy

struct DummyInstruction <: Instruction end
struct DummyGate <: Gate end

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

		@test_throws ArgumentError QuantumCircuit()
		@test_throws ArgumentError QuantumCircuit(q1, q2, q1)
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
	@testset "No gates after measurement" begin
		q1 = Qubit("q1")
		qc = QuantumCircuit(q1)
		push!(qc, DummyGate())
		push!(qc, Measurement(q1))

		@test_throws ArgumentError push!(qc, DummyGate())

		qc = QuantumCircuit(q1)
		push!(qc, DummyGate())
		@test_throws ArgumentError append!(qc, [Measurement(q1), DummyGate()])

		qc = QuantumCircuit(q1)
		@test_nowarn append!(qc, [DummyGate(), Measurement(q1)])
		@test_nowarn append!(qc, [Measurement(q1), Measurement(q1)])
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

		@test simulate_unitary(QuantumCircuit(q1)) == 1.0I
		@test simulate_unitary(QuantumCircuit(q1, q2)) == 1.0I
		@test simulate_unitary(QuantumCircuit(q1, q2, q3)) == 1.0I

		qc = QuantumCircuit(q1)
		push!(qc, DummyInstruction())

		@test_throws ArgumentError simulate_unitary(qc)
	end
end
