"""
	CPGate

Phase gate controlled by a single qubit parametrized by angle θ, represented by the matrix

        ⎛ 1  0  0       0 ⎞
        ⎜                 ⎟
        ⎜ 0  1  0       0 ⎟
CP(θ) = ⎜                 ⎟
        ⎜ 0  0  1       0 ⎟
        ⎜                 ⎟
        ⎝ 0  0  0  e^(iθ) ⎠.
"""
CPGate(theta::Sym, control_qubit::Qubit, target_qubit::Qubit) = ControlledGate(PGate(theta, target_qubit), [control_qubit])
function CPGate(theta::Number, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate(PGate(Sym(sympy.nsimplify(theta, [sympy.pi])), target_qubit), [control_qubit])
end
