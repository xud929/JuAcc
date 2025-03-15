
# SBend, RBend, DipEdge, DipBody, ThinBend
#
# Translation to MadXModel
function translate!(io::IO, mag::ThinBend, ::Type{MadXModel})
	throw(ArgumentError("$(typeof(mag)): $(mag.Name) is not defined in MadX."))
end
translate!(io::IO, mag::Union{SBend,RBend}, ::Type{MadXModel})=_translate2MadX!(io,mag,Dict(:K1=>RealType(0),:E1=>RealType(0),:E2=>RealType(0),:FInt1=>RealType(0),:FInt2=>RealType(0)))
translate!(io::IO, mag::DipEdge, ::Type{MadXModel})=_translate2MadX!(io,mag,Dict(:FInt=>RealType(0)))
translate!(io::IO, mag::DipBody, ::Type{MadXModel})=_translate2MadX!(io,mag,Dict(:K1=>RealType(0)),"SBend")

# Translation for JuAccModel
translate!(io::IO, mag::Union{SBend,RBend}, ::Type{JuAccModel})=_translate2JuAcc!(io,mag,Dict(:K1=>RealType(0),:E1=>RealType(0),:E2=>RealType(0),:FInt1=>RealType(0),:FInt2=>RealType(0)))
translate!(io::IO, mag::ThinBend, ::Type{JuAccModel})=_translate2JuAcc!(io,mag,Dict{Symbol,Any}())
translate!(io::IO, mag::DipEdge, ::Type{JuAccModel})=_translate2JuAcc!(io,mag,Dict(:FInt=>RealType(0)))
translate!(io::IO, mag::DipBody, ::Type{JuAccModel})=_translate2JuAcc!(io,mag,Dict(:K1=>RealType(0)))
