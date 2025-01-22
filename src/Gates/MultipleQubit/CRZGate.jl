"""
	RZGate

Rotation gate about the Z axis controlled by a single qubit parametrized by angle θ, represented by the matrix

         ⎛ 1  0  0          0 ⎞
         ⎜                    ⎟
         ⎜ 0  1  0          0 ⎟
CRZ(θ) = ⎜                    ⎟
         ⎜ 0  0  e^(-iθ/2)  0 ⎟
         ⎜                    ⎟
         ⎝ 0  0  0   e^(iθ/2) ⎠.
"""
CRZGate(theta::Sym, control_qubit::Qubit, target_qubit::Qubit) = ControlledGate{RZGate}(RZGate(theta, target_qubit), [control_qubit])
function CRZGate(theta::Number, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate{RZGate}(RZGate(Sym(sympy.nsimplify(theta, [sympy.pi])), target_qubit), [control_qubit])
end
