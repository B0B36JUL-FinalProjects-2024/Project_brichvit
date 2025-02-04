"""
	ControlledGate

Generic wrapper for gates controlled by one or more qubits.
"""
struct ControlledGate{T <: Gate} <: Gate
	base_gate::T
	control_qubits::AbstractVector{Qubit}

	function ControlledGate(base_gate::T, control_qubits::AbstractVector{Qubit}) where T <: Gate
		if length(get_qubits(base_gate)) + length(control_qubits) != length(union(Set(get_qubits(base_gate)), Set(control_qubits)))
			throw(ArgumentError("Gates may not contain duplicate qubits"))
		end

		if isempty(control_qubits)
			throw(ArgumentError("A ControlledGate must be controlled by at least one qubit"))
		end

		return new{T}(base_gate, control_qubits)
	end

	ControlledGate{T}(base_gate::T, control_qubits::AbstractVector{Qubit}) where T <: Gate =
		ControlledGate(base_gate::T, control_qubits::AbstractVector{Qubit})
end

function add_controlled_view_indices!(indices::Vector{Int}, control_qubit_qids::AbstractVector{Int}, start_index::Int, end_index::Int)
	if length(control_qubit_qids) == 0
		append!(indices, start_index:end_index)
	else
		qid = control_qubit_qids[1]

		for slice_start = start_index:(1 << (qid + 1)):end_index
			add_controlled_view_indices!(indices, control_qubit_qids[2:length(control_qubit_qids)],
				slice_start + 1 << qid, slice_start + 1 << (qid + 1) - 1)
		end
	end
end

function get_controlled_view(state_vector::AbstractVector{Sym}, control_qubit_uids::Vector{Int})
	indices = Int[]
	add_controlled_view_indices!(indices, control_qubit_uids, 1, length(state_vector))

	return view(state_vector, indices)
end

"""
	apply!(gate::ControlledGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the controlled gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::ControlledGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	control_qubit_qids = sort(length(qubit_order) .- indexin(gate.control_qubits, qubit_order); rev = true)

	state_vector_view = get_controlled_view(state_vector, control_qubit_qids)

	apply!(gate.base_gate, state_vector_view, filter(qubit -> !(qubit in gate.control_qubits), qubit_order))
end

"""
	inverse(gate::ControlledGate)

Returns the inverse of the controlled gate (which is the controlled inverse of the base gate).
"""
inverse(gate::ControlledGate{T}) where T <: Gate = ControlledGate(inverse(gate.base_gate), gate.control_qubits)

"""
	controlled(gate::ControlledGate, control_qubit::Qubit)

Returns the gate controlled by an additional qubit.
"""
controlled(gate::ControlledGate{T}, control_qubit::Qubit) where T <: Gate =
	ControlledGate{T}(gate.base_gate, [gate.control_qubits..., control_qubit])

get_qubits(gate::ControlledGate) = [gate.control_qubits..., get_qubits(gate.base_gate)...]
replace_qubits(gate::ControlledGate{T}, qubit_replacements::Dict{Qubit, Qubit}) where T <: Gate =
	ControlledGate{T}(replace_qubits(gate.base_gate, qubit_replacements), [qubit_replacements[control_qubit] for control_qubit in gate.control_qubits])

get_total_width(gate::ControlledGate{<:SingleQubitGate}) = get_total_width(gate.base_gate)

function get_top_border_width(gate::ControlledGate{<:SingleQubitGate}, qubit_order::Vector{Qubit})
	if findlast(qubit -> qubit in get_qubits(gate.base_gate), qubit_order) < findfirst(qubit -> qubit in gate.control_qubits, qubit_order)
		return get_top_border_width(gate.base_gate, qubit_order)
	else
		return 0
	end
end

function get_bottom_border_width(gate::ControlledGate{<:SingleQubitGate}, qubit_order::Vector{Qubit})
	if findfirst(qubit -> qubit in get_qubits(gate.base_gate), qubit_order) > findlast(qubit -> qubit in gate.control_qubits, qubit_order)
		return get_bottom_border_width(gate.base_gate, qubit_order)
	else
		return 0
	end
end

function draw!(line_buffers::Vector{IOBuffer}, gate::ControlledGate{<:SingleQubitGate}, qubit_order::Vector{Qubit}, layer_width::Int)
	gate_qubits = get_qubits(gate)
	start_line_index = 2 * findfirst(qubit -> qubit in gate_qubits, qubit_order)
	end_line_index = 2 * findlast(qubit -> qubit in gate_qubits, qubit_order)

	target_qubits_order = indexin(get_qubits(gate.base_gate), qubit_order)
	control_qubits_order = indexin(gate.control_qubits, qubit_order)

	for i = start_line_index:end_line_index
		if i % 2 == 0 && i ÷ 2 in target_qubits_order
			write(line_buffers[i], "─" ^ get_left_padding(get_total_width(gate.base_gate), layer_width))
			write(line_buffers[i], "┤ " * get_name(gate.base_gate) * " ├")
			write(line_buffers[i], "─" ^ get_right_padding(get_total_width(gate.base_gate), layer_width))
		elseif i % 2 == 1 && (i + 1) ÷ 2 in target_qubits_order
			write(line_buffers[i], " " ^ get_left_padding(get_total_width(gate.base_gate), layer_width))
			write(line_buffers[i], "┌" * "─" ^ ((get_total_width(gate.base_gate) - 2) ÷ 2))
			write(line_buffers[i], "┴")
			write(line_buffers[i], "─" ^ ((get_total_width(gate.base_gate) - 3) ÷ 2) * "┐")
			write(line_buffers[i], " " ^ get_right_padding(get_total_width(gate.base_gate), layer_width))
		elseif i % 2 == 1 && (i - 1) ÷ 2 in target_qubits_order
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
