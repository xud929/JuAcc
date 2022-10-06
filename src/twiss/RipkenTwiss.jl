# Implemented following the reference:
# 	Betatron motion with coupling of horizontal and vertical degrees of freedom
# 	V. A. Lebedev (Fermilab), S. A. Bogacz (Jefferson Lab)
# 	https://arxiv.org/abs/1207.5526

 
struct RipkenTwiss
	beta::SMatrix{2,2,RealType}
	alpha::SMatrix{2,2,RealType}
	eta::SVector{4,RealType}
	sc_mu::SVector{4,RealType} # sin(mu1) cos(mu1) sin(mu2) cos(mu2)
	sc_nu::SVector{4,RealType} # sin(nu1) cos(nu1) sin(nu2) cos(nu2)
	u::RealType
end

#RipkenTwiss(twi::DecoupledTwiss)=RipkenTwiss(RealType[twi.betx 0;0 twi.bety],RealType[twi.alfx 0;0 twi.alfy],RealType[twi.dx;twi.dpx;twi.dy;twi.dpy],
											 #RealType[twi.smux;twi.cmux;twi.smuy;twi.cmuy],RealType[0;1;0;1],RealType(0))
#RipkenTwiss(twi::EdwardsTengTwiss)=RipkenTwiss(RealType[twi.beta[1] 0;0 twi.beta[1]],RealType[twi.alpha[1] 0;0 twi.alpha[2]],twi.eta,
											 #twi.sc_mu,RealType[0;1;0;1],RealType(0))

function RipkenTwiss(t::EdwardsTengTwiss)
	R=t.R
	if t.mode == IntType(1)
		cc=RealType(1)/(RealType(1)+det(R))
		u=RealType(1)-cc
		a11,a22=t.alpha * cc
		b11,b22=t.beta * cc
		b12=t.gamma[1]*(R[1,2])^2-2*(t.alpha[1])*R[1,1]*R[1,2]+t.beta[1]*(R[1,1])^2
		b12*=cc
		b21=t.gamma[2]*(R[1,2])^2-2*(t.alpha[2])*R[1,2]*R[2,2]+t.beta[2]*(R[2,2])^2
		b21*=cc
		_x=R[1,1]*R[2,2]+R[1,2]*R[2,1]
		a12=-t.gamma[1]*R[1,2]*R[2,2]+t.alpha[1]*_x-t.beta[1]*R[1,1]*R[2,1]
		a12*=cc
		a21=t.gamma[2]*R[1,1]*R[1,2]+t.alpha[2]*_x+t.beta[2]*R[2,1]*R[2,2]
		a21*=cc

		_x1=t.alpha[1]*R[1,2]-t.beta[1]*R[1,1]
		_x2=R[1,2]
		_xx=sqrt(_x1*_x1+_x2*_x2)
		if _xx==RealType(0)
			cnu1=RealType(1)
			snu1=RealType(0)
		else
			cnu1=_x1/_xx
			snu1=_x2/_xx
		end

		_y1=t.alpha[2]*R[1,2]+t.beta[2]*R[2,2]
		_y2=R[1,2]
		_yy=sqrt(_y1*_y1+_y2*_y2)
		if _yy==RealType(0)
			cnu2=RealType(1)
			snu2=RealType(0)
		else
			cnu2=_y1/_yy
			snu2=_y2/_yy
		end
		return RipkenTwiss([b11 b12;b21 b22],[a11 a12;a21 a22],t.eta,t.sc_mu,[snu1,cnu1,snu2,cnu2],u)
	elseif t.mode == IntType(2)
	else
	end
end



twissTransform(tin::RipkenTwiss)=begin
	b11,b21,b12,b22=sqrt.(tin.beta)
	a11,a21,a12,a22=tin.alpha
	s1,c1,s2,c2=tin.sc_nu
	u=tin.u

	m23=(u*s2-a21*c2)
	m24=(u*c2+a21*s2)
	m23!=RealType(0) && (m23/=b21)
	m24!=RealType(0) && (m24/=b21)

	m41=(u*s1-a12*c1)
	m42=(u*c1+a12*s1)
	m41!=(RealType(0)) && (m41/=b12)
	m42!=(RealType(0)) && (m42/=b12)

	RealType[b11 0 b21*c2 -b21*s2
			 -a11/b11 (1-u)/b11 m23 m24
			 b12*c1 -b12*s1 b22 0
			 m41 m42 -a22/b22 (1-u)/b22]
end


function twissPropagate(tin::RipkenTwiss, M::Matrix{RealType})
	N=(@view M[1:4,1:4])*twissTransform(tin)

	b11=N[1,1]^2+N[1,2]^2
	b22=N[3,3]^2+N[3,4]^2
	b21=N[1,3]^2+N[1,4]^2
	b12=N[3,1]^2+N[3,2]^2

	sb11=sqrt(b11)
	sb12=sqrt(b12)
	sb21=sqrt(b21)
	sb22=sqrt(b22)

	c_dmu1=N[1,1]/sb11
	s_dmu1=N[1,2]/sb11
	a11=-(N[2,1]*c_dmu1+N[2,2]*s_dmu1)*sb11
	u=1+(N[2,1]*s_dmu1-N[2,2]*c_dmu1)*sb11

	c_dmu2=N[3,3]/sb22
	s_dmu2=N[3,4]/sb22
	a22=-(N[4,3]*c_dmu2+N[4,4]*s_dmu2)*sb22

	if b12==RealType(0)
		a12=RealType(0)
		u=RealType(0)
		c1=RealType(1)
		s1=RealType(0)
	else
		c1=(N[3,1]*c_dmu1+N[3,2]*s_dmu1)/sb12
		s1=(N[3,1]*s_dmu1-N[3,2]*c_dmu1)/sb12
		a12=(-N[4,1]*s_dmu1+N[4,2]*c_dmu1)*s1-(N[4,1]*c_dmu1+N[4,2]*s_dmu1)*c1
		a12*=sb12
	end

	if b21==RealType(0)
		a21=RealType(0)
		u=RealType(0)
		c2=RealType(1)
		s2=RealType(0)
	else
		c2=(N[1,3]*c_dmu2+N[1,4]*s_dmu2)/sb21
		s2=(N[1,3]*s_dmu2-N[1,4]*c_dmu2)/sb21
		a21=(-N[2,3]*s_dmu2+N[2,4]*c_dmu2)*s2-(N[2,3]*c_dmu2+N[2,4]*s_dmu2)*c2
		a21*=sb21
	end

	smu2=s_dmu2*tin.sc_mu[4]+c_dmu2*tin.sc_mu[3]
	cmu2=c_dmu2*tin.sc_mu[4]-s_dmu2*tin.sc_mu[3]
	smu1=s_dmu1*tin.sc_mu[2]+c_dmu1*tin.sc_mu[1]
	cmu1=c_dmu1*tin.sc_mu[2]-s_dmu1*tin.sc_mu[1]

	eta=N*tin.eta+(@view M[1:4,6])

	return RipkenTwiss([b11 b12;b21 b22],[a11 a12;a21 a22],eta,[smu1,cmu1,smu2,cmu2],[s1,c1,s2,c2],u)
end
