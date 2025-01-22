"""
	CYGate

Pauli-Y gate controlled by a single qubit, represented by the matrix

     ⎛ 1  0  0   0 ⎞
     ⎜             ⎟
     ⎜ 0  1  0   0 ⎟
CY = ⎜             ⎟
     ⎜ 0  0  0  -i ⎟
     ⎜             ⎟
     ⎝ 0  0  i   0 ⎠.
"""
CYGate(control_qubit::Qubit, target_qubit::Qubit) = ControlledGate{YGate}(YGate(target_qubit), [control_qubit])
