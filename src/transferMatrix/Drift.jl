
function transferMatrix(mag::Drift,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
    M[1,2]=M[3,4]=mag.L
    M[5,6]=mag.L/(beam.βγ0^2)
    return M	
end
