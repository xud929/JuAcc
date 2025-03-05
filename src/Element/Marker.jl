abstract type AbstractMarker <: AbstractDevice end

mutable struct Marker <: AbstractMarker
	Name::String
end

Marker(;Name::String="")=Marker(Name)
