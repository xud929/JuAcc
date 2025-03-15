translate!(io::IO, mag::Marker, ::Type{MadXModel})=_translate2MadX!(io, mag, Dict{Symbol, Any}())
translate!(io::IO, mag::Marker, ::Type{JuAccModel})=_translate2JuAcc!(io, mag, Dict{Symbol, Any}())
