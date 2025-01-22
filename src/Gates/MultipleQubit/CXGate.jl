"""
	CXGate

Pauli-X gate controlled by a single qubit, represented by the matrix

     ⎛ 1  0  0  0 ⎞
     ⎜            ⎟
     ⎜ 0  1  0  0 ⎟
CX = ⎜            ⎟
     ⎜ 0  0  0  1 ⎟
     ⎜            ⎟
     ⎝ 0  0  1  0 ⎠.
"""
CXGate(control_qubit::Qubit, target_qubit::Qubit) = ControlledGate{XGate}(XGate(target_qubit), [control_qubit])
