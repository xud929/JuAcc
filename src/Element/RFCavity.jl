

abstract type AbstractRFCavity <: AbstractElement end 

mutable struct ThinRFCavity <: AbstractRFCavity
	Voltage::RealType
    Frequency::RealType
    Phase::RealType
    Krf::RealType
    Name::String
end

function ThinRFCavity(;Voltage::RealType,Frequency::RealType,Phase::RealType=0.0,Name::String="")
	Krf::RealType=2pi*Frequency/RealType(299792458)
	ThinRFCavity(Voltage,Frequency,Phase,Krf,Name)
end
