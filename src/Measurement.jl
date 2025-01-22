"""
	Measurement

Measurement of a single qubit.
"""
struct Measurement <: Instruction
	qubit::Qubit
end

"""
	apply!(measurement::Measurement, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Marks the given qubit for measurement. No gates can be used in the circuit after this operation.
"""
function apply!(measurement::Measurement, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	push!(measured_qubits, measurement.qubit)
end

get_qubits(measurement::Measurement) = [measurement.qubit]
get_qubit_visualization_indices(measurement::Measurement, qubit_order::Vector{Qubit}) =
	findfirst(qubit -> qubit == measurement.qubit, qubit_order):length(qubit_order)

get_total_width(measurement::Measurement) = 3
get_top_border_width(measurement::Measurement, _::Vector{Qubit}) = get_total_width(measurement)
get_bottom_border_width(measurement::Measurement, qubit_order::Vector{Qubit}) =
	findfirst(qubit -> qubit == measurement.qubit, qubit_order) == length(qubit_order) ? get_total_width(measurement) : 0

function draw!(line_buffers::Vector{IOBuffer}, measurement::Measurement, qubit_order::Vector{Qubit}, layer_width::Int)
	line_index = 2 * findfirst(qubit -> qubit == measurement.qubit, qubit_order)

	for i = line_index:length(line_buffers) - 1
		if i == line_index
			write(line_buffers[i], "─" ^ get_left_padding(get_total_width(measurement), layer_width))
			write(line_buffers[i], "┤@├")
			write(line_buffers[i], "─" ^ get_right_padding(get_total_width(measurement), layer_width))
		elseif i - 1 == line_index
			write(line_buffers[i], "0" ^ get_left_padding(get_total_width(measurement), layer_width))
			write(line_buffers[i], "└─┘")
			write(line_buffers[i], "0" ^ get_right_padding(get_total_width(measurement), layer_width))
		elseif i % 2 == 0
			write(line_buffers[i], "─" ^ layer_width)
		else
			write(line_buffers[i], " " ^ layer_width)
		end
	end
end
