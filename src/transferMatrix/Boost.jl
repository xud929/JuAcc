
function transferMatrix(mag::LorentzBoost,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
    M[2,2]=M[4,4]=M[5,5]=RealType(1)/cos(mag.θc)
    M[1,5]=M[2,2]*sin(mag.θc)
    M[6,2]=-M[1,5]
    if mag.θs==RealType(0)
        return M
    else
        R=RealType(1)*Matrix(I,(6,6))
        for i = 1:4 
            R[i,i]=cos(mag.θs)
        end
        R[1,3]=R[2,4]=sin(mag.θs)
        R[3,1]=R[4,2]=-R[1,3]
        return M*R 
    end 
end

function transferMatrix(mag::RevLorentzBoost,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
    M[2,2]=M[4,4]=M[5,5]=cos(mag.θc)
    M[6,2]=sin(mag.θc)
    M[1,5]=-M[6,2]
    if mag.θs==RealType(0)
        return M
    else
        R=RealType(1)*Matrix(I,(6,6))
        for i = 1:4 
            R[i,i]=cos(mag.θs)
        end
        R[1,3]=R[2,4]=-sin(mag.θs)
        R[3,1]=R[4,2]=-R[1,3]
        return R*M 
    end 
end

