function magnetDef(magtype::Symbol,name::Symbol,kwargs...)
    args=[esc(k) for k in kwargs]
    ex=:($(magtype)(;$(args...),Name=$(string(name))))
    Expr(:(=),esc(name),ex)
end

function magnetDefWithoutName(magtype::Symbol,name::Symbol,kwargs...)
    args=[esc(k) for k in kwargs]
    ex=:($(magtype)(;$(args...)))
    Expr(:(=),esc(name),ex)
end

macro Drift(name::Symbol,kwargs...) magnetDef(:Drift,name,kwargs...) end
macro Quadrupole(name::Symbol,kwargs...) magnetDef(:Quadrupole,name,kwargs...) end
macro ThinQuad(name::Symbol,kwargs...) magnetDef(:ThinQuad,name,kwargs...) end
macro RBend(name::Symbol,kwargs...) magnetDef(:RBend,name,kwargs...) end
macro DipEdge(name::Symbol,kwargs...) magnetDef(:DipEdge,name,kwargs...) end
macro DipBody(name::Symbol,kwargs...) magnetDef(:DipBody,name,kwargs...) end
macro SBend(name::Symbol,kwargs...) magnetDef(:SBend,name,kwargs...) end
macro Solenoid(name::Symbol,kwargs...) magnetDef(:Solenoid,name,kwargs...) end
macro Marker(name::Symbol,kwargs...) magnetDef(:Marker,name,kwargs...) end
macro ThinCrabCavity(name::Symbol,kwargs...) magnetDef(:ThinCrabCavity,name,kwargs...) end
macro LorentzBoost(name::Symbol,kwargs...) magnetDef(:LorentzBoost,name,kwargs...) end
macro RevLorentzBoost(name::Symbol,kwargs...) magnetDef(:RevLorentzBoost,name,kwargs...) end
macro Beam(name::Symbol,kwargs...) magnetDef(:Beam,name,kwargs...) end
macro Sequence(name::Symbol,kwargs...) magnetDefWithoutName(:Sequence,name,kwargs...) end
