"""
	YGate

Pauli-Y gate operating on a single qubit, represented by the matrix

    ⎛ 0  -i ⎞
Y = ⎜       ⎟
    ⎝ i   0 ⎠.
"""
struct YGate <: SingleQubitGate
	qubit::Qubit
end

"""
	apply!(gate::YGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the Pauli-Y gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::YGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start:slice_start + 1 << qid - 1], state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] =
			-im * state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1],
			im * state_vector[slice_start:slice_start + 1 << qid - 1]
	end
end

"""
	inverse(gate::YGate)

Returns the inverse of the Pauli-Y gate (which is the Pauli-Y gate itself, as it is hermitian).
"""
inverse(gate::YGate) = gate

"""
	controlled(gate::YGate, control_qubit::Qubit)

Returns the Pauli-Y gate controlled by a single qubit.
"""
controlled(gate::YGate, control_qubit::Qubit) = CYGate(control_qubit, gate.qubit)

get_qubits(gate::YGate) = [gate.qubit]
replace_qubits(gate::YGate, qubit_replacements::Dict{Qubit, Qubit}) = YGate(qubit_replacements[gate.qubit])

get_name(gate::YGate) = "Y"
