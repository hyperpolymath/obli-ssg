;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath
;; META.scm - Meta-level information for obli-ssg

(define project-meta
  `((version . "1.0.0")

    (architecture-decisions
      ((adr-001
         (title . "Oberon as Implementation Language")
         (status . "accepted")
         (date . "2024-12-28")
         (context . "Need a language that supports disciplined, predictable execution for privacy-sensitive builds")
         (decision . "Use Oberon-07 for core engine implementation")
         (consequences . ("Strong typing prevents information leaks"
                          "Predictable memory access patterns"
                          "Module system enforces encapsulation"
                          "Limited ecosystem requires more self-contained code")))
       (adr-002
         (title . "Oblivious Computation Model")
         (status . "accepted")
         (date . "2024-12-28")
         (context . "Build-time access patterns can reveal site structure to observers")
         (decision . "Implement pattern-hiding primitives for all file operations")
         (consequences . ("Build time may increase due to padding operations"
                          "Memory usage higher to hide access patterns"
                          "Observers cannot infer content from build behavior")))
       (adr-003
         (title . "Dual Protection Layers")
         (status . "accepted")
         (date . "2024-12-28")
         (context . "Privacy requires both content protection and access pattern protection")
         (decision . "Combine encryption with oblivious access for defense in depth")
         (consequences . ("Content encrypted at rest"
                          "Access patterns hidden during build"
                          "Complexity increases but security improves")))))

    (development-practices
      ((code-style . "oberon-standard")
       (security . "openssf-scorecard")
       (testing . "module-unit-tests")
       (versioning . "semver")
       (documentation . "asciidoc")
       (branching . "trunk-based")))

    (design-rationale
      ((why-oberon . "Oberon's discipline and predictability align with privacy requirements")
       (why-oblivious . "Traditional SSGs leak structure through build behavior")
       (why-not-rust . "Oberon's simplicity reduces attack surface for privacy-critical code")))))
