"""
	NegGate

Boolean NEG gate (NOT gate, but named NEG to avoid confusion with the Pauli-X gate) with a single input qubit and a single output qubit.
"""
struct NegGate <: Gate
	input_qubit::Qubit
	output_qubit::Qubit
end

"""
	apply!(gate::NegGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the NEG gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::NegGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	x_gate = XGate(gate.input_qubit)
	cx_gate = CXGate(gate.input_qubit, gate.output_qubit)

	apply!(x_gate, state_vector, qubit_order)
	apply!(cx_gate, state_vector, qubit_order)
	apply!(x_gate, state_vector, qubit_order)
end

"""
	inverse(gate::NegGate)

Returns the inverse of the NEG gate (which is the NEG gate itself, as it is hermitian).
"""
inverse(gate::NegGate) = gate

get_qubits(gate::NegGate) = [gate.input_qubit, gate.output_qubit]

get_total_width(gate::NegGate) = 8
get_top_border_width(gate::NegGate, qubit_order::Vector{Qubit}) = 8
get_bottom_border_width(gate::NegGate, qubit_order::Vector{Qubit}) = 8

function draw!(line_buffers::Vector{IOBuffer}, gate::NegGate, qubit_order::Vector{Qubit}, layer_width::Int)
	gate_qubits = get_qubits(gate)
	start_line_index = 2 * findfirst(qubit -> qubit == gate.input_qubit || qubit == gate.output_qubit, qubit_order)
	end_line_index = 2 * findlast(qubit -> qubit == gate.input_qubit || qubit == gate.output_qubit, qubit_order)

	input_qubit_order = findfirst(qubit -> qubit == gate.input_qubit, qubit_order)
	output_qubit_order = findfirst(qubit -> qubit == gate.output_qubit, qubit_order)

	for i = start_line_index:end_line_index
		if i % 2 == 0
			write(line_buffers[i], "─" ^ get_left_padding(get_total_width(gate), layer_width))
			write(line_buffers[i], "┤")
			
			if i ÷ 2 == input_qubit_order
				write(line_buffers[i], "<")
			elseif i ÷ 2 == output_qubit_order
				write(line_buffers[i], ">")
			else
				write(line_buffers[i], " ")
			end 
			
			if i == (start_line_index + end_line_index) ÷ 2
				write(line_buffers[i], " Neg")
			else
				write(line_buffers[i], "    ")
			end
			write(line_buffers[i], " ├")
			write(line_buffers[i], "─" ^ get_right_padding(get_total_width(gate), layer_width))
		else
			write(line_buffers[i], " " ^ get_left_padding(get_total_width(gate), layer_width))

			if i == (start_line_index + end_line_index) ÷ 2
				write(line_buffers[i], "│  Neg │")
			else
				write(line_buffers[i], "│      │")
			end

			write(line_buffers[i], " " ^ get_right_padding(get_total_width(gate), layer_width))
		end
	end
end
