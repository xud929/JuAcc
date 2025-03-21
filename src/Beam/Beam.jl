
struct Beam <: AbstractBeam 
	E0::RealType
	m0::RealType
	γ0::RealType
	β0::RealType
	βγ0::RealType
	Bρ::RealType
	charge::RealType
end

Beam(;E0::RealType, m0::RealType, charge::RealType=1.0)=begin
	γ=E0/m0
	βγ=sqrt(γ*γ-1)
	β=βγ/γ
	Bρ=sqrt(E0^2-m0^2)*RealType(1e9)/RealType(299792458)
	Beam(E0,m0,γ,β,βγ,Bρ,charge)
end

const _beam=(Beam(E0=RealType(275.0),m0=RealType(0.93827208816)) |> Ref)

setDefaultBeam(;E0::RealType, m0::RealType,charge::RealType=1.0)=begin
	global _beam[]=Beam(;E0=E0,m0=m0,charge=charge)
	return
end

showDefaultBeam()=show(_beam[])

macro DefaultBeam() _beam[] end

