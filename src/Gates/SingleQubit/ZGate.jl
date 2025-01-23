"""
	ZGate

Pauli-Z gate operating on a single qubit, represented by the matrix

    ⎛ 1   0 ⎞
Z = ⎜       ⎟
    ⎝ 0  -1 ⎠.
"""
struct ZGate <: SingleQubitGate
	qubit::Qubit
end

"""
	apply!(gate::ZGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the Pauli-Z gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::ZGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] .*= -1
	end
end

"""
	inverse(gate::ZGate)

Returns the inverse of the Pauli-Z gate (which is the Pauli-Z gate itself, as it is hermitian).
"""
inverse(gate::ZGate) = gate

"""
	controlled(gate::ZGate, control_qubit::Qubit)

Returns the Pauli-Z gate controlled by a single qubit.
"""
controlled(gate::ZGate, control_qubit::Qubit) = CZGate(control_qubit, gate.qubit)

get_qubits(gate::ZGate) = [gate.qubit]
replace_qubits(gate::ZGate, qubit_replacements::Dict{Qubit, Qubit}) = ZGate(qubit_replacements[gate.qubit])

get_name(gate::ZGate) = "Z"
