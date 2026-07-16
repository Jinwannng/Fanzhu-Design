---
name: fanzhu-art-direction
description: "Turn a content SSOT and one or more visual references into a validated Fanzhu Reference Brief covering intent, information architecture, trust, art direction and downstream design grammar. Use before Coverage, Mold Making, or Casting when defining purpose, page types, content hierarchy, visual craft, typography, material responsibility or a signature move; do not mutate Figma or invent production components."
---

# 范铸 · 定调

把内容真值与风格参考转成可执行的 Reference Brief。先定义目的与信息，再定义视觉；制范把方向资产化，浇铸只复用已批准的范。

## Load prerequisites

Read repository-root `DESIGN_PRINCIPLES.md` and `interfaces/reference-brief.example.yaml`. If a Project Profile is selected, also read its README and relevant domain/design declarations. Do not load Figma mutation skills during Art Direction.

## Authority order

Resolve conflicts in this order:

1. content SSOT and factual accuracy;
2. explicit user intent and output constraints;
3. selected Project Profile and Approved design system;
4. visual reference;
5. Codex taste.

Never let a reference distort content or let a familiar AI aesthetic replace the brief.

## Fixed workflow

1. **Define intent**: state the subject, audience, output type, single job, content thesis, facts to preserve, sources/unknowns and non-goals. Use real content, not placeholder copy.
2. **Map information architecture**: identify the primary relationship—sequence, comparison, claim-to-evidence, taxonomy, status or cause-and-effect—then define hierarchy, reading order and required page types. Do not invent a relationship the content does not contain.
3. **Protect trust and boundaries**: keep source, time window, uncertainty and missing-data behavior explicit. For product UI, include Empty, Loading, Error, Permission, Timeout and Recovery where relevant.
4. **Read the reference as evidence**: extract material, light, palette roles, typography character, grid, density, hierarchy, image treatment, edge language and state cues. Separate transferable principles from incidental pixels. Do not copy a screenshot, DOM or CSS implementation.
5. **Form the visual thesis**: write one sentence describing how the design should feel and why that expression belongs to this subject and task.
6. **Assign craft responsibilities**: define semantic color roles, type roles, spatial density, data/image treatment, material responsibilities and Dark/Light behavior. Reference samples are evidence, not production tokens.
7. **Choose one signature**: propose at most one memorable move tied to the subject. Keep the rest disciplined; the signature may be typographic, spatial or structural rather than decorative.
8. **Run the anti-default critique**: ask whether the same direction could fit an unrelated project. Replace generic AI defaults, filler copy, arbitrary numbering, repeated card grids and effects without responsibility. Remove one unnecessary flourish.
9. **Write and validate the brief**: write one confident direction unless alternatives were requested. Run `ruby scripts/validate-reference-brief.rb <brief>`. Submit `Draft` for human acceptance; never mark `Accepted` without an explicit human verdict.

## Reference Brief contract

Return only the information downstream work needs:

- **Intent Brief**: subject, audience, output, single job, thesis, facts, unknowns and non-goals.
- **Information architecture**: primary relationship, hierarchy, page types and data/content rules.
- **Design Direction**: visual thesis, reference reading, semantic palette and type roles, density, material responsibilities, Signature, restraint, theme and motion behavior.
- **Handoff**: visual grammar, layout grammar, component semantics, content rules and open decisions for Coverage.
- **Approval**: `Draft`, `Accepted` or `ChangesRequested` plus explicit human owner/evidence.

## Guardrails

- Do not force a visual risk when the reference calls for precision or restraint.
- Do not prescribe raw hex, spacing, radius, or effects as production values; map approved direction to Variables, Styles, and Recipe Components during Mold Making.
- Do not treat warm cream + serif, black + acid accent, editorial hairlines, glassmorphism, gradients, glow, or card grids as distinctive by themselves.
- Do not use motion language for static Deck/Poster output. For Slides or interactive UI, specify one purposeful motion moment at most unless the brief requires more.
- Do not change the content SSOT to make the layout easier. Flag content conflicts for replanning.
- Do not use visual polish to hide weak intent, missing evidence, wrong information relationships or uncertain data.
- Visual quality remains a human decision. This skill may sharpen and critique a direction, never approve it.

## Handoff

After explicit human acceptance, run `ruby scripts/validate-reference-brief.rb <brief> --require-accepted`, then pass the Reference Brief to Coverage:

- complete Approved coverage → `fanzhu-production`;
- missing visual grammar, token, Recipe, Template, slot, or property → `fanzhu-library` through a Mold Gap;
- missing access, publication, subscription, or font → owner unblock through a Gap Report;
- content overflow → content replan.
