"""
	CompositeGate

Gate composed of other gates stacked behind each other, optionally also named.
"""
struct CompositeGate <: Gate
	gates::Vector{Gate}
	qubits::Vector{Qubit}
	name::String
end

"""
	circuit_to_gate(qc::QuantumCircuit, args...; name::String = "Gate")

Converts a circuit to a CompositeGate. The number of qubits passed as arguments to this function must be equal
to the number of qubits of the circuit. All instructions in the circuit must be unitary (gates).
"""
function circuit_to_gate(qc::QuantumCircuit, args...; name::String = "Gate")
	if length(qc.qubits) != length(args)
		throw(ArgumentError("The number of provided qubits does not match the number of qubits in the circuit"))
	end

	if any(instruction -> !is_unitary(instruction), qc.instructions)
		throw(ArgumentError("Cannot create a composite gate from a circuit containing non-gate instructions"))
	end

	if length(qc.qubits) >= 10
		write(stderr, "Warning: gates created by circuit_to_gate using a circuit with 10 or more qubits may not render correctly when calling draw().")
	end

	qubit_replacements = Dict(qc.qubits[i] => args[i] for i in eachindex(qc.qubits))

	return CompositeGate([replace_qubits(gate, qubit_replacements) for gate in qc.instructions], collect(args), name)
end

"""
	apply!(gate::CompositeGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the CompositeGate gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::CompositeGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	for inner_gate in gate.gates
		apply!(inner_gate, state_vector, qubit_order)
	end
end

"""
	inverse(gate::CompositeGate)

Returns the inverse of the CompositeGate gate (which is a gate composed of inverses of the gates stacked in reverse order).
"""
inverse(gate::CompositeGate) = CompositeGate([inverse(inner_gate) for inner_gate in reverse(gate.gates)], gate.qubits, "I" * gate.name)

get_qubits(gate::CompositeGate) = gate.qubits
replace_qubits(gate::CompositeGate, qubit_replacements::Dict{Qubit, Qubit}) =
	CompositeGate([replace_qubits(inner_gate, qubit_replacements) for inner_gate in qc.gates], [qubit_replacements[qubit] for qubit in gate.qubits], gate.name)

get_total_width(gate::CompositeGate) = 5 + length(gate.name)
get_top_border_width(gate::CompositeGate, qubit_order::Vector{Qubit}) = get_total_width(gate)
get_bottom_border_width(gate::CompositeGate, qubit_order::Vector{Qubit}) = get_total_width(gate)

function draw!(line_buffers::Vector{IOBuffer}, gate::CompositeGate, qubit_order::Vector{Qubit}, layer_width::Int)
	start_line_index = 2 * findfirst(qubit -> qubit in gate.qubits, qubit_order)
	end_line_index = 2 * findlast(qubit -> qubit in gate.qubits, qubit_order)

	qubits_order = indexin(gate.qubits, qubit_order)

	for i = start_line_index:end_line_index
		if i % 2 == 0
			write(line_buffers[i], "─" ^ get_left_padding(get_total_width(gate), layer_width))
			write(line_buffers[i], "┤")
			
			if i ÷ 2 in qubits_order
				write(line_buffers[i], string(findfirst(qubit -> qubit == qubit_order[i ÷ 2], gate.qubits)))
			else
				write(line_buffers[i], " ")
			end 
			
			if i == (start_line_index + end_line_index) ÷ 2
				write(line_buffers[i], " " * gate.name)
			else
				write(line_buffers[i], " " ^ (length(gate.name) + 1))
			end
			write(line_buffers[i], " ├")
			write(line_buffers[i], "─" ^ get_right_padding(get_total_width(gate), layer_width))
		else
			write(line_buffers[i], " " ^ get_left_padding(get_total_width(gate), layer_width))

			if i == (start_line_index + end_line_index) ÷ 2
				write(line_buffers[i], "│  " * gate.name * " │")
			else
				write(line_buffers[i], "│  " * " " ^ length(gate.name) * " │")
			end

			write(line_buffers[i], " " ^ get_right_padding(get_total_width(gate), layer_width))
		end
	end
end
