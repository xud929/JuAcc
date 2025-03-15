function WriteSequenceToJuliaStream(seq::Sequence,cell::String, io; output_elements=true)
	output_elements && begin
		index=getIndexByClass(seq,Marker)
		mags=[seq[i] for i in index]
		uniq_index=unique(i->mags[i].Name,1:length(mags))
		for mag in mags[uniq_index]
			fmt=Printf.Format("@Marker %s\n")
			Printf.format(io,fmt,mag.Name)
		end

		length(index) !=0 && print(io,"\n\n\n")

		for T in [:Drift,:HMonitor,:VMonitor,:Monitor,:Instrument,:Placeholder]
			index=getIndexByClass(seq,eval(T))
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				fmt=Printf.Format("@$(string(T)) %s L = %.15e\n")
				Printf.format(io,fmt,mag.Name,mag.L)
			end
			length(index) !=0 && print(io,"\n\n\n")
		end

		index=getIndexByClass(seq,Quadrupole)
		mags=[seq[i] for i in index]
		uniq_index=unique(i->mags[i].Name,1:length(mags))
		for mag in mags[uniq_index]
			if abs(mag.K1S) > 1e-15
				fmt=Printf.Format("@Quadrupole %s L = %.15e K1 = %.15e K1S = %.15e\n")
				Printf.format(io,fmt,mag.Name,mag.L,mag.K1,mag.K1S)
			else
				fmt=Printf.Format("@Quadrupole %s L = %.15e K1 = %.15e\n")
				Printf.format(io,fmt,mag.Name,mag.L,mag.K1)
			end
		end

		length(index) !=0 && print(io,"\n\n\n")
																					
		index=getIndexByClass(seq,ThinMultipole)
		mags=[seq[i] for i in index]
		uniq_index=unique(i->mags[i].Name,1:length(mags))
		for mag in mags[uniq_index]
			fmt=Printf.Format("@ThinMultipole %s KnL = Float64[" * "%.15e,"^length(mag.KnL) * "] KsL = Float64[" * "%.15e,"^length(mag.KsL) *  "]\n")
			Printf.format(io,fmt,mag.Name,(mag.KnL)...,(mag.KsL)...)
		end
																					
		length(index) !=0 && print(io,"\n\n\n")

		index=getIndexByClass(seq,ThinKicker)
		mags=[seq[i] for i in index]
		uniq_index=unique(i->mags[i].Name,1:length(mags))
		for mag in mags[uniq_index]
			fmt=Printf.Format("@ThinKicker %s HKick = %.15e VKick = %.15e\n")
			Printf.format(io,fmt,mag.Name,mag.HKick,mag.VKick)
		end
																					
		length(index) !=0 && print(io,"\n\n\n")
																					
		index=getIndexByClass(seq,Kicker)
		mags=[seq[i] for i in index]
		uniq_index=unique(i->mags[i].Name,1:length(mags))
		for mag in mags[uniq_index]
			fmt=Printf.Format("@Kicker %s L=%.15e HKick = %.15e VKick = %.15e\n")
			Printf.format(io,fmt,mag.Name,mag.L,mag.HKick,mag.VKick)
		end
																					
		length(index) !=0 && print(io,"\n\n\n")
																					
		for T in [:HKicker,:VKicker]
			index=getIndexByClass(seq,eval(T))
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				fmt=Printf.Format("@$(string(T)) %s L = %.15e Kick = %.15e\n")
				Printf.format(io,fmt,mag.Name,mag.L,mag.Kick)
			end
			length(index) !=0 && print(io,"\n\n\n")
		end

		index=getIndexByClass(seq,SBend)
		mags=[seq[i] for i in index]
		uniq_index=unique(i->mags[i].Name,1:length(mags))
		for mag in mags[uniq_index]
			fmt_str="@SBend %s L = %.15e Angle = %.15e"
			value=Float64[mag.L,mag.Angle]
			abs(mag.K1) > 1e-15 && (fmt_str*=" K1 = %.15e";push!(value,mag.K1))
			abs(mag.E1) > 1e-15 && (fmt_str*=" E1 = %.15e";push!(value,mag.E1))
			abs(mag.E2) > 1e-15 && (fmt_str*=" E2 = %.15e";push!(value,mag.E2))
			fmt_str*=";\n"
			fmt=Printf.Format(fmt_str)
			Printf.format(io,fmt,mag.Name,value...)
		end

		length(index) !=0 && print(io,"\n\n\n")

		index=getIndexByClass(seq,RBend)
		mags=[seq[i] for i in index]
		uniq_index=unique(i->mags[i].Name,1:length(mags))
		for mag in mags[uniq_index]
			fmt_str="@RBend %s L = %.15e ANGLE = %.15e"
			value=Float64[mag.L,mag.Angle]
			abs(mag.K1) > 1e-15 && (fmt_str*=" K1 = %.15e";push!(value,mag.K1))
			abs(mag.E1) > 1e-15 && (fmt_str*=" E1 = %.15e";push!(value,mag.E1))
			abs(mag.E2) > 1e-15 && (fmt_str*=" E2 = %.15e";push!(value,mag.E2))
			fmt_str*=";\n"
			fmt=Printf.Format(fmt_str)
			Printf.format(io,fmt,mag.Name,value...)
		end

		length(index) !=0 && print(io,"\n\n\n")

		index=getIndexByClass(seq,Solenoid)
		mags=[seq[i] for i in index]
		uniq_index=unique(i->mags[i].Name,1:length(mags))
		for mag in mags[uniq_index]
			fmt=Printf.Format("@Solenoid %s L = %.15e KS = %.15e\n")
			Printf.format(io,fmt,mag.Name,mag.L,mag.KS)
		end
																				
		length(index) !=0 && print(io,"\n\n\n")

	end # of open file

	names=join([seq[i].Name for i in 1:length(seq)],", ")
	print(io, "$(cell) = Sequence([$(names)]);\n")
    
    return
end # of function


function WriteSequenceToFileInMadX(seq::Sequence,filename::String, cell::String; output_elements=true, output_sequence=true, mode="w")
	open(filename,mode) do io
		output_elements && begin
			index=getIndexByClass(seq,Marker)
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				fmt=Printf.Format("%s : MARKER;\n")
				Printf.format(io,fmt,mag.Name)
			end

			length(index) !=0 && print(io,"\n\n\n")

			for T in [:Drift,:HMonitor,:VMonitor,:Monitor,:Instrument,:Placeholder]
				index=getIndexByClass(seq,eval(T))
				mags=[seq[i] for i in index]
				uniq_index=unique(i->mags[i].Name,1:length(mags))
				for mag in mags[uniq_index]
					fmt=Printf.Format("%s : $(uppercase(string(T))), L = %.15e;\n")
					Printf.format(io,fmt,mag.Name,mag.L)
				end
				length(index) !=0 && print(io,"\n\n\n")
			end

			index=getIndexByClass(seq,Quadrupole)
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				if abs(mag.K1S) > 1e-15
					fmt=Printf.Format("%s : QUADRUPOLE, L = %.15e, K1 = %.15e, K1S = %.15e;\n")
					Printf.format(io,fmt,mag.Name,mag.L,mag.K1,mag.K1S)
				else
					fmt=Printf.Format("%s : QUADRUPOLE, L = %.15e, K1 = %.15e;\n")
					Printf.format(io,fmt,mag.Name,mag.L,mag.K1)
				end
			end

			length(index) !=0 && print(io,"\n\n\n")
																						
			index=getIndexByClass(seq,ThinMultipole)
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				str_fmt="%s : MULTIPOLE"
				if length(mag.KnL) > 0
					str_fmt *= ", KNL = {" * "%.15e,"^(length(mag.KnL)-1) * "%.15e}"
				end
				if length(mag.KsL) > 0
					str_fmt *= ", KSL = {" * "%.15e,"^(length(mag.KsL)-1) * "%.15e}"
				end
				str_fmt *= ";\n"
				fmt=Printf.Format(str_fmt)
				Printf.format(io,fmt,mag.Name,(mag.KnL)...,(mag.KsL)...)
			end
																						
			length(index) !=0 && print(io,"\n\n\n")

			index=getIndexByClass(seq,ThinKicker)
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				fmt=Printf.Format("%s : KICKER, L=0.0, HKICK = %.15e, VKICK = %.15e;\n")
				Printf.format(io,fmt,mag.Name,mag.HKick,mag.VKick)
			end
																						
			length(index) !=0 && print(io,"\n\n\n")
																						
			index=getIndexByClass(seq,Kicker)
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				fmt=Printf.Format("%s : KICKER, L=%.15e, HKICK = %.15e, VKICK = %.15e;\n")
				Printf.format(io,fmt,mag.Name,mag.L,mag.HKick,mag.VKick)
			end
																						
			length(index) !=0 && print(io,"\n\n\n")
																						
			for T in [:HKicker,:VKicker]
				index=getIndexByClass(seq,eval(T))
				mags=[seq[i] for i in index]
				uniq_index=unique(i->mags[i].Name,1:length(mags))
				for mag in mags[uniq_index]
					fmt=Printf.Format("%s : $(string(T)), L = %.15e, KICK = %.15e;\n")
					Printf.format(io,fmt,mag.Name,mag.L,mag.Kick)
				end
				length(index) !=0 && print(io,"\n\n\n")
			end

			index=getIndexByClass(seq,SBend)
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				fmt_str="%s : SBEND, L = %.15e, ANGLE = %.15e"
				value=Float64[mag.L,mag.Angle]
				abs(mag.K1) > 1e-15 && (fmt_str*=", K1 = %.15e";push!(value,mag.K1))
				abs(mag.E1) > 1e-15 && (fmt_str*=", E1 = %.15e";push!(value,mag.E1))
				abs(mag.E2) > 1e-15 && (fmt_str*=", E2 = %.15e";push!(value,mag.E2))
				fmt_str*=";\n"
				fmt=Printf.Format(fmt_str)
				Printf.format(io,fmt,mag.Name,value...)
			end

			length(index) !=0 && print(io,"\n\n\n")

			index=getIndexByClass(seq,RBend)
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				fmt_str="%s : RBEND, L = %.15e, ANGLE = %.15e"
				value=Float64[mag.L,mag.Angle]
				abs(mag.K1) > 1e-15 && (fmt_str*=" K1 = %.15e";push!(value,mag.K1))
				abs(mag.E1) > 1e-15 && (fmt_str*=" E1 = %.15e";push!(value,mag.E1))
				abs(mag.E2) > 1e-15 && (fmt_str*=" E2 = %.15e";push!(value,mag.E2))
				fmt_str*=";\n"
				fmt=Printf.Format(fmt_str)
				Printf.format(io,fmt,mag.Name,value...)
			end

			length(index) !=0 && print(io,"\n\n\n")

			index=getIndexByClass(seq,Solenoid)
			mags=[seq[i] for i in index]
			uniq_index=unique(i->mags[i].Name,1:length(mags))
			for mag in mags[uniq_index]
				fmt=Printf.Format("%s : Solenoid, L = %.15e, KS = %.15e;\n")
				Printf.format(io,fmt,mag.Name,mag.L,mag.K)
			end
																					
			length(index) !=0 && print(io,"\n\n\n")

		end # of elements output

		if output_sequence
			names=join([seq[i].Name for i in 1:length(seq)],", ")
			print(io, "$(cell) : LINE = ($(names));\n")
		end
	end # of open file
		
	return
end # of function

function ReadSequenceFromTFS(filename)
	tfs=pyimport("tfs")
    data=tfs.read(filename)
    
    mags=JuAcc.AbstractElement[]
    
    for i in 2:data.shape[1]-1
        keyword=data["KEYWORD"][i]
        if keyword=="DRIFT"
            push!(mags,Drift(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="HMONITOR"
            push!(mags,HMonitor(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="VMONITOR"
            push!(mags,VMonitor(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="MONITOR"
            push!(mags,Monitor(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="PLACEHOLDER"
            push!(mags,Placeholder(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="INSTRUMENT"
            push!(mags,Instrument(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="QUADRUPOLE"
            push!(mags,Quadrupole(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="SBEND"
            push!(mags,SBend(L=data["L"][i],Name=data["NAME"][i],Angle=data["ANGLE"][i]))
        elseif keyword=="HKICKER"
            push!(mags,HKicker(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="VKICKER"
            push!(mags,VKicker(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="KICKER"
            push!(mags,Kicker(L=data["L"][i],Name=data["NAME"][i]))
        elseif keyword=="MULTIPOLE"
            push!(mags,ThinMultipole(Name=data["NAME"][i]))
        elseif keyword=="MARKER"
            push!(mags,Marker(Name=data["NAME"][i]))
        else
			throw(ArgumentError("Unknown keyword $(keyword)"))
        end
    end
    
    Sequence(mags)
end 
