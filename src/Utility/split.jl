makeThin(mag::AbstractElement,step::RealType)=Sequence([mag])

function makeThin(mag::Drift,step::RealType)
	step < mag.L || (return Sequence([mag]))
	nn,rr=fldmod(refS(mag),step)
	return Drift(;L=step)^floor(Integer,nn)*Drift(;L=rr)
end

function makeThin(mag::Quadrupole,step::RealType)
	step < mag.L || (return Sequence([mag]))
	nn,rr=fldmod(refS(mag),step)
	return Quadrupole(;L=step,K1=mag.K1,K1S=mag.K1S)^floor(Integer,nn)*Quadrupole(;L=rr,K1=mag.K1,K1S=mag.K1S)
end

function makeThin(mag::DipBody,step::RealType)
	step < mag.L || (return Sequence([mag]))
	nn,rr=fldmod(refS(mag),step)
	return DipBody(;L=step,Angle=mag.Angle*step/mag.L,K1=mag.K1)^floor(Integer,nn)*DipBody(;L=rr,Angle=mag.Angle*rr/mag.L,K1=mag.K1)
end

function makeThin(mag::SBend,step::RealType)
	h=mag.Angle/mag.L
	lft=DipEdge(;H=h,E1=mag.E1,FInt=mag.FInt1)
	mid=DipBody(;L=mag.L,Angle=mag.Angle,K1=mag.K1)
	rt=DipEdge(;H=h,E1=mag.E2,FInt=mag.FInt2)
	return lft*makeThin(mid,step)*rt
end

function makeThin(mag::RBend,step::RealType)
	L=refS(mag)
	h=mag.Angle/L
	lft=DipEdge(;H=h,E1=mag.E1+mag.Angle/RealType(2),FInt=mag.FInt1)
	mid=DipBody(;L=L,Angle=mag.Angle,K1=mag.K1)
	rt=DipEdge(;H=h,E1=mag.E2+mag.Angle/RealType(2),FInt=mag.FInt2)
	return lft*makeThin(mid,step)*rt
end

function makeThin(seq::Sequence,step::RealType)
	ret=Sequence(AbstractElement[])
	for mag in seq.Line
		ret*=makeThin(mag,step)
	end
	return ret
end
