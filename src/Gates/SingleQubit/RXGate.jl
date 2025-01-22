"""
	RXGate

Rotation gate about the X axis operating on a single qubit parametrized by angle θ, represented by the matrix

        ⎛ cos(θ/2)     -i⋅sin(θ/2) ⎞
RX(θ) = ⎜                          ⎟
        ⎝ -i⋅sin(θ/2)     cos(θ/2) ⎠.
"""
struct RXGate <: SingleQubitGate
	theta::Sym
	qubit::Qubit

	RXGate(theta::Sym, qubit::Qubit) = new(theta, qubit)
	function RXGate(theta::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(theta, [sympy.pi]), qubit)
	end
end

"""
	apply!(gate::RXGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the X-rotation gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::RXGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		first_slice_part = cos(gate.theta / 2) * state_vector[slice_start:slice_start + 1 << qid - 1] -
			im * sin(gate.theta / 2) * state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1]

		second_slice_part = -im * sin(gate.theta / 2) * state_vector[slice_start:slice_start + 1 << qid - 1] +
			cos(gate.theta / 2) * state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1]

		state_vector[slice_start:slice_start + 1 << qid - 1], state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] =
			first_slice_part, second_slice_part
	end
end

"""
	inverse(gate::RXGate)

Returns the inverse of the X-rotation gate (an X-rotation gate with the opposite angle).
"""
inverse(gate::RXGate) = RXGate(-gate.theta, gate.qubit)

get_qubits(gate::RXGate) = [gate.qubit]
replace_qubits(gate::RXGate, qubit_replacements::Dict{Qubit, Qubit}) = RXGate(gate.theta, qubit_replacements[gate.qubit])

get_name(gate::RXGate) = "RX(" * replace(string(gate.theta), "pi" => "π") * ")"
