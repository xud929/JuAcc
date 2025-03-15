
function translate!(io::IO, mag::Union{LorentzBoost, RevLorentzBoost}, ::Type{MadXModel})
	throw(ArgumentError("$(typeof(mag)): $(mag.Name) is not defined in MadX."))
end

translate!(io::IO, mag::Union{LorentzBoost, RevLorentzBoost}, ::Type{JuAccModel})=_translate2JuAcc!(io, mag, Dict(:θc=>RealType(0), :θs=>RealType(0)))
