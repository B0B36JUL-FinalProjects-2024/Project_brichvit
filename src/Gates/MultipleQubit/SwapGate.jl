"""
	SwapGate

Swap gate operating on two qubits, represented by the matrix

       ⎛ 1  0  0  0 ⎞
       ⎜            ⎟
       ⎜ 0  0  1  0 ⎟
Swap = ⎜            ⎟
       ⎜ 0  1  0  0 ⎟
       ⎜            ⎟
       ⎝ 0  0  0  1 ⎠.
"""
struct SwapGate <: Gate
	qubit1::Qubit
	qubit2::Qubit

	function SwapGate(qubit1::Qubit, qubit2::Qubit)
		if qubit1 == qubit2
			throw(ArgumentError("Gates may not contain duplicate qubits"))
		end

		return new(qubit1, qubit2)
	end
end

"""
	apply!(gate::SwapGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the swap gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::SwapGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid1 = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit1 || qubit == gate.qubit2, qubit_order)
	qid2 = length(qubit_order) - findlast(qubit -> qubit == gate.qubit1 || qubit == gate.qubit2, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for outer_slice_start = 1:(1 << (qid1 + 1)):dimension
		for inner_slice_start = (outer_slice_start + 1 << qid1):(1 << (qid2 + 1)):(outer_slice_start + 1 << (qid1 + 1) - 1)
			state_vector[inner_slice_start:inner_slice_start + 1 << qid2 - 1], state_vector[inner_slice_start - 1 << qid1 + 1 << qid2:inner_slice_start + 1 << qid2 - 1 - 1 << qid1 + 1 << qid2] =
				state_vector[inner_slice_start - 1 << qid1 + 1 << qid2:inner_slice_start + 1 << qid2 - 1 - 1 << qid1 + 1 << qid2], state_vector[inner_slice_start:inner_slice_start + 1 << qid2 - 1]
		end
	end
end

"""
	inverse(gate::SwapGate)

Returns the inverse of the swap gate (which is the swap gate itself, as it is hermitian).
"""
inverse(gate::SwapGate) = gate

get_qubits(gate::SwapGate) = [gate.qubit1, gate.qubit2]
replace_qubits(gate::SwapGate, qubit_replacements::Dict{Qubit, Qubit}) =
	SwapGate(qubit_replacements[gate.qubit1], qubit_replacements[gate.qubit2])

get_total_width(gate::SwapGate) = 3
get_top_border_width(gate::SwapGate, qubit_order::Vector{Qubit}) = 0
get_bottom_border_width(gate::SwapGate, qubit_order::Vector{Qubit}) = 0

function draw!(line_buffers::Vector{IOBuffer}, gate::SwapGate, qubit_order::Vector{Qubit}, layer_width::Int)
	start_line_index = 2 * findfirst(qubit -> qubit == gate.qubit1 || qubit == gate.qubit2, qubit_order)
	end_line_index = 2 * findlast(qubit -> qubit == gate.qubit1 || qubit == gate.qubit2, qubit_order)

	write(line_buffers[start_line_index], "─" ^ (layer_width ÷ 2) * "X" * "─" ^ ((layer_width - 1) ÷ 2))
	write(line_buffers[end_line_index], "─" ^ (layer_width ÷ 2) * "X" * "─" ^ ((layer_width - 1) ÷ 2))
	for i = start_line_index+1:end_line_index-1
		if i % 2 == 0
			write(line_buffers[i], "─" ^ (layer_width ÷ 2) * "┼" * "─" ^ ((layer_width - 1) ÷ 2))
		else
			write(line_buffers[i], " " ^ (layer_width ÷ 2) * "│" * " " ^ ((layer_width - 1) ÷ 2))
		end
	end
end
