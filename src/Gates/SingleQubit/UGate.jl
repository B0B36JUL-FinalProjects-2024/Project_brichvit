"""
	UGate

Rotation gate operating on a single qubit parametrized by Euler angles θ, ϕ and λ, represented by the matrix

           ⎛ cos(θ/2)            -e^(iλ)⋅sin(θ/2) ⎞
U(θ,ϕ,λ) = ⎜                                      ⎟
           ⎝ e^(iϕ)⋅sin(θ/2)  e^(i(ϕ+λ))⋅cos(θ/2) ⎠.
"""
struct UGate <: SingleQubitGate
	theta::Sym
	phi::Sym
	lambda::Sym
	qubit::Qubit

	UGate(theta::Sym, phi::Sym, lambda::Sym, qubit::Qubit) = new(theta, phi, lambda, qubit)
	function UGate(theta::Sym, phi::Sym, lambda::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(theta, phi, sympy.nsimplify(lambda, [sympy.pi]), qubit)
	end
	function UGate(theta::Sym, phi::Number, lambda::Sym, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(theta, sympy.nsimplify(phi, [sympy.pi]), lambda, qubit)
	end
	function UGate(theta::Sym, phi::Number, lambda::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(theta, sympy.nsimplify(phi, [sympy.pi]), sympy.nsimplify(lambda, [sympy.pi]), qubit)
	end
	function UGate(theta::Number, phi::Sym, lambda::Sym, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(theta, [sympy.pi]), phi, lambda, qubit)
	end
	function UGate(theta::Number, phi::Sym, lambda::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(theta, [sympy.pi]), phi, sympy.nsimplify(lambda, [sympy.pi]), qubit)
	end
	function UGate(theta::Number, phi::Number, lambda::Sym, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(theta, [sympy.pi]), sympy.nsimplify(phi, [sympy.pi]), lambda, qubit)
	end
	function UGate(theta::Number, phi::Number, lambda::Number, qubit::Qubit)
		sympy = pyimport("sympy")
		return new(sympy.nsimplify(theta, [sympy.pi]), sympy.nsimplify(phi, [sympy.pi]), sympy.nsimplify(lambda, [sympy.pi]), qubit)
	end
end

"""
	apply!(gate::UGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit})

Applies the U gate on a specified quantum state vector, given a qubit ordering.
"""
function apply!(gate::UGate, state_vector::AbstractVector{Sym}, qubit_order::Vector{Qubit}; measured_qubits::Vector{Qubit} = Qubit[])
	qid = length(qubit_order) - findfirst(qubit -> qubit == gate.qubit, qubit_order)
	dimension = length(state_vector)

	Threads.@threads for slice_start = 1:(1 << (qid + 1)):dimension
		first_slice_part = cos(gate.theta / 2) * state_vector[slice_start:slice_start + 1 << qid - 1] -
			exp(im * gate.lambda) * sin(gate.theta / 2) * state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1]

		second_slice_part = exp(im * gate.phi) * sin(gate.theta / 2) * state_vector[slice_start:slice_start + 1 << qid - 1] +
			exp(im * (gate.phi + gate.lambda)) * cos(gate.theta / 2) * state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1]

		state_vector[slice_start:slice_start + 1 << qid - 1], state_vector[slice_start + 1 << qid:slice_start + 1 << (qid + 1) - 1] =
			first_slice_part, second_slice_part
	end
end

"""
	inverse(gate::UGate)

Returns the inverse of the U gate (which is a U(-θ,-λ,-ϕ) gate).
"""
inverse(gate::UGate) = UGate(-gate.theta, -gate.lambda, -gate.phi, gate.qubit)

get_qubits(gate::UGate) = [gate.qubit]
replace_qubits(gate::UGate, qubit_replacements::Dict{Qubit, Qubit}) = UGate(gate.theta, gate.phi, gate.lambda, qubit_replacements[gate.qubit])

get_name(gate::UGate) = "U(" * replace(string(gate.theta), "pi" => "π") * "," * replace(string(gate.phi), "pi" => "π") * "," * replace(string(gate.lambda), "pi" => "π") * ")"
