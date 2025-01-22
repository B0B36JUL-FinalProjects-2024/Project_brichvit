"""
	CCXGate

Pauli-X gate controlled by two qubits (Toffoli gate), represented by the matrix

      ⎛ 1  0  0  0  0  0  0  0 ⎞
      ⎜                        ⎟
      ⎜ 0  1  0  0  0  0  0  0 ⎟
      ⎜                        ⎟
      ⎜ 0  0  1  0  0  0  0  0 ⎟
      ⎜                        ⎟
      ⎜ 0  0  0  1  0  0  0  0 ⎟
CCX = ⎜                        ⎟
      ⎜ 0  0  0  0  1  0  0  0 ⎟
      ⎜                        ⎟
      ⎜ 0  0  0  0  0  1  0  0 ⎟
      ⎜                        ⎟
      ⎜ 0  0  0  0  0  0  0  1 ⎟
      ⎜                        ⎟
      ⎝ 0  0  0  0  0  0  1  0 ⎠.
"""
CCXGate(control_qubit_1::Qubit, control_qubit_2::Qubit, target_qubit::Qubit) =
	ControlledGate{XGate}(XGate(target_qubit), [control_qubit_1, control_qubit_2])
