"""
	HGate

Identity gate operating on a single qubit, represented by the matrix

    ⎛ 1  0 ⎞
I = ⎜      ⎟
    ⎝ 0  1 ⎠.
"""
struct IGate <: Gate
	qubit::Qubit
end

"""
	apply!(gate::IGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the identity gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(_::IGate, _::AbstractVector{Sym}, _::Vector{Qubit}) end

"""
	inverse(gate::IGate)

Returns the inverse of the identity gate (which is the identity gate itself, as it is hermitian).
"""
inverse(gate::IGate) = gate
