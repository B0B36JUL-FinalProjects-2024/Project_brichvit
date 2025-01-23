
function QuantumRegister(num_qubits::Integer, name::String)
	if num_qubits <= 0
		throw(DomainError(num_qubits, string("A QuantumRegister has to contain a positive amount of qubits")))
	end

	return [Qubit(string(name, '_', i)) for i = 1:num_qubits]
end
