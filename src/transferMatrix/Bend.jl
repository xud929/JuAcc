function _edgeMatrix(θ::RealType,h0::RealType)
	M=RealType(1)*Matrix(I,(6,6))
	t=tan(θ)*h0
	M[2,1]=t
	M[4,3]=-t
	return M
end

function _sectorBodyMatrix(L::RealType,h0::RealType,dx::RealType,
		Kx::RealType,Ky::RealType,rx::RealType,ry::RealType,β0::RealType,βγ0::RealType)
    M=zeros(RealType,(6,6))
	if rx>RealType(0)
		D0=dx/Kx
		tx=sqrt(Kx)
		th=tx*L
		C,S=cos(th),sin(th)
		M[1,1]=M[2,2]=C
		M[1,2]=S/tx
		M[2,1]=-tx*S
		M[1,6]=D0*(RealType(1)-C)
		M[2,6]=D0*S*tx
		M[5,6]=-D0*(L*h0-S*h0/tx)
	elseif rx<RealType(0)
		D0=dx/Kx
		tx=sqrt(-Kx)
		th=tx*L
		C,S=cosh(th),sinh(th)
		M[1,1]=M[2,2]=C
		M[1,2]=S/tx
		M[2,1]=tx*S
		M[1,6]=D0*(RealType(1)-C)
		M[2,6]=-D0*S*tx
		M[5,6]=-D0*(L*h0-S*h0/tx)
	else
		M[1,1]=M[2,2]=RealType(1)
		M[1,2]=L
		M[2,1]=RealType(0)
		M[1,6]=L*L*dx/RealType(2)
		M[2,6]=dx*L
		M[5,6]=-dx*h0*L^3/RealType(6)
	end

	if ry>RealType(0)
		ty=sqrt(Ky)
		th=ty*L
		C,S=cos(th),sin(th)
		M[3,3]=M[4,4]=C
		M[3,4]=S/ty
		M[4,3]=-ty*S
	elseif ry<RealType(0)
		ty=sqrt(-Ky)
		th=ty*L
		C,S=cosh(th),sinh(th)
		M[3,3]=M[4,4]=C
		M[3,4]=S/ty
		M[4,3]=ty*S
	else
		M[3,3]=M[4,4]=RealType(1)
		M[3,4]=L
	end

    
	for i = [1,2]
        M[i,6]/=β0
    end
	M[5,6]/=β0*β0
	M[5,6]+=L/(βγ0^2)
    
    M[5,1]=M[2,1]*M[1,6]-M[1,1]*M[2,6]
    M[5,2]=M[2,2]*M[1,6]-M[1,2]*M[2,6]
    
	M[5,5]=M[6,6]=RealType(1)
    
    return M
end

function transferMatrix(mag::SBend,beam::AbstractBeam=_beam[])
	mag.L == RealType(0) && (return RealType(1)*Matrix(I,(6,6)))
	h0=mag.Angle/mag.L
	Kx=h0*h0+mag.K1
	Ky=-mag.K1
	rx=Kx/(h0*h0);ry=Ky/(h0*h0)
	dx=h0

	M=_sectorBodyMatrix(mag.L,h0,dx,Kx,Ky,rx,ry,beam.β0,beam.βγ0)

	if mag.E1!=RealType(0)
		M=M*_edgeMatrix(mag.E1,h0)
	end

	if mag.E2!=RealType(0)
		M=_edgeMatrix(mag.E2,h0)*M
	end

	return M
end

function transferMatrix(mag::RBend,beam::AbstractBeam=_beam[])
	mag.L == RealType(0) && (return RealType(1)*Matrix(I,(6,6)))
	h0=RealType(2)*sin(mag.Angle/RealType(2))/mag.L
	Kx=h0*h0+mag.K1
	Ky=-mag.K1
	rx=Kx/(h0*h0);ry=Ky/(h0*h0)
	dx=h0

	M=_sectorBodyMatrix(mag.Angle/h0,h0,dx,Kx,Ky,rx,ry,beam.β0,beam.βγ0)

	return _edgeMatrix(mag.E2+mag.Angle/RealType(2),h0)*M*_edgeMatrix(mag.E1+mag.Angle/RealType(2),h0)
end

function transferMatrix(mag::DipEdge,beam::AbstractBeam=_beam[])
	return _edgeMatrix(mag.E1,mag.H)
end

function transferMatrix(mag::DipBody,beam::AbstractBeam=_beam[])
	mag.L == RealType(0) && (return RealType(1)*Matrix(I,(6,6)))
	h0=mag.Angle/mag.L
	Kx=h0*h0+mag.K1
	Ky=-mag.K1
	rx=Kx/(h0*h0);ry=Ky/(h0*h0)
	dx=h0
	return _sectorBodyMatrix(mag.L,h0,dx,Kx,Ky,rx,ry,beam.β0,beam.βγ0)
end
