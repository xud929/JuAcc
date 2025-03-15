function translate!(io::IO, mag::Union{Drift,HMonitor,VMonitor,Monitor,Instrument,Placeholder}, ::Type{MadXModel})
	fmt=@sprintf "%%s : %%s, L = %s;%s" DEFAULT_SETTING.float_format DEFAULT_SETTING.line_separator
	Printf.format(io, Printf.Format(fmt), mag.Name, (typeof(mag) |> string |> uppercase), mag.L)
end

function translate!(io::IO, mag::Union{Drift,HMonitor,VMonitor,Monitor,Instrument,Placeholder}, ::Type{JuAccModel})
	fmt=@sprintf "@%%s %%s L = %s%s" DEFAULT_SETTING.float_format DEFAULT_SETTING.line_separator
	Printf.format(io, Printf.Format(fmt), (typeof(mag) |> string), mag.Name, mag.L)
end
