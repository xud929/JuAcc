
translate!(io::IO, mag::Kicker, ::Type{MadXModel})=_translate2MadX!(io, mag, Dict(:L=>RealType(0), :HKick=>RealType(0), :VKick=>RealType(0)))
translate!(io::IO, mag::Union{HKicker,VKicker}, ::Type{MadXModel})=_translate2MadX!(io, mag, Dict(:L=>RealType(0), :Kick=>RealType(0)))
translate!(io::IO, mag::ThinKicker, ::Type{MadXModel})=_translate2MadX!(io, mag, Dict(:HKick=>RealType(0), :VKick=>RealType(0)), "KICKER, L = 0.0")

translate!(io::IO, mag::Kicker, ::Type{JuAccModel})=_translate2JuAcc!(io, mag, Dict(:L=>RealType(0), :HKick=>RealType(0), :VKick=>RealType(0)))
translate!(io::IO, mag::Union{HKicker,VKicker}, ::Type{JuAccModel})=_translate2JuAcc!(io, mag, Dict(:L=>RealType(0), :Kick=>RealType(0)))
translate!(io::IO, mag::ThinKicker, ::Type{JuAccModel})=_translate2JuAcc!(io, mag, Dict(:HKick=>RealType(0), :VKick=>RealType(0)))
