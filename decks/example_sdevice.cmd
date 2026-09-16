* =============================================================================
* ILLUSTRATIVE EXAMPLE ONLY -- physics, bias points and material parameters
* below are generic placeholders. This is NOT a deck used to produce any
* figure or result in this repository or the associated manuscript. It is
* provided only to show the general shape of a Sentaurus Device (sdevice)
* command file for readers unfamiliar with the TCAD workflow.
*
* The associated research is under submission/review at a peer-reviewed
* journal. The actual simulation decks, calibrated device parameters, and
* raw data are unpublished intellectual property of the author and cannot
* be made public until the manuscript is published.
* =============================================================================

Electrode {
  { Name="source" Voltage=0.0 }
  { Name="drain"  Voltage=0.0 }
  { Name="gate"   Voltage=0.0 WorkFunction=4.5 }
}

File {
  Grid    = "n_example_msh.tdr"
  Plot    = "n_example_des.tdr"
  Current = "n_example_des.plt"
  Output  = "n_example_des.log"
}

Physics {
  Temperature = 300
  Mobility ( DopingDep HighFieldSaturation Enormal )
  Recombination ( SRH Auger )
}

Plot {
  eDensity hDensity ElectrostaticPotential
  eCurrent hCurrent Potential
  LatticeTemperature
}

Math {
  Extrapolate
  Iterations = 20
  Notdamped  = 100
  RelErrControl
}

Solve {
  Coupled ( Iterations=100 ) { Poisson }
  Coupled { Poisson Electron Hole }

  Quasistationary (
    InitialStep=0.01 MaxStep=0.05 MinStep=1e-5
    Goal { Name="drain" Voltage=0.7 }
  ) { Coupled { Poisson Electron Hole } }

  Quasistationary (
    InitialStep=0.01 MaxStep=0.05 MinStep=1e-5
    Goal { Name="gate" Voltage=0.7 }
  ) { Coupled { Poisson Electron Hole } }
}

* =============================================================================
* End of illustrative example.
* =============================================================================
