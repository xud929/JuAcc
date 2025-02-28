module JuAcc

import Unicode
using LinearAlgebra,StructArrays,StaticArrays,Printf,PyCall

export @Drift,@Quadrupole,@ThinQuad,@RBend,@SBend,@Solenoid,@Marker,@LorentzBoost,@RevLorentzBoost,@ThinCrabCavity,@Sequence,@DipEdge,@DipBody,@ThinKicker,@ThinRFCavity,@ThinBend,@Kicker,@HKicker,@VKicker,@Monitor,@HMonitor,@VMonitor,@Instrument,@Placeholder,@ThinMultipole
export Drift,Quadrupole,ThinQuad,RBend,SBend,DipEdge,DipBody,Solenoid,Marker,LorentzBoost,RevLorentzBoost,ThinCrabCavity,Sequence,ThinKicker,ThinRFCavity,ThinBend,Kicker,HKicker,VKicker,Monitor,HMonitor,VMonitor,Instrument,Placeholder,ThinMultipole
export AbstractDrift,AbstractQuad,AbstractBend,AbstractSolenoid,AbstractMarker,AbstractBoost,AbstractCrabCavity,AbstractSequence,AbstractKicker,AbstractMonitor,AbstractInstrument,AbstractPlaceholder,AbstractMultipole
export showDefaultBeam,setDefaultBeam,Beam,@DefaultBeam,@Beam
export transferMatrix,transferMatrixAll
export RipkenTwiss,EdwardsTengTwiss,periodicEdwardsTengTwiss,twissPropagate,normalMatrix
export getIndexByName,getIndexByClass,getIndexByRegex,refS,refSAll,makeThin

export plot,WriteSequenceToJuliaStream,WriteSequenceToFileInMadX,ReadSequenceFromTFS

const RealType = Float64
const IntType = Int64

include("Element/main.jl")
include("Beam/main.jl")
include("Sequence/main.jl")

include("transferMatrix/main.jl")
include("twiss/main.jl")
include("Utility/main.jl")

end # module JuAcc
