---
name: fanzhu-library
description: "Build or update governed Figma molds: Variables, Styles, Visual Recipe Components, Template Components, variants, properties and slots. Use for Mold Making, design-system foundations, component families, materials, themes, tokens, templates and library audits; do not use for assembling production pages."
---

# 范铸 · 制范

把新视觉意图建设为可复用的 Figma 范。每次只处理一个 Component Family；机器可以提交审核，但不能批准视觉。

## Load prerequisites

Before any Figma action, load and follow `figma-use` and `figma-generate-library`. Read:

- `<repository-root>/README.md`
- `<repository-root>/PIPELINE.md`
- the selected `projects/<project-id>/README.md`
- that profile's `interfaces/component-registry.yaml`
- that profile's `interfaces/binding-policy.yaml`
- that profile's `interfaces/readiness-gates.yaml`
- that profile's `VISUAL_RECIPES.md`
- `references/library-contract.md`

If no Project Profile is selected, stop before Figma mutation and request the profile id.

## Fixed workflow

1. **Confirm profile and target**: verify the profile's Library source and safe Pilot page. Never edit a production page while using this skill.
2. **Preflight**: inspect local Variables/Styles/Components, then linked and remote libraries. Run `scripts/preflight-inventory.js` through `use_figma`; local API absence is not proof of remote absence.
3. **Select one family**: create or update its Registry entry as `Draft`. Declare purpose, variants, properties, slots, Chinese budgets, dependencies, bindings, allowed literals, mode behavior and Code Ref.
4. **Search before build**: reuse profile foundations. Do not create synonymous tokens or duplicate Components.
5. **Build Main Component**: use Auto Layout and semantic bindings. Multi-layer glass/chrome/noise/gradient geometry belongs in a Recipe Component, not page frames.
6. **Expose API**: add only the text, boolean, variant and instance-swap properties required by casting. A deep slot that cannot be overridden is a Component API Gap.
7. **Validate**: create a real Chinese test Instance; audit bindings, properties, variants, Auto Layout and Dark/Light geometry; capture local and full screenshots.
8. **Submit Visual Gate**: after machine gates and evidence pass, Codex may move `Draft` or `ChangesRequested` to `InReview`. Stop for human verdict. Record explicit pass as `Approved`; record explicit rejection as Visual Review Record + `ChangesRequested`. Never infer a verdict.
9. **Publish**: casting requires accessible Library assets. If publication/subscription proof is unavailable, report a blocking dependency instead of copying components into production.

## Enforcement

- Variables: semantic colors and bindable numbers.
- Styles: complete typography and shadow/blur/paint combinations.
- Components: multi-layer materials, gradient geometry and reusable layout APIs.
- Allowed literals require exact Registry field, value and reason.
- Never detach, silently replace a font, auto-approve, or delete a Deprecated mold with active consumers.
- Keep Code Connect disabled until the selected Profile has a real product codebase and Storybook.

## Output

Return profile id, inventory summary, Registry changes, mutated node IDs, binding findings, screenshots, unresolved Mold Gaps and requested human decision. Do not continue into casting.
