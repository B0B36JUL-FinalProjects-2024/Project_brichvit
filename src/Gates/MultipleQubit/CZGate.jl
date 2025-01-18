"""
	CZGate

Pauli-Z gate controlled by a single qubit, represented by the matrix

     ⎛ 1  0  0   0 ⎞
     ⎜             ⎟
     ⎜ 0  1  0   0 ⎟
CZ = ⎜             ⎟
     ⎜ 0  0  1   0 ⎟
     ⎜             ⎟
     ⎝ 0  0  0  -1 ⎠.
"""
CZGate(control_qubit::Qubit, target_qubit::Qubit) = ControlledGate(ZGate(target_qubit), [control_qubit])
