for magType in [:Drift,:Quadrupole,:ThinQuad,:SBend,:RBend,:Solenoid,:ThinCrabCavity,:Marker,:LorentzBoost,:RevLorentzBoost,:DipEdge,:DipBody,:ThinKicker,:ThinRFCavity,:ThinBend,:Kicker,:HKicker,:VKicker,:Monitor,:HMonitor,:VMonitor,:Instrument,:Placeholder,:ThinMultipole,:Sequence]
	eval(quote
		 getType(::$(magType))=$(string(magType))
	end)
end
