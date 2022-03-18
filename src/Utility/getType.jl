for magType in [:Drift,:Quadrupole,:ThinQuad,:SBend,:RBend,:Solenoid,:ThinCrabCavity,:Marker,:LorentzBoost,:RevLorentzBoost,:DipEdge,:DipBody]
	eval(quote
		 getType(::$(magType))=$(string(magType))
	end)
end
