function transferMatrix(seq::Sequence,beam::AbstractBeam=_beam[])
    ret=Matrix(I,(6,6))
    for mag in seq.Line
        ret=transferMatrix(mag,beam)*ret
    end 
    return ret 
end

function transferMatrixAll(seq::Sequence,beam::AbstractBeam=_beam[])
	MS=Array{RealType,3}(undef,(6,6,length(seq)+1))
	MS[:,:,1]=RealType(1)*Matrix(I,(6,6))
	for (index,mag) in enumerate(seq.Line)
		MS[:,:,index+1]=transferMatrix(mag,beam)*MS[:,:,index]
    end 
    return MS
end

