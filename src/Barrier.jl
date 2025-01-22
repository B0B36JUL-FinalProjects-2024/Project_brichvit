"""
	Barrier

Barrier instruction (no-op, used just for separating circuit sections in the visualization).
"""
struct Barrier <: Instruction end

"""
	apply!(barries::Barrier, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the barrier on a given circuit (doing nothing).
"""
function apply!(barrier::Barrier, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[]) end

get_qubits(barrier::Barrier) = []
get_qubit_visualization_indices(barrier::Barrier, qubit_order::Vector{Qubit}) = eachindex(qubit_order)

get_total_width(barrier::Barrier) = 3
get_top_border_width(barrier::Barrier, _::Vector{Qubit}) = 0
get_bottom_border_width(barrier::Barrier, qubit_order::Vector{Qubit}) = 0

function draw!(line_buffers::Vector{IOBuffer}, barrier::Barrier, qubit_order::Vector{Qubit}, layer_width::Int)
	for i = 2:length(line_buffers) - 1
		if i % 2 == 0
			write(line_buffers[i], "─░─")
		else
			write(line_buffers[i], " ░ ")
		end
	end
end
