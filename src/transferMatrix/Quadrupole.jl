function transferMatrix(mag::Quadrupole,beam::AbstractBeam=_beam[])
    b=mag.K1
    a=mag.K1S
    t1=sqrt(b*b+a*a)

    if t1==RealType(0)
        M=RealType(1)*Matrix(I,(6,6))
        M[1,2]=M[3,4]=mag.L
        M[5,6]=mag.L/(beam.βγ0^2)
        return M
    end 
    
    C,S=b+t1,-a
    t2=sqrt(C*C+S*S)
    if t2!=RealType(0)
        C/=t2;S/=t2
    else
        C,S=-a,b-t1
        t2=sqrt(C*C+S*S)
        C/=t2;S/=t2
    end 
    t1=sqrt(t1)
    th=t1*mag.L
    
    A=zeros(RealType,(4,4))
    invA=zeros(RealType,(4,4))
    for i=1:4
        A[i,i]=invA[i,i]=C
    end 
    A[1,3]=A[2,4]=invA[3,1]=invA[4,2]=S
    A[3,1]=A[4,2]=invA[1,3]=invA[2,4]=-S
    
    M=zeros(RealType,(6,6))
    C,S=cos(th),sin(th)
    M[1,1]=M[2,2]=C
    M[1,2]=S/t1
    M[2,1]=-S*t1
    C,S=cosh(th),sinh(th)
    M[3,3]=M[4,4]=C
    M[3,4]=S/t1
    M[4,3]=S*t1
    M[5,5]=M[6,6]=1
    M[1:4,1:4]=invA*M[1:4,1:4]*A
	M[5,6]=mag.L/(beam.βγ0^2)
    return M
end

function transferMatrix(mag::ThinQuad,beam::AbstractBeam=_beam[])
    M=RealType(1)*Matrix(I,(6,6))
    M[4,3]=mag.K1L
    M[2,1]=-M[4,3]
    M[2,3]=M[4,1]=mag.K1SL
    return M
end
