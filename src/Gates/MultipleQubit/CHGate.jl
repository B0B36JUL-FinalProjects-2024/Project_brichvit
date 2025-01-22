"""
	CHGate

Hadamard gate controlled by a single qubit, represented by the matrix

     ⎛ 1  0       0        0 ⎞
     ⎜                       ⎟
     ⎜ 0  1       0        0 ⎟
CH = ⎜                       ⎟
     ⎜ 0  0  √(2)/2   √(2)/2 ⎟
     ⎜                       ⎟
     ⎝ 0  0  √(2)/2  -√(2)/2 ⎠.
"""
CHGate(control_qubit::Qubit, target_qubit::Qubit) = ControlledGate{HGate}(HGate(target_qubit), [control_qubit])
