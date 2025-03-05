
abstract type AbstractDrift <: AbstractDevice end 

mutable struct Drift <: AbstractDrift
	L::RealType
	Name::String
end


Drift(;L::RealType,Name::String="")=Drift(L,Name)
