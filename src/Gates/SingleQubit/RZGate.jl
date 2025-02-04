"""
	RZGate

Rotation gate about the Z axis operating on a single qubit parametrized by angle λ, represented by the matrix

        ⎛ e^(-iλ/2)  0 ⎞
RZ(λ) = ⎜              ⎟
        ⎝ 0   e^(iλ/2) ⎠.
"""
struct RZGate <: SingleQubitGate
	theta::Sym
	qubit::Qubit

	RZGate(theta::Sym, qubit::Qubit) = new(theta, qubit)
	function RZGate(theta::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(theta, [sympy.pi]), qubit)
	end
end

"""
	apply!(gate::RZGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the Z-rotation gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::RZGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		state_vector[slice_start:slice_start + 1 << qid - 1] .*= exp(-im * gate.theta / 2)
		state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] .*= exp(im * gate.theta / 2)
	end
end

"""
	inverse(gate::RZGate)

Returns the inverse of the Z-rotation gate (a Z-rotation gate with the opposite angle).
"""
inverse(gate::RZGate) = RZGate(-gate.theta, gate.qubit)

"""
	controlled(gate::RZGate, control_qubit::Qubit)

Returns the Z-rotation gate controlled by a single qubit.
"""
controlled(gate::RZGate, control_qubit::Qubit) = CRZGate(gate.theta, control_qubit, gate.qubit)

get_qubits(gate::RZGate) = [gate.qubit]
replace_qubits(gate::RZGate, qubit_replacements::Dict{Qubit, Qubit}) = RZGate(gate.theta, qubit_replacements[gate.qubit])

get_name(gate::RZGate) = "RZ(" * replace(string(gate.theta), "pi" => "π") * ")"
