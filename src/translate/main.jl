module LatticeTranslator

	using ..JuAcc  # Access parent module JuAcc
	using Printf

	export translate,MadXModel,JuAccModel

	struct SequenceAnalysis
		element_set::Set{AbstractElement}
		sequence_list::Vector{Sequence}
	end

	function analyze!!(ele_set::Set{AbstractElement}, seq_set::Set{Sequence}, seq::Sequence)
		push!(seq_set, seq)
		for mag in seq.Line
			if isa(mag, AbstractSequence)
				analyze!!(ele_set, seq_set, mag)
			else
				push!(ele_set,mag)
			end 
		end 
		return
	end
		
	function SequenceAnalysis(original_seq::Sequence)
		seq = deepcopy(original_seq)
		ele_set = Set{AbstractElement}()
		seq_set = Set{Sequence}()
		analyze!!(ele_set,seq_set,seq)
		seq_list = sort(collect(seq_set), by = x -> x.Depth)
		return SequenceAnalysis(ele_set,seq_list)
	end

	abstract type AbstractModel end

	struct MadXModel <: AbstractModel end
	struct JuAccModel <: AbstractModel end

	mutable struct TranslatorSetting
		float_format::String
		int_format::String
		string_format::String
		line_separator::String
		block_separator::String
	end

	const DEFAULT_SETTING :: TranslatorSetting = TranslatorSetting("%.15e","%d", "%s", "\n", "\n\n\n")

	function update_setting(;float_format=nothing, int_format=nothing, string_format=nothing, line_separator=nothing, block_separator=nothing)
		!(float_format === nothing) && (DEFAULT_SETTING.float_format = float_format)
		!(int_format === nothing) && (DEFAULT_SETTING.int_format = int_format)
		!(string_format === nothing) && (DEFAULT_SETTING.string_format = string_format)
		!(line_separator === nothing) && (DEFAULT_SETTING.line_separator = line_separator)
		!(block_separator === nothing) && (DEFAULT_SETTING.block_separator = block_separator)
	end

	format_from_type(::Type{RealType})=DEFAULT_SETTING.float_format
	format_from_type(::Type{IntType})=DEFAULT_SETTING.int_format
	format_from_type(::Type{String})=DEFAULT_SETTING.string_format
	format_from_type(::Type{Bool})=DEFAULT_SETTING.string_format

	#function translate!(io::IO, mag::AbstractElement, ::Type{MadXModel})
	#end

	function _translate2JuAcc!(io::IO, mag::AbstractElement, optional_keywords::Dict{Symbol,TYPE}) where TYPE
		T=typeof(mag)
		fmt="@$(T) $(mag.Name)"
		value=Any[]
		for field in fieldnames(typeof(mag))
			if field == :Name
				continue
			end
			if !(field in keys(optional_keywords)) || (getfield(mag,field)!=optional_keywords[field])
				fmt *= @sprintf " %s=%s" string(field) format_from_type(fieldtype(T,field))
				push!(value,getfield(mag,field))
			end
		end
		fmt *= DEFAULT_SETTING.line_separator
		Printf.format(io, Printf.Format(fmt), value...)
	end

	function _translate2MadX!(io::IO, mag::AbstractElement, optional_keywords::Dict{Symbol,TYPE}, madx_type::String="") where TYPE
		T=typeof(mag)
		if isempty(madx_type)
			fmt="$(mag.Name): $(uppercase(string(T)))"
		else
			fmt="$(mag.Name): $(uppercase(madx_type))"
		end
		value=Any[]
		for field in fieldnames(typeof(mag))
			if field == :Name
				continue
			end
			if !(field in keys(optional_keywords)) || (getfield(mag,field)!=optional_keywords[field])
				fmt *= @sprintf ", %s=%s" uppercase(string(field)) format_from_type(fieldtype(T,field))
				push!(value,getfield(mag,field))
			end
		end
		fmt *= ";" * DEFAULT_SETTING.line_separator
		Printf.format(io, Printf.Format(fmt), value...)
	end

	include("Boost.jl")
	include("Drift.jl")
	include("Bend.jl")
	include("Quadrupole.jl")
	include("Kicker.jl")
	include("Marker.jl")
	include("Multipole.jl")
	include("Solenoid.jl")
	include("Sequence.jl")

end
