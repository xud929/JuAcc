function transferMatrix(mag::ThinKicker,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
	M[2,6]=mag.HKick
	M[4,6]=mag.VKick
	M[5,1]=-mag.HKick
	M[5,3]=-mag.VKick
	return M
end
