"""
	RZGate

Rotation gate about the Z axis operating on a single qubit parametrized by angle λ, represented by the matrix

        ⎛ e^(-iλ/2)  0 ⎞
RZ(λ) = ⎜              ⎟
        ⎝ 0   e^(iλ/2) ⎠.
"""
struct RZGate <: Gate
	lambda::Sym
	qubit::Qubit

	RZGate(lambda::Sym, qubit::Qubit) = new(lambda, qubit)
	function RZGate(lambda::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(lambda, [sympy.pi]), qubit)
	end
end

"""
	apply!(gate::RZGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the Z-rotation gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::RZGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start:slice_start + 1 << qid - 1] .*= exp(-im * gate.lambda / 2)
		state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] .*= exp(im * gate.lambda / 2)
	end
end

"""
	inverse(gate::RZGate)

Returns the inverse of the Z-rotation gate (a Z-rotation gate with the opposite angle).
"""
inverse(gate::RZGate) = RZGate(-gate.lambda, gate.qubit)
