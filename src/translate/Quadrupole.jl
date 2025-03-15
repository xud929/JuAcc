
translate!(io::IO, mag::Quadrupole, ::Type{MadXModel})=_translate2MadX!(io, mag, Dict(:L=>RealType(0), :K1=>RealType(0), :K1S=>RealType(0)))
function translate!(io::IO, mag::ThinQuad, ::Type{MadXModel})
	fmt="$(mag.Name): MULTIPOLE"
	value=RealType[]
	if mag.K1L!=RealType(0)
		fmt *= @sprintf ", KNL = {0.0, %s}" format_from_type(RealType)
		push!(value,mag.K1L)
	end
	if mag.K1SL!=RealType(0)
		fmt *= @sprintf ", KSL = {0.0, %s}" format_from_type(RealType)
		push!(value,mag.K1SL)
	end
	fmt *= ";$(DEFAULT_SETTING.line_separator)"
	Printf.format(io,Printf.Format(fmt),value...)
end

translate!(io::IO, mag::Quadrupole, ::Type{JuAccModel})=_translate2JuAcc!(io, mag, Dict(:L=>RealType(0), :K1=>RealType(0), :K1S=>RealType(0)))
translate!(io::IO, mag::ThinQuad, ::Type{JuAccModel})=_translate2JuAcc!(io, mag, Dict(:K1L=>RealType(0), :K1SL=>RealType(0)))
