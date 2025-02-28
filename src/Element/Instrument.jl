
abstract type AbstractInstrument <: AbstractElement end 

mutable struct Instrument <: AbstractInstrument
	L::RealType
	Name::String
end


Instrument(;L::RealType,Name::String="")=Instrument(L,Name)
