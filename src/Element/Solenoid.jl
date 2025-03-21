
abstract type AbstractSolenoid <: AbstractDevice end

mutable struct Solenoid <: AbstractSolenoid
    L::RealType
    KS::RealType
    Name::String
end

Solenoid(;L::RealType=RealType(0),KS::RealType=RealType(0),Name::String="")=Solenoid(L,KS,Name)
