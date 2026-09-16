# =============================================================================
# ILLUSTRATIVE EXAMPLE ONLY -- device geometry, doping and material values
# below are generic placeholders. This is NOT a deck used to produce any
# figure or result in this repository or the associated manuscript. It is
# provided only to show the general shape of a Sentaurus Structure Editor
# (SDE) command file for readers unfamiliar with the TCAD workflow.
#
# The associated research is under submission/review at a peer-reviewed
# journal. The actual simulation decks, calibrated device parameters, and
# raw data are unpublished intellectual property of the author and cannot
# be made public until the manuscript is published.
# =============================================================================

(sde:clear)

; ---- generic bulk geometry (placeholder dimensions, not the study device) ----
(sdegeo:create-cuboid 0 0 0  100 100 50  "Silicon" "R.Body")
(sdegeo:create-cuboid 0 0 50 100 100 55  "SiO2"    "R.Gate_Ox")
(sdegeo:create-cuboid 0 0 55 100 100 65  "TiN"     "R.Gate_Metal")

; ---- generic doping profile (placeholder, not calibrated to any device) ----
(sdedr:define-constant-profile "Chan.Profile" "BoronActiveConcentration" 1e17)
(sdedr:define-constant-profile-region "Chan.Placement" "Chan.Profile" "R.Body")

(sdedr:define-gaussian-profile "Source.Profile" "ArsenicActiveConcentration" \
  "PeakPos" 0 "PeakVal" 1e20 "ValueAtDepth" 1e17 "Depth" 20 \
  "Gauss" "Factor" 0.8)

; ---- generic contacts ----
(sdegeo:define-contact-set "source" 4  (color:rgb 1 0 0 ) "##")
(sdegeo:define-contact-set "drain"  4  (color:rgb 0 1 0 ) "##")
(sdegeo:define-contact-set "gate"   4  (color:rgb 0 0 1 ) "##")

; ---- generic mesh (placeholder refinement, not the production mesh) ----
(sdedr:define-refinement-window "RefWin.Channel" "Cuboid" (position 0 0 45) (position 100 100 55))
(sdedr:define-refinement-size "RefDef.Channel" 5 5 1 2 2 0.5)
(sdedr:define-refinement-placement "RefPlace.Channel" "RefDef.Channel" "RefWin.Channel")

(sde:build-mesh "snmesh" "-a -c boxmethod" "n_example_msh")

# =============================================================================
# End of illustrative example.
# =============================================================================
