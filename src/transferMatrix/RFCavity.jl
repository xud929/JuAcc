
function transferMatrix(mag::ThinRFCavity,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
	M[6,5]=beam.charge*mag.Voltage/(beam.E0*(beam.β0^2)*1e9)*mag.Krf
    return M
end

