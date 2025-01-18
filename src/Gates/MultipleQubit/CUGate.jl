"""
	CUGate

Rotation gate controlled by a single qubit parametrized by Euler angles θ, ϕ and λ, represented by the matrix

            ⎛ 1  0                0                    0 ⎞
            ⎜                                            ⎟
            ⎜ 0  1                0                    0 ⎟
CU(θ,ϕ,λ) = ⎜                                            ⎟
            ⎜ 0  0         cos(θ/2)     -e^(iλ)⋅sin(θ/2) ⎟
            ⎜                                            ⎟
            ⎝ 0  0  e^(iϕ)⋅sin(θ/2)  e^(i(ϕ+λ))⋅cos(θ/2) ⎠.
"""
CUGate(theta::Sym, phi::Sym, lambda::Sym, control_qubit::Qubit, target_qubit::Qubit) = ControlledGate(UGate(theta, phi, lambda, target_qubit), [control_qubit])
function CUGate(theta::Sym, phi::Sym, lambda::Number, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate(UGate(theta, phi, Sym(sympy.nsimplify(lambda, [sympy.pi])), target_qubit), [control_qubit])
end
function CUGate(theta::Sym, phi::Number, lambda::Sym, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate(UGate(theta, Sym(sympy.nsimplify(phi, [sympy.pi])), lambda, target_qubit), [control_qubit])
end
function CUGate(theta::Sym, phi::Number, lambda::Number, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate(UGate(theta, Sym(sympy.nsimplify(phi, [sympy.pi])), Sym(sympy.nsimplify(lambda, [sympy.pi])), target_qubit), [control_qubit])
end
function CUGate(theta::Number, phi::Sym, lambda::Sym, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate(UGate(Sym(sympy.nsimplify(theta, [sympy.pi])), phi, lambda, target_qubit), [control_qubit])
end
function CUGate(theta::Number, phi::Sym, lambda::Number, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate(UGate(Sym(sympy.nsimplify(theta, [sympy.pi])), phi, Sym(sympy.nsimplify(lambda, [sympy.pi])), target_qubit), [control_qubit])
end
function CUGate(theta::Number, phi::Number, lambda::Sym, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate(UGate(Sym(sympy.nsimplify(theta, [sympy.pi])), Sym(sympy.nsimplify(phi, [sympy.pi])), lambda, target_qubit), [control_qubit])
end
function CUGate(theta::Number, phi::Number, lambda::Number, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate(UGate(Sym(sympy.nsimplify(theta, [sympy.pi])), Sym(sympy.nsimplify(phi, [sympy.pi])), Sym(sympy.nsimplify(lambda, [sympy.pi])), target_qubit), [control_qubit])
end