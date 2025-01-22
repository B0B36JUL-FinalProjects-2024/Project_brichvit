"""
	ControlledSwapGate

Swap gate controlled by a single qubit, represented by the matrix

        ⎛ 1  0  0  0  0  0  0  0 ⎞
        ⎜                        ⎟
        ⎜ 0  1  0  0  0  0  0  0 ⎟
        ⎜                        ⎟
        ⎜ 0  0  1  0  0  0  0  0 ⎟
        ⎜                        ⎟
        ⎜ 0  0  0  1  0  0  0  0 ⎟
CSwap = ⎜                        ⎟
        ⎜ 0  0  0  0  1  0  0  0 ⎟
        ⎜                        ⎟
        ⎜ 0  0  0  0  0  0  1  0 ⎟
        ⎜                        ⎟
        ⎜ 0  0  0  0  0  1  0  0 ⎟
        ⎜                        ⎟
        ⎝ 0  0  0  0  0  0  0  1 ⎠.

Uses special drawing style separate from [ControlledGate{<:SingleQubitGate}](@ref).
"""
CSwapGate(control_qubit::Qubit, target_qubit_1::Qubit, target_qubit_2::Qubit) =
	ControlledGate{SwapGate}(SwapGate(target_qubit_1, target_qubit_2), [control_qubit])

get_total_width(gate::ControlledGate{SwapGate}) = get_total_width(gate.base_gate)
get_top_border_width(gate::ControlledGate{SwapGate}, qubit_order::Vector{Qubit}) = 0
get_bottom_border_width(gate::ControlledGate{SwapGate}, qubit_order::Vector{Qubit}) = 0

function draw!(line_buffers::Vector{IOBuffer}, gate::ControlledGate{SwapGate}, qubit_order::Vector{Qubit}, layer_width::Int)
	gate_qubits = get_qubit_set(gate)
	start_line_index = 2 * findfirst(qubit -> qubit in gate_qubits, qubit_order)
	end_line_index = 2 * findlast(qubit -> qubit in gate_qubits, qubit_order)

	target_qubits_order = indexin([gate.base_gate.qubit1, gate.base_gate.qubit2], qubit_order)
	control_qubits_order = indexin(gate.control_qubits, qubit_order)

	for i = start_line_index:end_line_index
		if i % 2 == 0 && i ÷ 2 in target_qubits_order
			write(line_buffers[i], "─" ^ (layer_width ÷ 2) * "X" * "─" ^ ((layer_width - 1) ÷ 2))
		elseif i % 2 == 0 && i ÷ 2 in control_qubits_order
			write(line_buffers[i], "─" ^ (layer_width ÷ 2) * "■" * "─" ^ ((layer_width - 1) ÷ 2))
		elseif i % 2 == 0
			write(line_buffers[i], "─" ^ (layer_width ÷ 2) * "┼" * "─" ^ ((layer_width - 1) ÷ 2))
		else
			write(line_buffers[i], " " ^ (layer_width ÷ 2) * "│" * " " ^ ((layer_width - 1) ÷ 2))
		end
	end
end
