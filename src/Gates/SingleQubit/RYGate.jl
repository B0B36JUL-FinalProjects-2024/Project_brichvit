"""
	RYGate

Rotation gate about the Y axis operating on a single qubit parametrized by angle θ, represented by the matrix

        ⎛ cos(θ/2)  -sin(θ/2) ⎞
RY(θ) = ⎜                     ⎟
        ⎝ sin(θ/2)   cos(θ/2) ⎠.
"""
struct RYGate <: SingleQubitGate
	theta::Sym
	qubit::Qubit

	RYGate(theta::Sym, qubit::Qubit) = new(theta, qubit)
	function RYGate(theta::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(theta, [sympy.pi]), qubit)
	end
end

"""
	apply!(gate::RYGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the Y-rotation gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::RYGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		first_slice_part = cos(gate.theta / 2) * state_vector[slice_start:slice_start + 1 << qid - 1] -
			sin(gate.theta / 2) * state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1]

		second_slice_part = sin(gate.theta / 2) * state_vector[slice_start:slice_start + 1 << qid - 1] +
			cos(gate.theta / 2) * state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1]

		state_vector[slice_start:slice_start + 1 << qid - 1], state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] =
			first_slice_part, second_slice_part
	end
end

"""
	inverse(gate::RYGate)

Returns the inverse of the Y-rotation gate (a Y-rotation gate with the opposite angle).
"""
inverse(gate::RYGate) = RYGate(-gate.theta, gate.qubit)

"""
	controlled(gate::RYGate, control_qubit::Qubit)

Returns the Y-rotation gate controlled by a single qubit.
"""
controlled(gate::RYGate, control_qubit::Qubit) = CRYGate(gate.theta, control_qubit, gate.qubit)

get_qubits(gate::RYGate) = [gate.qubit]
replace_qubits(gate::RYGate, qubit_replacements::Dict{Qubit, Qubit}) = RYGate(gate.theta, qubit_replacements[gate.qubit])

get_name(gate::RYGate) = "RY(" * replace(string(gate.theta), "pi" => "π") * ")"
