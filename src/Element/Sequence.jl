function expandSequence(mags...)
    ret=AbstractElement[]
    for mag in mags
        T=typeof(mag)
        if T <: AbstractElement
            push!(ret,mag)
        elseif T <: Union{Array,Tuple,NamedTuple}
            temp=expandSequence(mag...)
            append!(ret,temp)
        else
            throw(ArgumentError("Argument Error for type $(string(T))"))
        end
    end
    return ret
end

mutable struct Sequence <: AbstractSequence
	Line::Array{T,1} where {T <: AbstractElement}
	Name::String
	Depth::IntType
end

Sequence(;Line::Array{T,1},Name::String="",Depth::IntType=0) where {T <: AbstractElement}=begin
	if Depth!=0
		return Sequence(Line,Name,Depth)
	else
		for mag in Line
			if isa(mag,AbstractSequence)
				if Depth < mag.Depth
					Depth = mag.Depth
				end
			end
		end
		return Sequence(Line,Name,Depth+1)
	end
end
Sequence(Line::Array{T,1}) where {T <: AbstractElement}=Sequence(;Line=Line,Name="",Depth=0)
Sequence(Line::Array{T,1},Name::String) where {T <: AbstractElement}=Sequence(;Line=Line,Name=Name,Depth=0)
Sequence(mags...;Name::String="",Depth::IntType=0)=Sequence(;Line=expandSequence(mags...),Name=Name,Depth=Depth)

function _flatten(seq::Sequence,dep::IntType)
	ret=AbstractElement[]
	for ele in seq.Line
		if isa(ele,AbstractDevice) || isa(ele,AbstractTransformation)
			push!(ret,ele)
		elseif isa(ele,AbstractSequence)
			if ele.Depth > dep
				append!(ret,_flatten(ele,dep))
			else
				push!(ret,ele)
			end
		else
			throw(ArgumentError("Invalid element type: $(typeof(ele))"))
		end
	end
	return ret
end

flatten(seq::Sequence,dep::IntType=0)=let
	line=_flatten(seq,dep)
	max_depth_of_subSequence=0
	for ele in line
		if isa(ele,AbstractSequence)
			if ele.Depth>max_depth_of_subSequence
				max_depth_of_subSequence=ele.Depth
			end
		end
	end
	return Sequence(;Line=_flatten(seq,dep),Name=seq.Name,Depth=min(max_depth_of_subSequence,dep)+1)
end

function getNames(seq::AbstractSequence)
    ret=Array{String,1}()
    for i in seq.Line
        push!(ret,i.Name)
    end
    return ret
end

function getTypes(seq::AbstractSequence)
    ret=Array{String,1}()
    for i in seq.Line
        push!(ret,getType(i))
    end
    return ret
end

function getIndexByName(seq::AbstractSequence,name::String;first=false,last=false)
	if first
		for i = 1:length(seq.Line)
			(Unicode.normalize(name, casefold=true) == Unicode.normalize(seq.Line[i].Name, casefold=true)) && (return i)
		end 
	elseif last
		for i = length(seq.Line):-1:1
			(Unicode.normalize(name, casefold=true) == Unicode.normalize(seq.Line[i].Name, casefold=true)) && (return i)
		end 
	end
    ret=Array{Int64,1}()
    for i = 1:length(seq.Line)
        if Unicode.normalize(name, casefold=true) == Unicode.normalize(seq.Line[i].Name, casefold=true)
            push!(ret,i)
        end
    end 
    return ret 
end

function getIndexByClass(seq::AbstractSequence,cls::Type{U};first=false,last=false) where {U <: AbstractElement}
	if first
		for i = 1:length(seq.Line)
			isa(seq.Line[i], cls) && (return i)
		end
	elseif last
		for i = length(seq.Line):-1:1
			isa(seq.Line[i], cls) && (return i)
		end
	end
    ret=Array{Int64,1}()
    for i = 1:length(seq.Line)
        if isa(seq.Line[i], cls)
            push!(ret,i)
        end
    end 
    return ret 
end

function getIndexByRegex(seq::AbstractSequence,re::Regex;first=false,last=false)
	if first
		for i = 1:length(seq.Line)
			occursin(re,seq.Line[i].Name) && (return i)
		end
	elseif last
		for i = length(seq.Line):-1:1
			occursin(re,seq.Line[i].Name) && (return i)
		end
	end
    ret=Array{Int64,1}()
    for i = 1:length(seq.Line)
		if occursin(re,seq.Line[i].Name)
            push!(ret,i)
        end
    end 
    return ret 
end

Base.getindex(seq::Sequence,key::Integer)=seq.Line[key]
Base.setindex!(seq::Sequence,mag::AbstractElement,key::Integer)=(seq.Line[key]=mag;)
Base.firstindex(seq::Sequence)=firstindex(seq.Line)
Base.lastindex(seq::Sequence)=lastindex(seq.Line)
Base.getindex(seq::Sequence,I)=Sequence([seq.Line[i] for i in I])
Base.length(seq::Sequence)=length(seq.Line)
(Base.:*)(seq1::Sequence,seq2::Sequence)=vcat(seq1.Line,seq2.Line)
(Base.:*)(seq1::Vector{AbstractElement},seq2::Vector{AbstractElement})=vcat(seq1,seq2)
(Base.:*)(seq1::Sequence,mag::AbstractElement)=vcat(seq1.Line,mag)
(Base.:*)(seq1::Vector{AbstractElement},mag::AbstractElement)=vcat(seq1,mag)
(Base.:*)(mag::AbstractElement,seq1::Sequence)=vcat(mag,seq1.Line)
(Base.:*)(mag::AbstractElement,seq1::Vector{AbstractElement})=vcat(mag,seq1)
(Base.:*)(mag1::AbstractElement,mag2::AbstractElement)=[mag1,mag2]
(Base.:-)(seq::Sequence)=seq.Line[end:-1:1]
(Base.:-)(seq::Vector{AbstractElement})=seq[end:-1:1]
(Base.:^)(seq::Vector{AbstractElement},n::Integer)=begin
	@assert n>0
	base=seq
	ret=AbstractElement[]
	while true
		n&1==1 && (ret=vcat(ret,base))
		n>>=1
		n==0 && break
		base=vcat(base,base)
	end
	return ret
end
(Base.:^)(seq::Sequence,n::Integer)=(seq.Line)^n
(Base.:^)(mag::AbstractElement,n::Integer)=begin
	@assert n>0
	base=[mag]
	ret=AbstractElement[]
	while true
		n&1==1 && (ret=vcat(ret,base))
		n>>=1
		n==0 && break
		base=vcat(base,base)
	end
	return ret
end

function sequenceSummary(seq::Sequence)
	any(broadcast(isa,seq.Line,AbstractSequence)) && begin
		throw(ArgumentError("Sequence $(seq.Name) contains another Sequence. Please flatten the sequence before proceeding."))
	end
	ss=zeros(RealType,length(seq)+1)
	name=Vector{String}(undef,length(ss))
	type=Vector{String}(undef,length(ss))
	ss[1]=RealType(0)
	name[1]="==Start=="
	type[1]="==None=="
	for (index,mag) in enumerate(seq.Line)
		name[index+1]=mag.Name
		type[index+1]=getType(mag)
		ss[index+1]=ss[index]+refS(mag)
	end
	return StructArray((name=name,type=type,s=ss))
end
