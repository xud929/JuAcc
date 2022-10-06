

abstract type AbstractBend <: AbstractElement end 

mutable struct SBend <: AbstractBend
    L::RealType
    Angle::RealType
    K1::RealType
    E1::RealType
    E2::RealType
	FInt1::RealType
	FInt2::RealType
    Name::String
end

SBend(;L::RealType,Angle::RealType,K1::RealType=0.0,E1::RealType=0.0,E2::RealType=0.0,FInt1::RealType=0.0,FInt2::RealType=0.0,Name::String="")=SBend(L,Angle,K1,E1,E2,FInt1,FInt2,Name)

mutable struct RBend <: AbstractBend
    L::RealType
    Angle::RealType
    K1::RealType
    E1::RealType
    E2::RealType
	FInt1::RealType
	FInt2::RealType
    Name::String
end

RBend(;L::RealType,Angle::RealType,K1::RealType=0.0,E1::RealType=0.0,E2::RealType=0.0,FInt1::RealType=0.0,FInt2::RealType=0.0,Name::String="")=RBend(L,Angle,K1,E1,E2,FInt1,FInt2,Name)

mutable struct DipEdge <: AbstractBend
	H::RealType
	E1::RealType
	FInt::RealType
	Name::String
end

DipEdge(;H::RealType,E1::RealType,FInt::RealType=0.0,Name::String="")=DipEdge(H,E1,FInt,Name)

mutable struct DipBody <: AbstractBend
    L::RealType
    Angle::RealType
    K1::RealType
    Name::String
end

DipBody(;L::RealType,Angle::RealType,K1::RealType=0.0,Name::String="")=DipBody(L,Angle,K1,Name)
