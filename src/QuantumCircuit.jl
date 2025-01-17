"""
	QuantumCircuit

A structure representing a quantum circuit consisting of qubits and quantum instructions (initially empty).
The constructor arguments need to be of type [Qubit](@ref).
"""
struct QuantumCircuit
	qubits::Vector{Qubit}
	instructions::Vector{Instruction}

	QuantumCircuit(args...) = new(collect(args), [])
end

function Base.push!(qc::QuantumCircuit, instruction::Instruction)
	Base.push!(qc.instructions, instruction)
end

function Base.append!(qc::QuantumCircuit, instruction)
	Base.append!(qc.instructions, instruction)
end

"""
	create_quantum_state_vector(qc::QuantumCircuit)

Creates a vector representing the initial state of a given quantum circuit.
The state corresponds to the |0> vector in Dirac's braket notation, i.e. a vector containing a one on the first position
and zeros on all of the other positions.
"""
function create_quantum_state_vector(qc::QuantumCircuit)
	state_vector = zeros(Sym, 2 ^ length(qc.qubits))
	state_vector[1] = 1

	return state_vector
end

"""
	simulate_state_vector(qc::QuantumCircuit)

Returns the simulated state vector after all of the instructions in the circuit are run.
The starting input vector is defined by the [create_quantum_state_vector](@ref) function.
"""
function simulate_state_vector(qc::QuantumCircuit)
	state_vector = create_quantum_state_vector(qc)

	for instruction in qc.instructions
		apply!(instruction, state_vector)
	end

	return state_vector
end

"""
	simulate_unitary(qc::QuantumCircuit)

Returns the unitary matrix corresponding to the quantum circuit.
If the circuit contains instructions that are not unitary (gates), throws an [ArgumentError](@ref).
"""
function simulate_unitary(qc::QuantumCircuit)
	state_vector_dim = 2 ^ length(qc.qubits)
	unitary = zeros(Sym, (state_vector_dim, state_vector_dim))

	for col = 1:state_vector_dim
		unitary[col, col] = 1

		for instruction in qc.instructions
			if !is_unitary(instruction)
				throw(ArgumentError("circuit contains non-unitary instructions"))
			end

			apply!(instruction, view(unitary, :, col))
		end
	end

	return unitary
end
