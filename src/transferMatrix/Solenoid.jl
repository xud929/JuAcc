
function transferMatrix(mag::Solenoid,beam::AbstractBeam=_beam[])
    K=mag.KS/RealType(2)
    th=K*mag.L
    C,S=cos(th),sin(th)
    ret=RealType(1)*Matrix(I,(6,6))
    CC=C*C
    SC=S*C
    SS=S*S
    ret[1,1]=ret[2,2]=ret[3,3]=ret[4,4]=CC
    ret[1,2]=ret[3,4]=SC/K
    ret[1,3]=ret[2,4]=SC
    ret[1,4]=SS/K
    ret[2,1]=ret[4,3]=-SC*K
    ret[2,3]=-K*SS
    ret[3,1]=ret[4,2]=-ret[1,3]
    ret[3,2]=-ret[1,4]
    ret[4,1]=-ret[2,3]
    ret[5,6]=mag.L/(beam.βγ0^2)
    
    return ret 
end

