
abstract type AbstractMultipole <: AbstractElement end 

mutable struct ThinMultipole <: AbstractMultipole
	KnL::Vector{RealType}
	KsL::Vector{RealType}
    Name::String
end

ThinMultipole(;KnL::Vector{RealType}=RealType[],KsL::Vector{RealType}=RealType[],Name::String="")=ThinMultipole(KnL,KsL,Name)
