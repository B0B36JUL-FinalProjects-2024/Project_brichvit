"""
	XGate

Pauli-X gate operating on a single qubit, represented by the matrix

    ⎛ 0  1 ⎞
X = ⎜      ⎟
    ⎝ 1  0 ⎠.
"""
struct XGate <: Gate
	qubit::Qubit
end

"""
	apply!(gate::XGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the Pauli-X gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::XGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})
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
