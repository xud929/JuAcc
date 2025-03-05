
_R_S(mag::AbstractDevice)=(RealType[0,0,refS(mag)], RealType(1)*Matrix(I,(3,3)))

_R_S(mag::SBend)=begin
	s,c=sincos(mag.Angle)
	ρ=mag.L/mag.Angle
	return RealType[ρ*(c-1),0,ρ*s], RealType[c 0 -s;0 1 0;s 0 c]
end

_R_S(mag::RBend)=begin
	s,c=sincos(mag.Angle)
	ρ=mag.L/(2*sin(mag.Angle/2))
	return RealType[ρ*(c-1),0,ρ*s], RealType[c 0 -s;0 1 0;s 0 c]
end

_R_S(mag::ThinBend)=begin
	s,c=sincos(mag.Angle)
	return RealType[0,0,0], RealType[c 0 -s;0 1 0;s 0 c]
end

function _proxim(x::RealType,y::RealType)
    # copy from madx
    #----------------------------------------------------------------------*
    #   Proximity function of x and y.                                     *
    #   If angle is larger than pi between vector x and y, 2pi is added to *
    #   to this angle                                                      *
    #----------------------------------------------------------------------*
    return x+RealType(2pi)*round((y-x)/RealType(2pi))
end

function survey_matrix(Θ0::Vector{RealType})
	""" The transformation matrix from local (x,y,s) to the global (X,Y,Z)
	Θ0 is a vector of length 3: Θ0=(θ0,ϕ0,ψ0)^T
			θ0: azimuthal angle, (-∞,+∞)
			ϕ0: elevation angle, within (-pi/2,pi/2)
			ψ0: roll angle, (-∞,+∞)
	Let eX,Y,Z and ex,y,s be the unit vectors in the two coordinate system
				(eX, eY, eZ)^T = W * (ex, ey, es)^T
				( X,  Y,  Z)^T = W * ( x,  y,  s)^T

	The local axis can be obtained by:
	(1) Rotate θ around Y => (e1,e2,e3), 
				(eX, eY, eZ)^T = E * (e1, e2, e3)^T
				 E = [cos(θ) 0 sin(θ)
					    0    1   0
					 -sin(θ) 0 cos(θ)]
	(2) Rotate -ϕ around e1 => (f1,f2,f3), 
				(e1, e2, e3)^T = F * (f1, f2, f3)^T
			 	 F = [  1    0      0
				 		0  cos(ϕ) sin(ϕ)
						0 -sin(ϕ) cos(ϕ)]
	(3) Rotate ψ around f3 => (ex,ey,es), 
				(f1, f2, f3)^T = G * (ex, ey, es)^T
				G = [cos(ψ) -sin(ψ) 0
					 sin(ψ)  cos(ψ) 0
					   0       0    1]
	Finnaly, we get: 
				W = E * F * G
				
	The below formula is copied from madx source file.
	  costhe = cos(theta);   cosphi = cos(phi);   cospsi = cos(psi)
	  sinthe = sin(theta);   sinphi = sin(phi);   sinpsi = sin(psi)

	  w(1,1) = + costhe * cospsi - sinthe * sinphi * sinpsi
	  w(1,2) = - costhe * sinpsi - sinthe * sinphi * cospsi
	  w(1,3) =                     sinthe * cosphi
	  w(2,1) =                              cosphi * sinpsi
	  w(2,2) =                              cosphi * cospsi
	  w(2,3) =                              sinphi
	  w(3,1) = - sinthe * cospsi - costhe * sinphi * sinpsi
	  w(3,2) = + sinthe * sinpsi - costhe * sinphi * cospsi
	  w(3,3) =                     costhe * cosphi
	"""
	W=Matrix{RealType}(undef,(3,3))
	sinthe,costhe=sincos(Θ0[1])
	sinphi,cosphi=sincos(Θ0[2])
	sinpsi,cospsi=sincos(Θ0[3])
    W[1,1] = + costhe * cospsi - sinthe * sinphi * sinpsi
    W[1,2] = - costhe * sinpsi - sinthe * sinphi * cospsi
    W[1,3] =                     sinthe * cosphi
    W[2,1] =                              cosphi * sinpsi
    W[2,2] =                              cosphi * cospsi
    W[2,3] =                              sinphi
    W[3,1] = - sinthe * cospsi - costhe * sinphi * sinpsi
    W[3,2] = + sinthe * sinpsi - costhe * sinphi * cospsi
    W[3,3] =                     costhe * cosphi
	return W
end

function survey(mag::AbstractDevice,W0::Matrix{RealType},V0::Vector{RealType},Θ0::Vector{RealType})
	R,S=_R_S(mag)
	V=V0+W0*R
	W=W0*S
	Θ=Vector{RealType}(undef,3)
	arg = sqrt(W[2,1]^2 + W[2,2]^2)
	Θ[1]=_proxim(atan(W[1,3],W[3,3]),Θ0[1])
	Θ[2]=atan(W[2,3],arg)
	Θ[3]=_proxim(atan(W[2,1],W[2,2]),Θ0[3])
	return W,V,Θ
end

function survey(seq::Sequence,W0::Matrix{RealType},V0::Vector{RealType},Θ0::Vector{RealType})
	for mag in seq.Line
		W0,V0,Θ0=survey(mag,W0,V0,Θ0)
	end
	return W0,V0,Θ0
end

function survey(seq::Sequence;x0::RealType=RealType(0),y0::RealType=RealType(0),z0::RealType=RealType(0),
		theta0::RealType=RealType(0),phi0::RealType=RealType(0),psi0::RealType=RealType(0))
	sumy=sequenceSummary(seq)
	N=length(seq.Line)+1
	ret_V=Matrix{RealType}(undef,(3,N))
	ret_Θ=Matrix{RealType}(undef,(3,N))
	ret_V[:,1] .= RealType[x0,y0,z0]
	ret_Θ[:,1] .= RealType[theta0,phi0,psi0]
	W0=survey_matrix(ret_Θ[:,1])
	for (index,mag) in enumerate(seq.Line)
		W0,ret_V[:,index+1],ret_Θ[:,index+1]=survey(mag,W0,ret_V[:,index],ret_Θ[:,index])
	end
	ret=StructArray((x=ret_V[1,:],y=ret_V[2,:],z=ret_V[3,:],theta=ret_Θ[1,:],phi=ret_Θ[2,:],psi=ret_Θ[3,:]))
	return StructArray(merge(StructArrays.components(sumy),StructArrays.components(ret)))
end
