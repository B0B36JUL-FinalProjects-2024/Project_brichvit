"""
	QuantumCircuit

A structure representing a quantum circuit consisting of qubits and quantum instructions (initially empty).
The constructor arguments need to be of type [Qubit](@ref).
"""
struct QuantumCircuit
	qubits::Vector{Qubit}
	instructions::Vector{Instruction}

	function QuantumCircuit(args...)
		if isempty(args)
			throw(ArgumentError("A QuantumCircuit has to contain at least one qubit"))
		end

		if length(args) != length(Set(args))
			throw(ArgumentError("A QuantumCircuit may not contain duplicate qubits"))
		end

		return new(collect(args), [])
	end
end

function Base.push!(qc::QuantumCircuit, instruction::Instruction)
	if any(map(existing_instruction -> isa(existing_instruction, Measurement), qc.instructions)) && is_unitary(instruction)
		throw(ArgumentError("Gates cannot be added to a QuantumCircuit after some of the qubits have been measured"))
	end

	Base.push!(qc.instructions, instruction)
end

function Base.append!(qc::QuantumCircuit, instructions)
	for instruction in instructions
		push!(qc, instruction)
	end
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

function add_measurement_probability!(measurement_probabilities::Dict{Dict{Int, Bool}, Sym}, current_values::Dict{Int, Bool}, measured_qids::Vector{Int}, state_vector::Vector{Sym})
	if isempty(measured_qids)
		if current_values in keys(measurement_probabilities)
			measurement_probabilities[copy(current_values)] += sum(abs.(state_vector) .^ 2)
		else
			measurement_probabilities[copy(current_values)] = sum(abs.(state_vector) .^ 2)
		end
	else
		qid = measured_qids[1]
		for slice_start = 1:(1 << (qid + 1)):length(state_vector)
			current_values[qid] = 0
			add_measurement_probability!(measurement_probabilities, current_values, measured_qids[2:end], state_vector[slice_start:slice_start + 1 << qid - 1])

			current_values[qid] = 1
			add_measurement_probability!(measurement_probabilities, current_values, measured_qids[2:end], state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1])

			delete!(current_values, qid)
		end
	end
end

function get_result_key(measurement_values::Dict{Int, Bool}, measured_qubits::Vector{Qubit}, qubit_order::Vector{Qubit})
	sorted_result_strings = repeat([" "], length(measurement_values))

	for (measured_qid, measured_value) in measurement_values
		measured_qubit = qubit_order[length(qubit_order) - measured_qid]
		measured_qubit_order = findfirst(qubit -> qubit == measured_qubit, measured_qubits)

		sorted_result_strings[measured_qubit_order] = measured_value ? "1" : "0"
	end

	return join(sorted_result_strings)
end

"""
	simulate_measurements(qc::QuantumCircuit)

Returns the simulated measurement probabilities after all of the instructions in the circuit are run.
The measurements are returned as a dictionary, where the keys are binary strings representing the measured bits
and the values are the corresponding probabilities (expressions of type [SymPy.Sym](@ref)).
"""
function simulate_measurements(qc::QuantumCircuit)
	state_vector = create_quantum_state_vector(qc)
	measured_qubits = Qubit[]

	for instruction in qc.instructions
		apply!(instruction, state_vector, qc.qubits; measured_qubits = measured_qubits)
	end

	measured_qids = sort(length(qc.qubits) .- indexin(measured_qubits, qc.qubits); rev = true)
	measurement_probabilities = Dict{Dict{Int, Bool}, Sym}()

	add_measurement_probability!(measurement_probabilities, Dict{Int, Bool}(), measured_qids, state_vector)

	results = Dict{String, Sym}()
	for (measurement_values, measurement_probability) in measurement_probabilities
		if measurement_probability > 0
			results[get_result_key(measurement_values, measured_qubits, qc.qubits)] = measurement_probability
		end
	end

	return results
end

"""
	simulate_state_vector(qc::QuantumCircuit)

Returns the simulated state vector after all of the instructions in the circuit are run.
The starting input vector is defined by the [create_quantum_state_vector](@ref) function.
"""
function simulate_state_vector(qc::QuantumCircuit)
	state_vector = create_quantum_state_vector(qc)

	for instruction in qc.instructions
		apply!(instruction, state_vector, qc.qubits)
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

			apply!(instruction, view(unitary, :, col), qc.qubits)
		end
	end

	return unitary
end
