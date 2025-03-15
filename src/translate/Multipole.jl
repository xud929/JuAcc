function translate!(io::IO, mag::ThinMultipole, ::Type{MadXModel})
	str_fmt="%s : MULTIPOLE"
	if length(mag.KnL) > 0
		str_fmt *=", KNL = {" * (@sprintf "%s," DEFAULT_SETTING.float_format)^(length(mag.KnL)-1) * (@sprintf "%s}" DEFAULT_SETTING.float_format)
	end
	if length(mag.KsL) > 0
		str_fmt *=", KSL = {" * (@sprintf "%s," DEFAULT_SETTING.float_format)^(length(mag.KsL)-1) * (@sprintf "%s}" DEFAULT_SETTING.float_format)
	end
	str_fmt *= (@sprintf ";%s" DEFAULT_SETTING.line_separator)
	Printf.format(io,Printf.Format(str_fmt),mag.Name,(mag.KnL)...,(mag.KsL)...)
end

function translate!(io::IO, mag::ThinMultipole, ::Type{JuAccModel})
	str_fmt="@ThinMultipole %s"
	if length(mag.KnL) > 0
		str_fmt *=" KNL = $(RealType)[" * (@sprintf "%s," DEFAULT_SETTING.float_format)^(length(mag.KnL)-1) * (@sprintf "%s]" DEFAULT_SETTING.float_format)
	end
	if length(mag.KsL) > 0
		str_fmt *=" KSL = $(RealType)[" * (@sprintf "%s," DEFAULT_SETTING.float_format)^(length(mag.KsL)-1) * (@sprintf "%s]" DEFAULT_SETTING.float_format)
	end
	str_fmt *= (@sprintf "%s" DEFAULT_SETTING.line_separator)
	Printf.format(io,Printf.Format(str_fmt),mag.Name,(mag.KnL)...,(mag.KsL)...)
end
