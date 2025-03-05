
abstract type AbstractElement end
abstract type AbstractDevice <: AbstractElement end # elements with real entities
abstract type AbstractTransformation <: AbstractElement end # virtual elements
abstract type AbstractSequence <: AbstractElement end # element collection

# Drift is often treated as a standard beamline component in accelerator physics, so it fits naturally under AbstractDevice rather than AbstractTransformation

include("Drift.jl")
include("Instrument.jl")
include("Placeholder.jl")
include("Monitor.jl")
include("Quadrupole.jl")
include("Multipole.jl")
include("Bend.jl")
include("CrabCavity.jl")
include("Marker.jl")
include("Boost.jl")
include("Solenoid.jl")
include("Kicker.jl")
include("RFCavity.jl")
include("Sequence.jl")
