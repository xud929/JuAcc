
translate!(io::IO, mag::Solenoid, ::Type{MadXModel})=_translate2MadX!(io, mag, Dict(:L=>RealType(0), :KS=>RealType(0)))
translate!(io::IO, mag::Solenoid, ::Type{JuAccModel})=_translate2JuAcc!(io, mag, Dict(:L=>RealType(0), :KS=>RealType(0)))
