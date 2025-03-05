
abstract type AbstractPlaceholder <: AbstractDevice end 

mutable struct Placeholder <: AbstractPlaceholder
	L::RealType
	Name::String
end


Placeholder(;L::RealType,Name::String="")=Placeholder(L,Name)
