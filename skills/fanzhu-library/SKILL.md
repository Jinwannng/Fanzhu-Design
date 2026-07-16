---
name: fanzhu-library
description: "Build or update governed Figma molds: Variables, Styles, Visual Recipe Components, Template Components, variants, properties and slots. Use for Mold Making, design-system foundations, component families, materials, themes, tokens, templates and library audits; do not use for assembling production pages."
---

# 范铸 · 制范

把新视觉意图建设为可复用的 Figma 范。每次只处理一个 Component Family；机器可以提交审核，但不能批准视觉。

## Load prerequisites

Before any Figma action, load and follow `figma-use` and `figma-generate-library`. Read:

- repository-root `README.md`
- repository-root `PIPELINE.md`
- repository-root `DESIGN_PRINCIPLES.md`
- the selected `projects/<project-id>/README.md`
- the accepted Reference Brief and its Mold Gap
- that profile's `interfaces/component-registry.yaml`
- that profile's `interfaces/binding-policy.yaml`
- that profile's `interfaces/readiness-gates.yaml`
- that profile's `VISUAL_RECIPES.md`
- `references/library-contract.md`

If no Project Profile is selected, stop before Figma mutation and request the profile id.

## Fixed workflow

1. **Confirm profile and target**: verify the profile's Library source and safe Pilot page. Never edit a production page while using this skill.
2. **Preflight**: inspect local Variables/Styles/Components, then linked and remote libraries. Run `scripts/preflight-inventory.js` through `use_figma`; local API absence is not proof of remote absence.
3. **Select one family**: create a Registry `Draft`, or a linked Amendment candidate for a small change to an Approved family. Declare semantic role, correct use, forbidden misuse, composition boundary, supported states, variants, properties, slots, Chinese budgets, dependencies, bindings, allowed literals, mode behavior and Code Ref. An Amendment records base revision, delta scope and affected Gates; it never resets the base entry to `Draft`.
4. **Search before build**: reuse profile foundations. Do not create synonymous tokens or duplicate Components.
5. **Build Main Component**: use Auto Layout and semantic bindings. Make color, typography, space, geometry and material serve the responsibilities declared in the Reference Brief. Multi-layer glass/chrome/noise/gradient geometry belongs in a Recipe Component, not page frames.
6. **Expose API**: add only the text, boolean, variant and instance-swap properties required by casting. A deep slot that cannot be overridden is a Component API Gap.
7. **Validate**: create a real Chinese test Instance; audit semantic use, content boundaries, bindings, properties, variants, Auto Layout and Dark/Light geometry; capture local and full screenshots. Amendments validate their delta plus affected regression surface, not an unrelated full-family rebuild.
8. **Submit Visual Gate**: after machine gates and evidence pass, Codex may move `Draft` or `ChangesRequested` to `InReview`. Stop for human verdict. Record explicit pass as `Approved`; record explicit rejection as Visual Review Record + `ChangesRequested`. Every finding carries evidence, blocking state, owner interface, return step and required change; run `ruby scripts/validate-review-record.rb <review-record>` before applying the status transition. Never infer a verdict.
9. **Publish**: casting requires accessible Library assets. If publication/subscription proof is unavailable, report a blocking dependency instead of copying components into production.

## Enforcement

- Variables: semantic colors and bindable numbers.
- Styles: complete typography and shadow/blur/paint combinations.
- Components: multi-layer materials, gradient geometry and reusable layout APIs.
- Registry semantics: every mold declares what it means, when to use it, when not to use it and how it may compose.
- Allowed literals require exact Registry field, value and reason.
- Never detach, silently replace a font, auto-approve, or delete a Deprecated mold with active consumers.
- Keep Code Connect disabled until the selected Profile has a real product codebase and Storybook.
- One mutation run changes one family/candidate. Multiple independent families may progress in parallel to `InReview`; each requires an independent human verdict and Visual Review Record.

## Output

Return profile id, Reference Brief id, inventory summary, Registry changes, mutated node IDs, binding/semantic findings, screenshots, unresolved Mold Gaps and requested human decision. Do not continue into casting.
