"""
	SGate

S gate (√Z gate) operating on a single qubit, represented by the matrix

    ⎛ 1  0 ⎞
S = ⎜      ⎟
    ⎝ 0  i ⎠.
"""
struct SGate <: SingleQubitGate
	qubit::Qubit
end

"""
	apply!(gate::SGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the S gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::SGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] .*= im
	end
end

"""
	inverse(gate::SGate)

Returns the inverse of the S gate (a P(-π/2) gate).
"""
inverse(gate::SGate) = PGate(-PI / 2, gate.qubit)

get_qubits(gate::SGate) = [gate.qubit]
replace_qubits(gate::SGate, qubit_replacements::Dict{Qubit, Qubit}) = SGate(qubit_replacements[gate.qubit])

get_name(gate::SGate) = "S"
