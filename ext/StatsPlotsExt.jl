module StatsPlotsExt

using SymbolicQuantumSimulator
using StatsPlots
using SymPy

function SymbolicQuantumSimulator.plot_measurements(measurement_results::Dict{String, Sym})
	result_keys = collect(keys(measurement_results))
	result_values = real.(SymPy.N.(collect(values(measurement_results))))
	groupedbar(result_keys, result_values; group = repeat([1], length(result_keys)), legend = nothing, title = "Measurement results")
end

end