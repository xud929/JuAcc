function transferMatrix(mag::ThinKicker,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
	M[2,6]=-mag.HKick
	M[4,6]=-mag.VKick
	M[5,1]=mag.HKick
	M[5,3]=mag.VKick
	return M
end

function transferMatrix(mag::Kicker,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
	M[5,2]=M[1,6]=-mag.HKick*mag.L*0.5/beam.β0
	M[5,4]=M[3,6]=-mag.VKick*mag.L*0.5/beam.β0
	M[1,2]=M[3,4]=mag.L
    M[5,6]=mag.L/(beam.βγ0^2)
	return M
end

function transferMatrix(mag::HKicker,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
	M[5,2]=M[1,6]=-mag.Kick*mag.L*0.5/beam.β0
	M[1,2]=M[3,4]=mag.L
    M[5,6]=mag.L/(beam.βγ0^2)
	return M
end

function transferMatrix(mag::VKicker,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
	M[5,4]=M[3,6]=-mag.Kick*mag.L*0.5/beam.β0
	M[1,2]=M[3,4]=mag.L
    M[5,6]=mag.L/(beam.βγ0^2)
	return M
end
