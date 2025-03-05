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
	#flip_criteria=RealType(0.1)
	flip_criteria=RealType(0)
	if tin.mode == IntType(1)
		X=A-B*R1
		begin t=det(X)
			if t>flip_criteria
				R=(D*R1-C)*_symplectic_conjugate_2by2(X)
				R/=t
				X/=sqrt(t)
				Y=D+C*_R1
				t=det(Y)
				if t<flip_criteria
					return EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))
				end
				Y/=sqrt(t)
				mode=IntType(1)
			else
				X=C-D*R1
				t2=det(X)
				if t2<flip_criteria
					return EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))
				end
				X/=sqrt(t2)
				Y=B+A*_R1
				t=det(Y)
				if t<flip_criteria
					return EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))
				end
				R=-(D+C*_R1)*_symplectic_conjugate_2by2(Y)
				R/=t
				Y/=sqrt(t)
				mode=IntType(2)
			end
		end
	elseif tin.mode == IntType(2) 
		X=B+A*_R1
		begin t=det(X)
			if t>flip_criteria
				R=-(D+C*_R1)*_symplectic_conjugate_2by2(X)
				R/=t
				X/=sqrt(t)
				Y=C-D*R1
				t=det(Y)
				if t<flip_criteria
					return EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))
				end
				Y/=sqrt(t)
				mode=IntType(1)
			else
				X=D+C*_R1
				t2=det(X)
				if t2<flip_criteria
					return EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))
				end
				X/=sqrt(t2)
				Y=A-B*R1
				t=det(Y)
				if t<flip_criteria
					return EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))
				end
				R=(D*R1-C)*_symplectic_conjugate_2by2(Y)
				R/=t
				Y/=sqrt(t)
				mode=IntType(2)
			end
		end
	else
		#throw(AssertionError("Mode should be integer 1 or 2."))
		#println(stderr,"Invalid mode.")
		return EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))
	end

	Nx=_matrixTransform_2by2(X)
	Ny=_matrixTransform_2by2(Y)
	v1=Nx*[tin.beta[1];tin.alpha[1];tin.gamma[1]]
	v2=Ny*[tin.beta[2];tin.alpha[2];tin.gamma[2]]
	if ((v1[1]<=RealType(0)) || (v2[1]<=RealType(0)))
		return EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))
	end

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
	sumy=sequenceSummary(seq)
	ret=Vector{typeof(tin)}(undef,1+length(seq))
	ret[1]=tin
	for (index,mag) in enumerate(seq.Line)
		M=transferMatrix(mag,beam)
		ret[index+1]=twissPropagate(ret[index],M)
	end
	ret=StructArray(ret)
	return StructArray(merge(StructArrays.components(sumy),StructArrays.components(ret)))
end


function periodicEdwardsTengTwiss(M::Matrix{RealType};output_warning=true)
	A=@view M[1:2,1:2]
	B=@view M[1:2,3:4]
	C=@view M[3:4,1:2]
	D=@view M[3:4,3:4]
	invalid_ret=EdwardsTengTwiss(;betx=RealType(1),bety=RealType(1),mode=IntType(0))

	Bbar_and_C=_symplectic_conjugate_2by2(B)+C
	t1=0.5*(tr(A)-tr(D))
	Δ=t1*t1+det(Bbar_and_C)
	Δ<RealType(0) && begin
		if output_warning
			println(stderr,"Failed to decouple periodic transfer matrix. The linear matrix is unstable.")
		end
		return invalid_ret
	end

	_sign= t1>RealType(0) ? RealType(-1) : RealType(1)

	t2=abs(t1)+sqrt(Δ)
	if t2==RealType(0)
		R=RealType[0 0;0 0]
	else
		R=Bbar_and_C*(_sign/t2)
	end

	X=A-B*R
	Y=D+C*_symplectic_conjugate_2by2(R)

	# It should be equal to 1
	(det(X)<RealType(0.9) || det(Y)<RealType(0.9))  && begin
		if output_warning
			println(stderr,"Failed to decouple the periodic transfer matrix with mode 1.")
		end
		return invalid_ret
	end

	cmux=RealType(0.5)*(X[1,1]+X[2,2])
	cmuy=RealType(0.5)*(Y[1,1]+Y[2,2])
	(RealType(-1)<cmux<RealType(1) && RealType(-1)<cmuy<RealType(1)) || begin
		if output_warning
			println(stderr,"Failed to get beta functions. The linear matrix is unstable.")
		end
		return invalid_ret
	end

	smux=sqrt(RealType(1)-cmux*cmux)*sign(X[1,2])
	smuy=sqrt(RealType(1)-cmuy*cmuy)*sign(Y[1,2])
	betx=X[1,2]/smux
	gamx=-X[2,1]/smux
	bety=Y[1,2]/smuy
	gamy=-Y[2,1]/smuy

	alfx=RealType(0.5)*(X[1,1]-X[2,2])/smux
	alfy=RealType(0.5)*(Y[1,1]-Y[2,2])/smuy

	eta=inv(Matrix{RealType}(I,(4,4))-(@view M[1:4,1:4]))*(@view M[1:4,6])
	return EdwardsTengTwiss([betx,bety],[alfx,alfy],[gamx,gamy],eta,[smux,cmux,smuy,cmuy],R,IntType(1))
end


function normalMatrix(tin::EdwardsTengTwiss;separate=false)
	(tin.mode==IntType(1) || tin.mode==IntType(2)) || begin
		println(stderr,"Warning: return identity matrix for unknown mode $(tin.mode) as the normal matrix (transformation matrix from normal space to physical space).")
		return RealType(1)*Matrix{RealType}(I,6,6)
	end
	D=RealType[1 0 0 0 0 tin.eta[1]
			   0 1 0 0 0 tin.eta[2]
			   0 0 1 0 0 tin.eta[3]
			   0 0 0 1 0 tin.eta[4]
			   -tin.eta[2] tin.eta[1] -tin.eta[4] tin.eta[3] 1 0
			   0 0 0 0 0 1]
	sbx,sby=sqrt.(tin.beta)
	B=RealType[sbx 0 0 0 0 0
			   -tin.alpha[1]/sbx 1/sbx 0 0 0 0
			   0 0 sby 0 0 0
			   0 0 -tin.alpha[2]/sby 1/sby 0 0
			   0 0 0 0 1 0
			   0 0 0 0 0 1]
	λ=RealType(1)/sqrt(abs(RealType(1)+det(tin.R)))
	R=λ*tin.R
	_R=_symplectic_conjugate_2by2(R)
	O=RealType[0 0;0 0]
	U=RealType[λ 0;0 λ]
	if tin.mode==IntType(1)
		V=[U _R O;-R U O;O O I]
	else
		V=[_R U O;U -R O;O O I]
	end
	if separate
		return D,V,B
	else
		return D*V*B
	end
end

function transferMatrix(tw1::EdwardsTengTwiss,tw2::EdwardsTengTwiss)
	for tin in (tw1,tw2)
		(tin.mode==IntType(1) || tin.mode==IntType(2)) || begin
			println(stderr,"Warning: return identity matrix for unknown mode $(tin.mode) as the normal matrix (transformation matrix from normal space to physical space).")
			return RealType(1)*Matrix{RealType}(I,6,6)
		end
	end
	U1=normalMatrix(tw1)
	U2=normalMatrix(tw2)
	sx1,cx1,sy1,cy1=tw1.sc_mu
	sx2,cx2,sy2,cy2=tw2.sc_mu
	ssx=sx2*cx1-cx2*sx1
	ccx=cx2*cx1+sx2*sx1
	ssy=sy2*cy1-cy2*sy1
	ccy=cy2*cy1+sy2*sy1
	R=RealType[ccx ssx 0 0 0 0;-ssx ccx 0 0 0 0;0 0 ccy ssy 0 0;0 0 -ssy ccy 0 0;0 0 0 0 1 0;0 0 0 0 0 1]
	M=U2*R*inv(U1)
	return M
end


function transferMatrix(tw1::EdwardsTengTwiss,tw2::EdwardsTengTwiss,r56::RealType)
	M=transferMatrix(tw1,tw2)
	M[5,6]=r56
	return M
end
