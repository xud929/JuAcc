
abstract type AbstractKicker <: AbstractElement end 

mutable struct ThinKicker <: AbstractKicker
	HKick::RealType
	VKick::RealType
	Name::String
end

ThinKicker(;HKick::RealType=RealType(0),VKick::RealType=RealType(0),Name::String="")=ThinKicker(HKick,VKick,Name)
