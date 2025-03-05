
abstract type AbstractBoost <: AbstractTransformation end

mutable struct LorentzBoost <: AbstractBoost
	θc::RealType
	θs::RealType
	Name::String
end

LorentzBoost(;θc::RealType,θs::RealType=RealType(0),Name::String="")=LorentzBoost(θc,θs,Name)


mutable struct RevLorentzBoost <: AbstractBoost
	θc::RealType
	θs::RealType
	Name::String
end

RevLorentzBoost(;θc::RealType,θs::RealType=RealType(0),Name::String="")=RevLorentzBoost(θc,θs,Name)
