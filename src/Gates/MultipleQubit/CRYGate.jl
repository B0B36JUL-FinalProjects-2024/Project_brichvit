"""
	RYGate

Rotation gate about the Y axis controlled by a single qubit parametrized by angle θ, represented by the matrix

         ⎛ 1  0         0          0 ⎞
         ⎜                           ⎟
         ⎜ 0  1         0          0 ⎟
CRY(θ) = ⎜                           ⎟
         ⎜ 0  0  cos(θ/2)  -sin(θ/2) ⎟
         ⎜                           ⎟
         ⎝ 0  0  sin(θ/2)   cos(θ/2) ⎠.
"""
CRYGate(theta::Sym, control_qubit::Qubit, target_qubit::Qubit) = ControlledGate{RYGate}(RYGate(theta, target_qubit), [control_qubit])
function CRYGate(theta::Number, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate{RYGate}(RYGate(Sym(sympy.nsimplify(theta, [sympy.pi])), target_qubit), [control_qubit])
end
