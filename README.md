# The Invariant Reliability Bottleneck in Multi-Tier CFETs

**Cooling Topology, Tier Asymmetry, and Buried-Isolation Design**

**Status:** Manuscript under review, IEEE JXCDC (Journal on Exploratory Solid-State Computational Devices and Circuits)
**Authors:** Tushar Dudeja, Nawaz Shafi, Vellore Institute of Technology (VIT)

## Abstract

As logic scaling transitions from planar and gate-all-around transistors to vertically stacked Complementary FETs (CFETs), each device tier in a multi-tier stack self-heats to a distinct temperature and ages under bias stress at a distinct rate, while following a distinct thermal path to the heat sink. This work uses coupled electro-thermal-reliability TCAD simulation of a 4-tier stacked CFET, calibrated against an independently published 15 nm scaled CFET device, to determine whether the reliability-limiting tier depends on heat-sink topology. Across a cooling-topology sweep spanning substrate-dominant to top-dominant heat extraction, the top tier is found to be hottest and to degrade fastest in every configuration tested: the identity of the bottleneck tier is invariant, while the magnitude of the inter-tier temperature spread compresses by 6.8 times under favorable cooling. A single self-consistent coupled simulation further shows the top-tier pFET and nFET degrading 4.8 to 6.3 times and 2.3 to 2.8 times faster than their bottom-tier counterparts under NBTI and PBTI stress respectively, with a tier-resolved degradation exponent that varies systematically with local temperature. These results establish that architecture, not cooling strategy, determines which tier limits multi-tier CFET reliability, providing a topology-independent design rule together with a quantified buried-dielectric-isolation lever for margin improvement.

---

## 1. The problem

Chipmakers are running out of room to shrink transistors sideways, so the next step is to stack them: **Complementary FETs (CFETs)** place an nFET directly on top of a pFET, and multiple such pairs can be stacked into a 4-tier (or taller) column. This roughly halves footprint, but it creates a reliability question nobody has answered with simulation before: **each tier self-heats to a different temperature and ages at a different rate, and each tier sits on a different thermal path to the heat sink. Does the tier that wears out first depend on how the chip is cooled?**

If the answer is "yes," designers need a cooling-topology-specific reliability model for every product. If the answer is "no," there's one design rule that holds everywhere, which is a much more useful thing to know.

## 2. Approach

We built a 4-tier stacked CFET in Synopsys Sentaurus TCAD, calibrated to an independently published 15 nm scaled CFET device (subthreshold swing within 1.5 mV/dec of the reference), and simulated it under a realistic range of cooling configurations, from substrate-dominant heat extraction to top-dominant heat extraction (sink ratio swept 0.02 to 50).

<p align="center">
  <img src="figures/device_structure.png" alt="4-tier CFET device structure" width="520">
  <br>
  <em>Fig. 1. The simulated 4-tier stacked CFET: alternating p/n tiers, gate stack, buried dielectric isolation (BDI), and contacts.</em>
</p>

Critically, the headline aging results don't come from stitching together separate isothermal runs (the conventional approach); they come from a **single self-consistent coupled electro-thermal-reliability simulation**, where all four tiers' mutual heating and their NBTI/PBTI degradation evolve together. This also captures a real physical feedback loop: as a tier degrades, it draws less current, which slightly lowers the whole stack's temperature.

## 3. What we found

**(a) The bottleneck tier never moves.** Across every cooling topology tested, the top tier runs hottest and degrades fastest; it never flips to a different tier, in any configuration. What cooling *does* control is the **size** of the gap: the temperature spread between the hottest and coolest tier compresses **6.8x** (from 71.3 K down to 10.6 K) as cooling shifts from substrate-dominant to top-dominant.

> **Architecture decides *which* tier limits reliability. Cooling topology decides *by how much*.**

**(b) Aging is tier-specific and large.** In the coupled simulation, the top-tier pFET degrades **4.8x to 6.3x** faster than the bottom-tier pFET under NBTI stress, and the top-tier nFET degrades **2.3x to 2.8x** faster than the bottom-tier nFET under PBTI stress (range reflects 100 s to 1000 s stress time).

**(c) The aging model itself is tier-resolved.** The power-law exponent that governs how damage accumulates over time isn't one fixed number; it decreases monotonically with tier temperature, at matched rates for both NBTI and PBTI (within 6% of each other). Three of four tiers land inside the 0.45 to 0.60 exponent window independently reported for this device family.

**(d) Buried dielectric isolation (BDI) is a real, bounded design lever.** Sweeping BDI thermal conductivity shifts the worst-tier temperature by up to ~5.9 K before saturating: small, but usable, and not negligible as earlier assumed.

<p align="center">
  <img src="figures/reliability_results.png" alt="Tier reliability results" width="640">
  <br>
  <em>Fig. 2. Per-tier temperature vs. cooling topology (never flips), NBTI lifetime map, and the BDI design-lever sweep.</em>
</p>

Every ratio above uses same-device-type comparisons (pFET-to-pFET, nFET-to-nFET) and was cross-validated against an independent literature dataset: top-tier and bottom-tier nFET temperatures agree with the reference within 0.2 to 1%.

### Results at a glance

| Metric | Value | Condition |
|---|---|---|
| Tier-asymmetry compression (substrate-dominant to top-dominant cooling) | **6.8x** (71.3 K to 10.6 K) | sink ratio swept 0.02 to 50 |
| Worst tier across all cooling topologies | Top tier, every case | 0/5 configurations flip |
| NBTI degradation ratio, top vs. bottom pFET | **4.8x to 6.3x** | 100 s to 1000 s stress, self-consistent |
| PBTI degradation ratio, top vs. bottom nFET | **2.3x to 2.8x** | 100 s to 1000 s stress, self-consistent |
| Degradation power-law exponent, tier range | 0.51 to 0.66 | vs. literature window 0.45 to 0.60 |
| BDI thermal-conductivity design lever | up to **5.9 K** worst-tier shift | bounded, saturates |
| Cross-validation vs. independent literature (top-tier nFET T) | agreement within **0.2%** | like-for-like check |

## 4. Why it matters

This gives chip designers a single, cooling-topology-independent rule: **fix the top tier's reliability margin, and every cooling strategy inherits the benefit**; there's no scenario where optimizing for one cooling topology backfires under another. It also gives a quantified, physically grounded lever (BDI conductivity) for trimming the worst case further, and a tier-resolved aging model that's more accurate than treating a stacked device as if every tier ages the same way.

## 5. Methodology notes (for the technically curious)

- **Tool:** Synopsys Sentaurus TCAD (sde / sdevice / svisual), CLI batch mode.
- Every number above was independently re-derived on a corrected simulation mesh and cross-checked against a control run that reproduces an earlier, since-superseded result. The defect that caused the earlier result, and the correction trail, are documented as part of the manuscript's methodology.
- [`decks/example_sde.cmd`](decks/example_sde.cmd) and [`decks/example_sdevice.cmd`](decks/example_sdevice.cmd) show the general shape of a Sentaurus deck. **All geometry, doping, and material values in these two files are generic placeholders**, not the decks used to produce any result here, and not the actual device design (see [License](#license)).

## 6. My role

I designed and ran the full TCAD simulation campaign (device build, thermal calibration, cooling-topology sweep, and self-consistent aging simulations), wrote the extraction and analysis pipeline, and identified and corrected a geometric meshing defect that had produced a spurious result in an earlier version of this work. The invariant-bottleneck finding above is the corrected, verified result.

**Skills demonstrated:** TCAD device simulation (Synopsys Sentaurus), semiconductor reliability physics (NBTI/PBTI, Arrhenius kinetics), coupled electro-thermal simulation, Python-based data extraction and analysis, scientific writing and peer review response.

## 7. Awards and recognition

- **Top 3 winner, 2026 IEEE EDS TCAD Hackathon** (IEEE Electron Devices Society), selected from over 500 registrations and about 60 submissions worldwide. [Announcement (LinkedIn)](https://lnkd.in/p/gbz3SE6b) · [Official confirmation](https://drive.google.com/file/d/1Ork0xYC8Jxg_C6i7O5Jz-Xi5lJ0y0SwD/view?usp=sharing)

## License

See [LICENSE](LICENSE). All rights reserved. This repository is shared for demonstration purposes only (e.g. scholarship/fellowship review) and may not be reproduced, redistributed, or reused without the author's written permission. The associated manuscript is under peer review; simulation decks, raw data, and manuscript text are not included.
