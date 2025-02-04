"""
	XGate

Pauli-X gate operating on a single qubit, represented by the matrix

    ⎛ 0  1 ⎞
X = ⎜      ⎟
    ⎝ 1  0 ⎠.
"""
struct XGate <: SingleQubitGate
	qubit::Qubit
end

"""
	apply!(gate::XGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the Pauli-X gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::XGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start:slice_start + 1 << qid - 1], state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] =
			state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1], state_vector[slice_start:slice_start + 1 << qid - 1]
	end
end

"""
	inverse(gate::XGate)

Returns the inverse of the Pauli-X gate (which is the Pauli-X gate itself, as it is hermitian).
"""
inverse(gate::XGate) = gate

"""
	controlled(gate::XGate, control_qubit::Qubit)

Returns the Pauli-X gate controlled by a single qubit.
"""
controlled(gate::XGate, control_qubit::Qubit) = CXGate(control_qubit, gate.qubit)

get_qubits(gate::XGate) = [gate.qubit]
replace_qubits(gate::XGate, qubit_replacements::Dict{Qubit, Qubit}) = XGate(qubit_replacements[gate.qubit])

get_name(gate::XGate) = "X"
