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


abstract type AbstractSequence end

struct Sequence <: AbstractSequence
	Line::Array{T,1} where {T <: AbstractElement}
end

Sequence(;Line::Array{T,1}) where {T <: AbstractElement}=Sequence(Line)
Sequence(mags...)=Sequence(expandSequence(mags...))

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

function getIndexByName(seq::AbstractSequence,name::String)
    ret=Array{Int64,1}()
    for i = 1:length(seq.Line)
        if Unicode.normalize(name, casefold=true) == Unicode.normalize(seq.Line[i].Name)
            push!(ret,i)
        end
    end 
    return ret 
end

function getIndexByClass(seq::AbstractSequence,cls::Type{U}) where {U <: AbstractElement}
    ret=Array{Int64,1}()
    for i = 1:length(seq.Line)
        if isa(seq.Line[i], cls)
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
(Base.:*)(seq1::Sequence,seq2::Sequence)=Sequence(vcat(seq1.Line,seq2.Line))
(Base.:*)(seq1::Sequence,mag::AbstractElement)=Sequence(vcat(seq1.Line,mag))
(Base.:*)(mag::AbstractElement,seq1::Sequence)=Sequence(vcat(mag,seq1.Line))
(Base.:*)(mag1::AbstractElement,mag2::AbstractElement)=Sequence([mag1,mag2])
(Base.:-)(seq::Sequence)=Sequence(seq.Line[end:-1:1])
(Base.:^)(seq::Sequence,n::Integer)=begin
	@assert n>0
	base=seq
	ret=Sequence(AbstractElement[])
	while true
		n&1==1 && (ret*=base)
		n>>=1
		n==0 && break
		base*=base
	end
	return ret
end
(Base.:^)(mag::AbstractElement,n::Integer)=begin
	@assert n>0
	base=Sequence([mag])
	ret=Sequence(AbstractElement[])
	while true
		n&1==1 && (ret*=base)
		n>>=1
		n==0 && break
		base*=base
	end
	return ret
end
