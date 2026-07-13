---
name: fanzhu-production
description: Route visual inspiration and assemble Deck, Dashboard, Poster and themed Figma pages from Approved Registry molds. Use for Reference Briefs, coverage checks, content slicing, manifests, instances, slot overrides, audits and Dark/Light production; do not invent or author design-system components.
---

# 范铸 · 浇铸

把已校对内容装入 Approved 范。固定循环是 Reference Brief → Coverage → Manifest → Dependencies → Instances → Audit → Screenshot。

## Load prerequisites

Before any Figma action, load and follow `figma-use` and `figma-generate-design`. For Figma Slides also load `figma-use-slides`. Read:

- repository-root `README.md`
- repository-root `WORKFLOW.md`
- the selected `projects/<project-id>/README.md`
- that profile's `interfaces/component-registry.yaml`
- that profile's `interfaces/binding-policy.yaml`
- that profile's `interfaces/readiness-gates.yaml`
- that profile's Manifest example
- `references/production-contract.md`

If no Project Profile is selected, stop before Figma mutation and request the profile id.

## Fixed workflow

1. **Reference Brief**: translate inspiration into material, light, hierarchy, state, composition, content type and target constraints. Do not copy DOM, random CSS or screenshot pixels.
2. **Coverage check**: map every required visual/layout grammar and content budget to Approved Registry entries. If any item is missing, write a Mold Gap and stop; do not switch into Mold Making inside the same run.
3. **Content plan**: one conclusion per page; apply Chinese title/body/data budgets. Overflow means revise, split or switch template—never shrink type to force a fit.
4. **Build Manifest**: target frame, size, mode, Approved template key/variant, Instances, slot content, variable/style keys and allowed literals.
5. **Manifest Preflight**: run `ruby scripts/validate-manifest.rb <manifest> <registry> <policy>` from the repository root. It must pass before any Figma mutation.
6. **Check readiness**: require the Profile's Library Distribution gate, then search local, linked and remote assets. Reject Draft, InReview, ChangesRequested and Deprecated entries.
7. **Assemble**: import and instantiate Approved components. Use variants, `setProperties`, Instance Swap and slots. Never detach. Ordinary Frames are limited to Manifest-declared page containers and one-off content geometry.
8. **Audit**: run `scripts/audit-bindings.js` against each target. Fix only reported nodes; do not rebuild the full page.
9. **Screenshot and theme**: inspect the first page of each template type locally and full-frame. Human review precedes batch production. Dark/Light switches mode and approved assets while geometry stays frozen.

## Three gates

- **Reuse**: reusable visual structures are Approved Instances.
- **Binding**: no unauthorized literals or detached/local copies; all exceptions are declared.
- **Visual**: human confirms hierarchy, material restraint, Chinese layout and Dark/Light geometry.

## Output

Return profile id, Reference Brief, coverage result, Manifest, dependency result, created Instance node IDs, audit issues, screenshots, gate state and Mold Gap if blocked. Never change a Registry status.

For a Deprecated mold, stop new production. Existing consumers migrate through its replacement and a Migration Manifest; keep the old instance until replacement, Audit and Screenshot pass.
