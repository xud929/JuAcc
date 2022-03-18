
abstract type AbstractSolenoid <: AbstractElement end

mutable struct Solenoid <: AbstractSolenoid
    L::RealType
    KS::RealType
    Name::String
end

Solenoid(;L::RealType,KS::RealType,Name::String="")=Solenoid(L,KS,Name)
