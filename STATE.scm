;;; STATE.scm — obli-ssg
;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

(define metadata
  '((version . "0.1.0") (updated . "2025-12-17") (project . "obli-ssg")))

(define current-position
  '((phase . "v0.1 - Initial Setup")
    (overall-completion . 35)
    (components
     ((rsr-compliance ((status . "complete") (completion . 100)))
      (security-docs ((status . "complete") (completion . 100)))
      (readme ((status . "complete") (completion . 100)))
      (adapters ((status . "complete") (completion . 100)))
      (testing ((status . "not-started") (completion . 0)))
      (ci-cd ((status . "partial") (completion . 50)))))))

(define blockers-and-issues '((critical ()) (high-priority ())))

(define critical-next-actions
  '((immediate
     (("Verify CI/CD pipelines work" . high)
      ("Add adapter unit tests" . high)))
    (this-week
     (("Create integration tests" . medium)
      ("Add TypeScript type definitions" . medium)))
    (this-month
     (("Publish to npm/deno.land" . low)
      ("Create example projects" . low)))))

;; Comprehensive Roadmap
(define roadmap
  '((v0.1 . "Initial Setup - CURRENT")
    (v0.1-status . "35% complete")
    (v0.1-tasks
     ((completed
       ("RSR compliance setup"
        "SCM files (STATE.scm, META.scm, ECOSYSTEM.scm)"
        "Security policy (SECURITY.md)"
        "Code of conduct (CODE_OF_CONDUCT.md)"
        "Contributing guidelines"
        "28 SSG adapters from poly-ssg-mcp hub"
        "CodeQL security scanning"
        "Dependabot configuration"
        "README documentation"))
      (remaining
       ("Verify CI/CD on main branch"
        "Add basic unit tests for adapters"))))

    (v0.2 . "Testing & Validation")
    (v0.2-tasks
     (("Unit tests for all 28 adapters"
       "Integration tests with actual SSG binaries"
       "CI matrix for multiple Deno versions"
       "Test coverage reporting (70% minimum)"
       "Adapter interface validation")))

    (v0.3 . "Type Safety & Documentation")
    (v0.3-tasks
     (("TypeScript type definitions (.d.ts)"
       "JSDoc documentation for all exports"
       "API documentation generation"
       "Usage examples for each adapter")))

    (v0.4 . "Distribution & Publishing")
    (v0.4-tasks
     (("Publish to deno.land/x"
       "Publish to npm (with Deno compatibility)"
       "Version tagging and releases"
       "Changelog automation")))

    (v0.5 . "MCP Integration")
    (v0.5-tasks
     (("Full MCP protocol compliance"
       "Integration with poly-ssg-mcp hub"
       "MCP server implementation"
       "MCP client example")))

    (v1.0 . "Production Ready")
    (v1.0-tasks
     (("Stable API"
       "Complete documentation"
       "Performance benchmarks"
       "Security audit"
       "RSR Gold certification")))))

(define session-history
  '((snapshots
     ((date . "2025-12-15") (session . "initial") (notes . "SCM files added"))
     ((date . "2025-12-17") (session . "security-review")
      (notes . "Fixed SCM template references, resolved SECURITY.md and CODE_OF_CONDUCT.md placeholders, created README.adoc, updated roadmap")))))

(define state-summary
  '((project . "obli-ssg")
    (completion . 35)
    (blockers . 0)
    (updated . "2025-12-17")
    (next-milestone . "v0.2 - Testing & Validation")))
