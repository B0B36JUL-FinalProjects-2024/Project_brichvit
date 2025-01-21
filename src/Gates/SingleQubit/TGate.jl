"""
	TGate

T gate (√√Z gate) operating on a single qubit, represented by the matrix

    ⎛ 1         0 ⎞
T = ⎜             ⎟
    ⎝ 0  e^(iπ/4) ⎠.
"""
struct TGate <: SingleQubitGate
	qubit::Qubit
end

"""
	apply!(gate::TGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the T gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::TGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] .*= (1 + im) / sqrt(Sym(2))
	end
end

"""
	inverse(gate::TGate)

Returns the inverse of the T gate (a P(-π/4) gate).
"""
inverse(gate::TGate) = PGate(-PI / 4, gate.qubit)

get_qubit_set(gate::TGate) = Set([gate.qubit])

get_name(gate::TGate) = "T"
