
refS(mag::AbstractElement)=mag.L
refS(mag::RBend)=(th=mag.Angle/RealType(2);th/sin(th)*mag.L)

for magType in [:ThinQuad,:Marker,:ThinCrabCavity,:LorentzBoost,:RevLorentzBoost,:DipEdge,:ThinKicker,:ThinMultipole]
	eval(quote
		 refS(::$(magType))=RealType(0)
   end)
end

function refS(seq::Sequence)
	ret=RealType(0)
	for mag in seq.Line
		ret+=refS(mag)
	end
	return ret
end

function refS(seq::Sequence,ind::Integer)
    ret=RealType(0)
    @assert ind>=0
    ind==0 && (return ret)
    for i = 1:(ind)
        ret+=refS(seq.Line[i])
    end
    return ret
end

function refSAll(seq::Sequence)
	ret=Vector{RealType}(undef,length(seq)+1)
	ret[1]=RealType(0)
	for i = 2:length(ret)
		ret[i]=ret[i-1]+refS(seq[i-1])
    end
    return ret
end
