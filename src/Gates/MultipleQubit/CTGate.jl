"""
	CSGate

T gate (√√Z gate) controlled by a single qubit, represented by the matrix

     ⎛ 1  0  0         0 ⎞
     ⎜                   ⎟
     ⎜ 0  1  0         0 ⎟
CT = ⎜                   ⎟
     ⎜ 0  0  1         0 ⎟
     ⎜                   ⎟
     ⎝ 0  0  0  e^(iπ/4) ⎠.
"""
CTGate(control_qubit::Qubit, target_qubit::Qubit) = ControlledGate{TGate}(TGate(target_qubit), [control_qubit])
