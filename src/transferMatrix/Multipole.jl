
function transferMatrix(mag::ThinMultipole,beam::AbstractBeam=_beam[])
	θx=(length(mag.KnL)>0 ? -mag.KnL[1] : 0.0)
	θy=(length(mag.KsL)>0 ? mag.KsL[1] : 0.0)
	kn=(length(mag.KnL)>1 ? mag.KnL[2] : 0.0)
	ks=(length(mag.KsL)>1 ? mag.KsL[2] : 0.0)
    M=RealType(1)*Matrix(I,(6,6))
    M[4,3]=kn
    M[2,1]=-kn
    M[2,3]=M[4,1]=ks
	M[2,6]=-θx/beam.β0
	M[4,6]=-θy/beam.β0
	M[5,1]=-M[2,6]
	M[5,3]=-M[4,6]
    return M
end
