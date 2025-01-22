"""
	OrGate

Boolean OR gate with one or more input qubits and a single output qubit.
"""
struct OrGate <: Gate
	input_qubits::AbstractVector{Qubit}
	output_qubit::Qubit

	OrGate(args...) = new(collect(args[1:end - 1]), args[end])
end

"""
	apply!(gate::OrGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the OR gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::OrGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	x_input_gates = XGate.(gate.input_qubits)
	x_output_gate = XGate(gate.output_qubit)
	cnx_gate = ControlledGate{XGate}(XGate(gate.output_qubit), gate.input_qubits)
	
	for x_input_gate in x_input_gates
		apply!(x_input_gate, state_vector, qubit_order)
	end
	apply!(cnx_gate, state_vector, qubit_order)
	apply!(x_output_gate, state_vector, qubit_order)
	for x_input_gate in x_input_gates
		apply!(x_input_gate, state_vector, qubit_order)
	end
end

"""
	inverse(gate::OrGate)

Returns the inverse of the OR gate (which is the OR gate itself, as it is hermitian).
"""
inverse(gate::OrGate) = gate

get_qubits(gate::OrGate) = [gate.input_qubits..., gate.output_qubit]

get_total_width(gate::OrGate) = 7
get_top_border_width(gate::OrGate, qubit_order::Vector{Qubit}) = 7
get_bottom_border_width(gate::OrGate, qubit_order::Vector{Qubit}) = 7

function draw!(line_buffers::Vector{IOBuffer}, gate::OrGate, qubit_order::Vector{Qubit}, layer_width::Int)
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
				write(line_buffers[i], " Or")
			else
				write(line_buffers[i], "   ")
			end
			write(line_buffers[i], " ├")
			write(line_buffers[i], "─" ^ get_right_padding(get_total_width(gate), layer_width))
		else
			write(line_buffers[i], " " ^ get_left_padding(get_total_width(gate), layer_width))

			if i == (start_line_index + end_line_index) ÷ 2
				write(line_buffers[i], "│  Or │")
			else
				write(line_buffers[i], "│     │")
			end

			write(line_buffers[i], " " ^ get_right_padding(get_total_width(gate), layer_width))
		end
	end
end
