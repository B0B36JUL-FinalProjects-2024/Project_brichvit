"""
	HGate

Hadamard gate operating on a single qubit, represented by the matrix

    ⎛ √(2)/2   √(2)/2 ⎞
H = ⎜                 ⎟
    ⎝ √(2)/2  -√(2)/2 ⎠.
"""
struct HGate <: SingleQubitGate
	qubit::Qubit
end

"""
	apply!(gate::HGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the Hadamard gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::HGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start:slice_start + 1 << (qid + 1) - 1] ./= sqrt(Sym(2))

		state_vector[slice_start:slice_start + 1 << qid - 1] += state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1]

		state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] .*= -2
		state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] += state_vector[slice_start:slice_start + 1 << qid - 1]
	end
end

"""
	inverse(gate::HGate)

Returns the inverse of the Hadamard gate (which is the Hadamard gate itself, as it is hermitian).
"""
inverse(gate::HGate) = gate

get_qubit_set(gate::HGate) = Set([gate.qubit])

get_name(gate::HGate) = "H"
