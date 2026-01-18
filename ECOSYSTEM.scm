;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath
;; ECOSYSTEM.scm - Ecosystem positioning for obli-ssg

(ecosystem
  (version "1.0.0")
  (name "obli-ssg")
  (type "ssg-engine")
  (purpose "Privacy-preserving static site generation using Oberon and oblivious computation principles")

  (position-in-ecosystem
    (role "satellite")
    (hub "poly-ssg-mcp")
    (domain "privacy-focused-ssg")
    (uniqueness "Only SSG designed around oblivious computation for build-time privacy"))

  (related-projects
    ((poly-ssg-mcp
       (relationship "hub")
       (description "Central MCP adapter hub for all poly-ssg engines"))
     (terrapin-ssg
       (relationship "sibling")
       (description "Educational Logo-based SSG"))
     (iota-ssg
       (relationship "sibling")
       (description "Array-oriented APL-based SSG"))
     (befunge-ssg
       (relationship "sibling")
       (description "2D esoteric Befunge-based SSG"))
     (pharos-ssg
       (relationship "sibling")
       (description "Live image Pharo Smalltalk SSG"))
     (qed-ssg
       (relationship "sibling")
       (description "Multi-SSG adapter hub in Lean 4"))
     (parallax-ssg
       (relationship "sibling")
       (description "Parallel-first Chapel SSG"))))

  (what-this-is
    ("Static site generator written in Oberon"
     "Oblivious computation for build-time privacy"
     "Pattern-hiding pipelines that minimize metadata leakage"
     "Integration with poly-ssg-mcp ecosystem"
     "Privacy-first approach to static site generation"))

  (what-this-is-not
    ("A general-purpose Oberon framework"
     "A replacement for encryption (complements it)"
     "A runtime privacy tool (build-time only)"
     "A CMS or dynamic site generator")))
