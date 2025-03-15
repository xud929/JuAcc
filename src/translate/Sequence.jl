function _sequence_format(name::String, content::String, ::Type{MadXModel})
	return (@sprintf "%s : LINE = (%s); %s" name content DEFAULT_SETTING.line_separator) 
end

function _sequence_format(name::String, content::String, ::Type{JuAccModel})
	return (@sprintf "@Sequence %s Line = [%s]%s" name content DEFAULT_SETTING.line_separator) 
end

function translate!(io::IO, seq::Sequence, TMX::Type{T}; output_element=true, output_sequence=true) where {T <: Union{MadXModel, JuAccModel}}
	ret=SequenceAnalysis(seq)
	if isa(output_element, Bool) && output_element
		cnt=0
		for ele in ret.element_set
			if isempty(ele.Name)
				cnt+=1
				ele.Name="ele$(cnt)"
			end
			translate!(io, ele, TMX)
		end
		print(io, DEFAULT_SETTING.block_separator)
	elseif isa(output_element, Union{Array,Tuple,NamedTuple})
		for ele in ret.element_set
			if ele.Name in output_element
				translate!(io, ele, TMX)
			end
		end
	elseif isa(output_element, String)
		for ele in ret.element_set
			if ele.Name==output_element
				translate!(io, ele, TMX)
			end
		end
	else
		throw(ArgumentError("Output element $(output_element) is not recognized."))
	end

	if isa(output_sequence, Bool) && output_sequence
		cnt=0
		for each_seq in ret.sequence_list
			if isempty(each_seq.Name)
				cnt+=1
				each_seq.Name="seq$(cnt)"
			end
			names=join([each_seq[i].Name for i in 1:length(each_seq)],", ")
			print(io, _sequence_format(each_seq.Name, names, TMX))
		end
	elseif isa(output_sequence, Union{Array,Tuple,NamedTuple})
		for each_seq in ret.sequence_list
			if each_seq.Name in output_element
				names=join([each_seq[i].Name for i in 1:length(each_seq)],", ")
				print(io, _sequence_format(each_seq.Name, names, TMX))
			end
		end
	elseif isa(output_sequence, String)
		for each_seq in ret.sequence_list
			if each_seq.Name==output_sequence
				names=join([each_seq[i].Name for i in 1:length(each_seq)],", ")
				print(io, _sequence_format(each_seq.Name, names, TMX))
			end
		end
	else
		throw(ArgumentError("Output sequence $(output_sequence) is not recognized."))
	end
end

function translate(seq::Sequence, filename::String; output_element=true, output_sequence=true, mode::String="w", output_format="MADX")
	open(filename,mode) do io
		if isa(output_format, String)
			output_format=uppercase(output_format)
			if output_format=="MADX"
				translate!(io, seq, MadXModel; output_element=output_element, output_sequence=output_sequence)
			elseif output_format=="JUACC"
				translate!(io, seq, JuAccModel; output_element=output_element, output_sequence=output_sequence)
			else
				throw(ArgumentError("Output format $(output_format) is not recognized."))
			end
		else
			translate!(io, seq, output_format; output_element=output_element, output_sequence=output_sequence)
		end
	end
end
