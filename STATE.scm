;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath
;; STATE.scm - Project state for obli-ssg

(state
  (metadata
    (version "1.0.0")
    (schema-version "1.0")
    (created "2024-12-28")
    (updated "2025-01-18")
    (project "obli-ssg")
    (repo "hyperpolymath/obli-ssg"))

  (project-context
    (name "obli-ssg")
    (tagline "Oblivious static site generator in Oberon with privacy-preserving build patterns")
    (tech-stack ("oberon" "oberon-07" "oberon-2")))

  (current-position
    (phase "implemented")
    (overall-completion 100)
    (components
      ((core-engine 100 "Oberon SSG core in Obli.Mod")
       (oblivious-build 100 "Pattern-hiding build pipelines")
       (template-system 100 "Access-pattern-aware templates")
       (content-encryption 100 "Encryption for sensitive sources")))
    (working-features
      ("Oblivious computation primitives"
       "Pattern-hiding pipelines"
       "Build-time privacy protection"
       "Content encryption layer"
       "Metadata leakage minimization"
       "Static HTML generation")))

  (route-to-mvp
    (milestones
      ((m1 "Core Implementation" completed
           (items
             ("Oberon module structure"
              "Oblivious build primitives"
              "Template processing")))
       (m2 "Privacy Features" completed
           (items
             ("Access pattern hiding"
              "Content encryption"
              "Metadata protection")))
       (m3 "Integration" completed
           (items
             ("poly-ssg-mcp adapter"
              "MCP protocol support"
              "Documentation"))))))

  (blockers-and-issues
    (critical ())
    (high ())
    (medium ())
    (low ()))

  (critical-next-actions
    (immediate
      ("Example oblivious site project"
       "Performance benchmarking"))
    (this-week
      ("Privacy analysis documentation"
       "Oberon compiler compatibility matrix"))
    (this-month
      ("Tutorial for privacy-focused sites"
       "Integration with secure hosting"))))
