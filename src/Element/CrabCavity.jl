

abstract type AbstractCrabCavity <: AbstractDevice end 

mutable struct ThinCrabCavity <: AbstractCrabCavity
	Strength::Tuple{RealType,RealType}
    Frequency::RealType
    Phase::RealType
    Kcc::RealType
    Name::String
end

function ThinCrabCavity(;Strength::Tuple{RealType,RealType},Frequency::RealType,Phase::RealType=0.0,Name::String="")
	Kcc::Float64=2pi*Frequency/RealType(299792458)
	ThinCrabCavity(Strength,Frequency,Phase,Kcc,Name)
end
