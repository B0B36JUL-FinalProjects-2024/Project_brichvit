abstract type SingleQubitGate <: Gate end

get_total_width(gate::SingleQubitGate) = length(get_name(gate)) + 4
get_top_border_width(gate::SingleQubitGate, _::Vector{Qubit}) = get_total_width(gate)
get_bottom_border_width(gate::SingleQubitGate, _::Vector{Qubit}) = get_total_width(gate)

function draw!(line_buffers::Vector{IOBuffer}, gate::SingleQubitGate, qubit_order::Vector{Qubit}, layer_width::Int)
	line_index = 2 * findfirst(qubit -> qubit == gate.qubit, qubit_order)

	write(line_buffers[line_index], "─" ^ get_left_padding(get_total_width(gate), layer_width))
	write(line_buffers[line_index], "┤ " * get_name(gate) * " ├")
	write(line_buffers[line_index], "─" ^ get_right_padding(get_total_width(gate), layer_width))
end
