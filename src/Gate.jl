abstract type Gate <: Instruction end

is_unitary(gate::Gate) = true

get_qubit_visualization_indices(gate::Gate, qubit_order::Vector{Qubit}) = indexin(get_qubits(gate), qubit_order)
