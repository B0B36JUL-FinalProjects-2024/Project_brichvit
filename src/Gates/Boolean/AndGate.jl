"""
	AndGate

Boolean AND gate with one or more input qubits and a single output qubit.
"""
struct AndGate <: Gate
	input_qubits::AbstractVector{Qubit}
	output_qubit::Qubit

	AndGate(args...) = new(collect(args[1:end - 1]), args[end])
end

"""
	apply!(gate::AndGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the AND gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::AndGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	cnx_gate = ControlledGate{XGate}(XGate(gate.output_qubit), gate.input_qubits)
	apply!(cnx_gate, state_vector, qubit_order)
end

"""
	inverse(gate::AndGate)

Returns the inverse of the AND gate (which is the AND gate itself, as it is hermitian).
"""
inverse(gate::AndGate) = gate

get_qubits(gate::AndGate) = [gate.input_qubits..., gate.output_qubit]

get_total_width(gate::AndGate) = 8
get_top_border_width(gate::AndGate, qubit_order::Vector{Qubit}) = 8
get_bottom_border_width(gate::AndGate, qubit_order::Vector{Qubit}) = 8

function draw!(line_buffers::Vector{IOBuffer}, gate::AndGate, qubit_order::Vector{Qubit}, layer_width::Int)
	gate_qubits = get_qubits(gate)
	start_line_index = 2 * findfirst(qubit -> qubit in gate_qubits, qubit_order)
	end_line_index = 2 * findlast(qubit -> qubit in gate_qubits, qubit_order)

	input_qubits_order = indexin(gate.input_qubits, qubit_order)
	output_qubit_order = findfirst(qubit -> qubit == gate.output_qubit, qubit_order)

	for i = start_line_index:end_line_index
		if i % 2 == 0
			write(line_buffers[i], "─" ^ get_left_padding(get_total_width(gate), layer_width))
			write(line_buffers[i], "┤")
			
			if i ÷ 2 in input_qubits_order
				write(line_buffers[i], "<")
			elseif i ÷ 2 == output_qubit_order
				write(line_buffers[i], ">")
			else
				write(line_buffers[i], " ")
			end 
			
			if i == (start_line_index + end_line_index) ÷ 2
				write(line_buffers[i], " And")
			else
				write(line_buffers[i], "    ")
			end
			write(line_buffers[i], " ├")
			write(line_buffers[i], "─" ^ get_right_padding(get_total_width(gate), layer_width))
		else
			write(line_buffers[i], " " ^ get_left_padding(get_total_width(gate), layer_width))

			if i == (start_line_index + end_line_index) ÷ 2
				write(line_buffers[i], "│  And │")
			else
				write(line_buffers[i], "│      │")
			end

			write(line_buffers[i], " " ^ get_right_padding(get_total_width(gate), layer_width))
		end
	end
end
