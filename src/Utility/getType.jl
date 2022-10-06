for magType in [:Drift,:Quadrupole,:ThinQuad,:SBend,:RBend,:Solenoid,:ThinCrabCavity,:Marker,:LorentzBoost,:RevLorentzBoost,:DipEdge,:DipBody,:ThinKicker]
	eval(quote
		 getType(::$(magType))=$(string(magType))
	end)
end
