
abstract type AbstractKicker <: AbstractDevice end 

mutable struct ThinKicker <: AbstractKicker
	HKick::RealType
	VKick::RealType
	Name::String
end

ThinKicker(;HKick::RealType=RealType(0),VKick::RealType=RealType(0),Name::String="")=ThinKicker(HKick,VKick,Name)

mutable struct Kicker <: AbstractKicker
	L::RealType
	HKick::RealType
	VKick::RealType
	Name::String
end

Kicker(;L::RealType=RealType(0),HKick::RealType=RealType(0),VKick::RealType=RealType(0),Name::String="")=Kicker(L,HKick,VKick,Name)

mutable struct HKicker <: AbstractKicker
	L::RealType
	Kick::RealType
	Name::String
end

HKicker(;L::RealType=RealType(0),Kick::RealType=RealType(0),Name::String="")=HKicker(L,Kick,Name)

mutable struct VKicker <: AbstractKicker
	L::RealType
	Kick::RealType
	Name::String
end

VKicker(;L::RealType=RealType(0),Kick::RealType=RealType(0),Name::String="")=VKicker(L,Kick,Name)
