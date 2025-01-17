abstract type Gate <: Instruction end

is_unitary(gate::Gate) = true
