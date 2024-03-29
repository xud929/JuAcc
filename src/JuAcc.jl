module JuAcc

import Unicode
using LinearAlgebra,StructArrays,StaticArrays

export @Drift,@Quadrupole,@ThinQuad,@RBend,@SBend,@Solenoid,@Marker,@LorentzBoost,@RevLorentzBoost,@ThinCrabCavity,@Sequence,@DipEdge,@DipBody,@ThinKicker
export Drift,Quadrupole,ThinQuad,RBend,SBend,DipEdge,DipBody,Solenoid,Marker,LorentzBoost,RevLorentzBoost,ThinCrabCavity,Sequence,ThinKicker
export AbstractDrift,AbstractQuad,AbstractBend,AbstractSolenoid,AbstractMarker,AbstractBoost,AbstractCrabCavity,AbstractSequence,AbstractKicker
export showDefaultBeam,setDefaultBeam,Beam,@DefaultBeam,@Beam
export transferMatrix,transferMatrixAll
export RipkenTwiss,EdwardsTengTwiss,periodicEdwardsTengTwiss,twissPropagate,normalMatrix
export getIndexByName,getIndexByClass,refS,refSAll,makeThin

const RealType = Float64
const IntType = Int64

include("Element/main.jl")
include("Beam/main.jl")
include("Sequence/main.jl")

include("transferMatrix/main.jl")
include("twiss/main.jl")
include("Utility/main.jl")

end # module JuAcc
