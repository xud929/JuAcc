abstract type AbstractMarker <: AbstractElement end

mutable struct Marker <: AbstractMarker
	Name::String
end

Marker(;Name::String="")=Marker(Name)
