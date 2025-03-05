
abstract type AbstractMonitor <: AbstractDevice end 

mutable struct Monitor <: AbstractMonitor
	L::RealType
	Name::String
end

Monitor(;L::RealType,Name::String="")=Monitor(L,Name)


mutable struct HMonitor <: AbstractMonitor
	L::RealType
	Name::String
end

HMonitor(;L::RealType,Name::String="")=HMonitor(L,Name)


mutable struct VMonitor <: AbstractMonitor
	L::RealType
	Name::String
end

VMonitor(;L::RealType,Name::String="")=VMonitor(L,Name)
