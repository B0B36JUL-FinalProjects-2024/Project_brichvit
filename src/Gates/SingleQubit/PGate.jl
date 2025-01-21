"""
	PGate

Phase gate operating on a single qubit parametrized by angle θ, represented by the matrix

       ⎛ 1       0 ⎞
P(θ) = ⎜           ⎟
       ⎝ 0  e^(iθ) ⎠.
"""
struct PGate <: SingleQubitGate
	theta::Sym
	qubit::Qubit

	PGate(theta::Sym, qubit::Qubit) = new(theta, qubit)
	function PGate(theta::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(theta, [sympy.pi]), qubit)
	end
end

"""
	apply!(gate::PGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the phase gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::PGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] .*= exp(im * gate.theta)
	end
end

"""
	inverse(gate::PGate)

Returns the inverse of the phase gate (a phase gate with the opposite angle).
"""
inverse(gate::PGate) = PGate(-gate.theta, gate.qubit)

get_qubit_set(gate::PGate) = Set([gate.qubit])

get_name(gate::PGate) = "P(" * replace(string(gate.theta), "pi" => "π") * ")"
