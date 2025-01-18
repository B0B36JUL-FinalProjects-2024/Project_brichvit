"""
	ControlledGate

Generic wrapper for gates controlled by one or more qubits.
"""
struct ControlledGate <: Gate
	base_gate::Gate
	control_qubits::AbstractVector{Qubit}
end

function add_controlled_view_indices!(indices::Vector{Int}, control_qubit_qids::AbstractVector{Int}, start_index::Int, end_index::Int)
	if length(control_qubit_qids) == 0
		append!(indices, start_index:end_index)
	else
		qid = control_qubit_qids[1]

		for slice_start = start_index:(1 << (qid + 1)):end_index
			add_controlled_view_indices!(indices, view(control_qubit_qids, 2:length(control_qubit_qids)),
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
function apply!(gate::ControlledGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})
	control_qubit_qids = length(qubit_order) .- indexin(gate.control_qubits, qubit_order)

	state_vector_view = get_controlled_view(state_vector, control_qubit_qids)

	apply!(gate.base_gate, state_vector_view, filter(qubit -> !(qubit in gate.control_qubits), qubit_order))
end

"""
	inverse(gate::ControlledGate)

Returns the inverse of the controlled gate (which is the controlled inverse of the base gate).
"""
inverse(gate::ControlledGate) = ControlledGate(inverse(gate.base_gate), gate.control_qubits)
