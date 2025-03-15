abstract type AbstractQuad <: AbstractDevice end 

mutable struct Quadrupole <: AbstractQuad
    L::RealType
    K1::RealType
    K1S::RealType
    Name::String
end

Quadrupole(;L::RealType=RealType(0),K1::RealType=RealType(0),K1S::Real=RealType(0),Name::String="")=Quadrupole(L,K1,K1S,Name)

mutable struct ThinQuad <: AbstractQuad
    K1L::RealType
    K1SL::RealType
    Name::String
end

ThinQuad(;K1L::RealType=RealType(0),K1SL::Real=RealType(0),Name::String="")=ThinQuad(K1L,K1SL,Name)

