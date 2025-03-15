module JuAcc

import Unicode
using LinearAlgebra,StructArrays,StaticArrays,Printf,PyCall

export @Drift,@Quadrupole,@ThinQuad,@RBend,@SBend,@Solenoid,@Marker,@LorentzBoost,@RevLorentzBoost,@ThinCrabCavity,@Sequence,@DipEdge,@DipBody,@ThinKicker,@ThinRFCavity,@ThinBend,@Kicker,@HKicker,@VKicker,@Monitor,@HMonitor,@VMonitor,@Instrument,@Placeholder,@ThinMultipole
export Drift,Quadrupole,ThinQuad,RBend,SBend,DipEdge,DipBody,Solenoid,Marker,LorentzBoost,RevLorentzBoost,ThinCrabCavity,Sequence,ThinKicker,ThinRFCavity,ThinBend,Kicker,HKicker,VKicker,Monitor,HMonitor,VMonitor,Instrument,Placeholder,ThinMultipole
export AbstractElement,AbstractDevice,AbstractSequence,AbstractTransformation
export AbstractDrift,AbstractQuad,AbstractBend,AbstractSolenoid,AbstractMarker,AbstractBoost,AbstractCrabCavity,AbstractSequence,AbstractKicker,AbstractMonitor,AbstractInstrument,AbstractPlaceholder,AbstractMultipole
export showDefaultBeam,setDefaultBeam,Beam,@DefaultBeam,@Beam
export transferMatrix,transferMatrixAll
export RipkenTwiss,EdwardsTengTwiss,periodicEdwardsTengTwiss,twissPropagate,normalMatrix
export getIndexByName,getIndexByClass,getIndexByRegex,refS,refSAll,makeThin,flatten,sequenceSummary

export plot,WriteSequenceToJuliaStream,WriteSequenceToFileInMadX,ReadSequenceFromTFS,survey
export RealType,IntType


const RealType = Float64
const IntType = Int64

include("Element/main.jl")
include("Beam/main.jl")

include("transferMatrix/main.jl")
include("twiss/main.jl")
include("Utility/main.jl")
include("survey/main.jl")

# include LatticeTranslator module and re-export the name of "translate", "MadXModel"  and "JuAccModel" within this module
include("translate/main.jl")
using .LatticeTranslator
export LatticeTranslator,JuAccModel,MadXModel,translate

end # module JuAcc
