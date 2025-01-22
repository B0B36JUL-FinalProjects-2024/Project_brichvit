"""
	CSGate

S gate (√Z gate) controlled by a single qubit, represented by the matrix

     ⎛ 1  0  0  0 ⎞
     ⎜            ⎟
     ⎜ 0  1  0  0 ⎟
CS = ⎜            ⎟
     ⎜ 0  0  1  0 ⎟
     ⎜            ⎟
     ⎝ 0  0  0  i ⎠.
"""
CSGate(control_qubit::Qubit, target_qubit::Qubit) = ControlledGate{SGate}(SGate(target_qubit), [control_qubit])
