struct EdwardsTengTwiss <: AbstractTwiss
	beta::SVector{2,RealType}
	alpha::SVector{2,RealType}
	gamma::SVector{2,RealType}
	eta::SVector{4,RealType}
	sc_mu::SVector{4,RealType} # sin(mu1) cos(mu1) sin(mu2) cos(mu2)
	R::SMatrix{2,2,RealType}
	mode::IntType
end

EdwardsTengTwiss(;betx::RealType,bety::RealType,
			   alfx::RealType=RealType(0),alfy::RealType=RealType(0),
			   dx::RealType=RealType(0),dy::RealType=RealType(0),
			   dpx::RealType=RealType(0),dpy::RealType=RealType(0),
			   mux::RealType=RealType(0),muy::RealType=RealType(0),
			   R11::RealType=RealType(0),R12::RealType=RealType(0),
			   R21::RealType=RealType(0),R22::RealType=RealType(0),
			   mode::IntType=IntType(1))=EdwardsTengTwiss([betx,bety],[alfx,alfy],[(RealType(1)+alfx^2)/betx,(RealType(1)+alfy^2)/bety],
														  [dx,dpx,dy,dpy],[sin(mux),cos(mux),sin(muy),cos(muy)],[R11 R12;R21 R22],mode)

_symplectic_conjugate_2by2(M)=return RealType[M[2,2] -M[1,2];-M[2,1] M[1,1]]
_matrixTransform_2by2(M)=begin
    m11,m21,m12,m22=M
    [m11*m11 -2m11*m12 m12*m12
    -m11*m21 1.0+2m12*m21 -m12*m22
    m21*m21 -2m21*m22 m22*m22]
end

function twissPropagate(tin::EdwardsTengTwiss,M::Matrix{RealType})
	A=@view M[1:2,1:2]
	B=@view M[1:2,3:4]
	C=@view M[3:4,1:2]
	D=@view M[3:4,3:4]

	R1=tin.R
	_R1=_symplectic_conjugate_2by2(R1)
	if tin.mode == IntType(1)
		X=A-B*R1
		begin t=det(X)
			if t>RealType(0.1)
				R=(D*R1-C)*_symplectic_conjugate_2by2(X)
				R/=t
				X/=sqrt(t)
				Y=D+C*_R1
				Y/=sqrt(det(Y))
				mode=IntType(1)
			else
				X=C-D*R1
				X/=sqrt(det(X))
				Y=B+A*_R1
				t=det(Y)
				R=-(D+C*_R1)*_symplectic_conjugate_2by2(Y)
				R/=t
				Y/=sqrt(t)
				mode=IntType(2)
			end
		end
	elseif tin.mode == IntType(2) 
		X=B+A*_R1
		begin t=det(X)
			if t>RealType(0.1)
				R=-(D+C*_R1)*_symplectic_conjugate_2by2(X)
				R/=t
				X/=sqrt(t)
				Y=C-D*R1
				Y/=sqrt(det(Y))
				mode=IntType(1)
			else
				X=D+C*_R1
				X/=sqrt(det(X))
				Y=A-B*R1
				t=det(Y)
				R=(D*R1-C)*_symplectic_conjugate_2by2(Y)
				R/=t
				Y/=sqrt(t)
				mode=IntType(2)
			end
		end
	else
		throw(AssertionError("Mode should be integer 1 or 2."))
	end

	Nx=_matrixTransform_2by2(X)
	Ny=_matrixTransform_2by2(Y)
	v1=Nx*[tin.beta[1];tin.alpha[1];tin.gamma[1]]
	v2=Ny*[tin.beta[2];tin.alpha[2];tin.gamma[2]]

	eta=(@view M[1:4,1:4])*tin.eta+(@view M[1:4,6])
	sin_dmux=X[1,2]/sqrt(v1[1]*tin.beta[1])
	cos_dmux=X[1,1]*sqrt(tin.beta[1]/v1[1])-tin.alpha[1]*sin_dmux
	sin_dmuy=Y[1,2]/sqrt(v2[1]*tin.beta[2])
	cos_dmuy=Y[1,1]*sqrt(tin.beta[2]/v2[1])-tin.alpha[2]*sin_dmuy

	smux0,cmux0,smuy0,cmuy0=tin.sc_mu
	smux=sin_dmux*cmux0+cos_dmux*smux0
	cmux=cos_dmux*cmux0-sin_dmux*smux0
	smuy=sin_dmuy*cmuy0+cos_dmuy*smuy0
	cmuy=cos_dmuy*cmuy0-sin_dmuy*smuy0

	return EdwardsTengTwiss([v1[1],v2[1]],[v1[2],v2[2]],[v1[3],v2[3]],eta,[smux,cmux,smuy,cmuy],R,mode)
end


function twissPropagate(tin::AbstractTwiss,seq::Sequence,beam::AbstractBeam=_beam[])
	ret=Vector{typeof(tin)}(undef,1+length(seq))
	ss=zeros(RealType,length(ret))
	names=Vector{String}(undef,length(ret))
	ret[1]=tin
	names[1]="Start"
	for (index,mag) in enumerate(seq.Line)
		M=transferMatrix(mag,beam)
		ret[index+1]=twissPropagate(ret[index],M)
		ss[index+1]=refS(mag)+ss[index]
		names[index+1]=mag.Name
	end
	return ss,names,StructArray(ret)
end
