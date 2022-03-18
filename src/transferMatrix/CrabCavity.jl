
function transferMatrix(mag::ThinCrabCavity,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
    M[2,5]=M[6,1]=-mag.Strength[1]
    M[4,5]=M[6,3]=-mag.Strength[2]
    return M
end

