using Printf

struct EmptyGate <: Gate 
	qubit::Qubit
end

get_total_width(_::EmptyGate) = 0
get_top_border_width(_::EmptyGate, _::Vector{Qubit}) = 0
get_bottom_border_width(_::EmptyGate, _::Vector{Qubit}) = 0

function draw!(line_buffers::Vector{IOBuffer}, gate::EmptyGate, qubit_order::Vector{Qubit}, layer_width::Int)
	line_index = 2 * findfirst(qubit -> qubit == gate.qubit, qc.qubits)

	write(line_buffers[line_index], "─" ^ layer_width)
end

function get_layers(qc::QuantumCircuit)
	layers = Vector{Instruction}[]

	push!(layers, [EmptyGate(qubit) for qubit in qc.qubits])
	current_layer_qubit_indices = Set{Int}()

	for instruction in qc.instructions
		instruction_qubits = get_qubit_set(instruction)
		instruction_qubit_index_range = findfirst(qubit -> qubit in instruction_qubits, qc.qubits):findlast(qubit -> qubit in instruction_qubits, qc.qubits)

		if isempty(intersect(current_layer_qubit_indices, instruction_qubit_index_range))
			union!(current_layer_qubit_indices, instruction_qubit_index_range)
		else
			push!(layers, [EmptyGate(qubit) for qubit in qc.qubits])
			empty!(current_layer_qubit_indices)
			union!(current_layer_qubit_indices, instruction_qubit_index_range)
		end

		layers[end][instruction_qubit_index_range] .= [instruction]
	end

	return layers
end

get_left_padding(instruction_width::Int, layer_width::Int) = (layer_width - instruction_width + 1) ÷ 2
get_right_padding(instruction_width::Int, layer_width::Int) = (layer_width - instruction_width) ÷ 2

function draw(qc::QuantumCircuit; overflow_width::Int = 30)
	# Calculate dimensions
	height = 2 * length(qc.qubits) + 1

	max_qubit_name_length = maximum(map(qubit -> length(qubit.name), qc.qubits))
	layers = get_layers(qc)

	# Initialize the line_buffers vector
	line_buffers = IOBuffer[]#repeat(IOBuffer[IOBuffer()], height)
	for _ = 1:height
		push!(line_buffers, IOBuffer())
	end

	# Draw qubit names and wires
	for i in 1:height
		if i % 2 == 0
			write(line_buffers[i], @sprintf("%*s: ", max_qubit_name_length, qc.qubits[i ÷ 2].name))
		else
			write(line_buffers[i], " " ^ (max_qubit_name_length + 2))
		end
	end

	# Draw the circuit itself (i.e. the instructions)
	for layer in layers
		layer_width = maximum(instruction -> get_total_width(instruction), layer)

		# Draw instructions
		for i in eachindex(layer)
			if i > 1 && layer[i] == layer[i-1]
				continue
			end
			draw!(line_buffers, layer[i], qc.qubits, layer_width)
		end

		# Draw top line
		top_border_width = get_top_border_width(layer[1], qc.qubits)
		write(line_buffers[1], " " ^ get_left_padding(top_border_width, layer_width))
		if top_border_width >= 2
			write(line_buffers[1], "┌" * "─" ^ (top_border_width - 2) * "┐")
		end
		write(line_buffers[1], " " ^ get_right_padding(top_border_width, layer_width))

		# Draw lines inbetween wires
		for i = 1:length(qc.qubits) - 1
			if layer[i] == layer[i + 1]
				continue
			end

			line_index = 2 * i + 1
			top_instruction_border_width = get_bottom_border_width(layer[i], qc.qubits)
			bottom_instruction_border_width = get_top_border_width(layer[i + 1], qc.qubits)
			top_instruction_left_padding = get_left_padding(top_instruction_border_width, layer_width)
			bottom_instruction_left_padding = get_left_padding(bottom_instruction_border_width, layer_width)
			top_instruction_right_padding = get_right_padding(top_instruction_border_width, layer_width)
			bottom_instruction_right_padding = get_right_padding(bottom_instruction_border_width, layer_width)

			# Left padding
			write(line_buffers[line_index], " " ^ min(top_instruction_left_padding, bottom_instruction_left_padding))

			# Left border edge
			if top_instruction_left_padding > bottom_instruction_left_padding
				write(line_buffers[line_index], "┌")
				write(line_buffers[line_index], "─" ^ (top_instruction_left_padding - bottom_instruction_left_padding - 1))
				write(line_buffers[line_index], (top_instruction_border_width >= 2) ? "┴" : "")
			elseif top_instruction_left_padding < bottom_instruction_left_padding
				write(line_buffers[line_index], "└")
				write(line_buffers[line_index], "─" ^ (bottom_instruction_left_padding - top_instruction_left_padding - 1))
				write(line_buffers[line_index], (bottom_instruction_border_width >= 2) ? "┬" : "")
			else
				write(line_buffers[line_index], (top_instruction_border_width >= 2) ? "├" : "")
			end

			# Border
			write(line_buffers[line_index], "─" ^ max(min(top_instruction_border_width, bottom_instruction_border_width) - 2, 0))

			# Right border edge
			if top_instruction_right_padding > bottom_instruction_right_padding
				write(line_buffers[line_index], (top_instruction_border_width >= 2) ? "┴" : "")
				write(line_buffers[line_index], "─" ^ (top_instruction_right_padding - bottom_instruction_right_padding - 1))
				write(line_buffers[line_index], "┐")
			elseif top_instruction_right_padding < bottom_instruction_right_padding
				write(line_buffers[line_index], (bottom_instruction_border_width >= 2) ? "┬" : "")
				write(line_buffers[line_index], "─" ^ (bottom_instruction_right_padding - top_instruction_right_padding - 1))
				write(line_buffers[line_index], "┘")
			else
				write(line_buffers[line_index], (top_instruction_border_width >= 2) ? "┤" : "")
			end

			# Right padding
			write(line_buffers[line_index], " " ^ min(top_instruction_right_padding, bottom_instruction_right_padding))
		end

		# Draw bottom line
		bottom_border_width = get_bottom_border_width(layer[end], qc.qubits)
		write(line_buffers[end], " " ^ get_left_padding(bottom_border_width, layer_width))
		if bottom_border_width >= 2
			write(line_buffers[end], "└" * "─" ^ (bottom_border_width - 2) * "┘")
		end
		write(line_buffers[end], " " ^ get_right_padding(bottom_border_width, layer_width))
	end

	# Print the outputs of the vectors
	# TODO: overflow
	for buffer in line_buffers
		println(String(take!(buffer)))
	end
end
