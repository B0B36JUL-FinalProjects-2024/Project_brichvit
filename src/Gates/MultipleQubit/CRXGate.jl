"""
	RXGate

Rotation gate about the X axis controlled by a single qubit parametrized by angle θ, represented by the matrix

         ⎛ 1  0            0            0 ⎞
         ⎜                                ⎟
         ⎜ 0  1            0            0 ⎟
CRX(θ) = ⎜                                ⎟
         ⎜ 0  0     cos(θ/2)  -i⋅sin(θ/2) ⎟
         ⎜                                ⎟
         ⎝ 0  0  -i⋅sin(θ/2)     cos(θ/2) ⎠.
"""
CRXGate(theta::Sym, control_qubit::Qubit, target_qubit::Qubit) = ControlledGate{RXGate}(RXGate(theta, target_qubit), [control_qubit])
function CRXGate(theta::Number, control_qubit::Qubit, target_qubit::Qubit)
	sympy = pyimport("sympy")
	return ControlledGate{RXGate}(RXGate(Sym(sympy.nsimplify(theta, [sympy.pi])), target_qubit), [control_qubit])
end
