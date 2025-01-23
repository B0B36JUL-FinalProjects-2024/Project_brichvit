get_total_width(gate::ControlledGate{CompositeGate}) = get_total_width(gate.base_gate)

function get_top_border_width(gate::ControlledGate{CompositeGate}, qubit_order::Vector{Qubit})
	if findlast(qubit -> qubit in get_qubits(gate.base_gate), qubit_order) < findfirst(qubit -> qubit in gate.control_qubits, qubit_order)
		return get_top_border_width(gate.base_gate, qubit_order)
	else
		return 0
	end
end

function get_bottom_border_width(gate::ControlledGate{CompositeGate}, qubit_order::Vector{Qubit})
	if findfirst(qubit -> qubit in get_qubits(gate.base_gate), qubit_order) > findlast(qubit -> qubit in gate.control_qubits, qubit_order)
		return get_bottom_border_width(gate.base_gate, qubit_order)
	else
		return 0
	end
end

function draw!(line_buffers::Vector{IOBuffer}, gate::ControlledGate{CompositeGate}, qubit_order::Vector{Qubit}, layer_width::Int)
	gate_qubits = get_qubits(gate)
	start_line_index = 2 * findfirst(qubit -> qubit in gate_qubits, qubit_order)
	end_line_index = 2 * findlast(qubit -> qubit in gate_qubits, qubit_order)

	target_qubits_order = indexin(gate.base_gate.qubits, qubit_order)
	target_gate_line_indices = 2 * minimum(target_qubits_order):2 * maximum(target_qubits_order)
	control_qubits_order = indexin(gate.control_qubits, qubit_order)

	for i = start_line_index:end_line_index
		if i % 2 == 0 && i in target_gate_line_indices
			write(line_buffers[i], "─" ^ get_left_padding(get_total_width(gate), layer_width))
			write(line_buffers[i], "┤")
			
			if i ÷ 2 in target_qubits_order
				write(line_buffers[i], string(findfirst(qubit -> qubit == qubit_order[i ÷ 2], gate.base_gate.qubits)))
			else
				write(line_buffers[i], " ")
			end 
			
			if i == (minimum(target_gate_line_indices) + maximum(target_gate_line_indices)) ÷ 2
				write(line_buffers[i], " " * gate.base_gate.name)
			else
				write(line_buffers[i], " " ^ (length(gate.base_gate.name) + 1))
			end
			write(line_buffers[i], " ├")
			write(line_buffers[i], "─" ^ get_right_padding(get_total_width(gate), layer_width))
		elseif i in target_gate_line_indices
			write(line_buffers[i], " " ^ get_left_padding(get_total_width(gate), layer_width))

			if i == (minimum(target_gate_line_indices) + maximum(target_gate_line_indices)) ÷ 2
				write(line_buffers[i], "│  " * gate.base_gate.name * " │")
			else
				write(line_buffers[i], "│  " * " " ^ length(gate.base_gate.name) * " │")
			end

			write(line_buffers[i], " " ^ get_right_padding(get_total_width(gate), layer_width))
		elseif i + 1 == minimum(target_gate_line_indices)
			write(line_buffers[i], " " ^ get_left_padding(get_total_width(gate.base_gate), layer_width))
			write(line_buffers[i], "┌" * "─" ^ ((get_total_width(gate.base_gate) - 2) ÷ 2))
			write(line_buffers[i], "┴")
			write(line_buffers[i], "─" ^ ((get_total_width(gate.base_gate) - 3) ÷ 2) * "┐")
			write(line_buffers[i], " " ^ get_right_padding(get_total_width(gate.base_gate), layer_width))
		elseif i - 1 == maximum(target_gate_line_indices)
			write(line_buffers[i], " " ^ get_left_padding(get_total_width(gate.base_gate), layer_width))
			write(line_buffers[i], "└" * "─" ^ ((get_total_width(gate.base_gate) - 2) ÷ 2))
			write(line_buffers[i], "┬")
			write(line_buffers[i], "─" ^ ((get_total_width(gate.base_gate) - 3) ÷ 2) * "┘")
			write(line_buffers[i], " " ^ get_right_padding(get_total_width(gate.base_gate), layer_width))
		elseif i % 2 == 0 && i ÷ 2 in control_qubits_order
			write(line_buffers[i], "─" ^ (layer_width ÷ 2) * "■" * "─" ^ ((layer_width - 1) ÷ 2))
		elseif i % 2 == 0
			write(line_buffers[i], "─" ^ (layer_width ÷ 2) * "┼" * "─" ^ ((layer_width - 1) ÷ 2))
		else
			write(line_buffers[i], " " ^ (layer_width ÷ 2) * "│" * " " ^ ((layer_width - 1) ÷ 2))
		end
	end
end
