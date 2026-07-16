# 范铸 Codex + Figma 执行规范

## 设计声明与执行契约

- `DESIGN_PRINCIPLES.md` 定义通用设计判断。
- Reference Brief 合并 Intent Brief 与 Design Direction。
- Registry、Binding Policy、Variables、Styles、Recipes 和 Templates 共同构成 Asset Contract。
- Skills、validators 与 audits 是 Execution Contracts；它们调度和检查声明，不重新发明标准。

固定 Design I/O：`Intent → Information Architecture → Design Direction → Coverage → Mold Making or Casting → Evidence → Review → Directed Return`。

## 工具职责

- metadata / screenshot：理解结构与视觉真值。
- library search：确认 linked 与 remote assets；不能只看 local API。
- `figma-use`：确定性读写、binding、Component API、Instance 与 Audit。
- `figma-generate-library`：仅用于制范。
- `figma-generate-design`：仅用于浇铸。
- Slides 文件额外加载 Slides skill。

## Main Component / Instance 边界

- Main Component 只在 Project Profile 指定的 Library source 中创建或修改。
- Production target 只 import/instantiate Approved components。
- 内容变化只使用 properties、variants、Instance Swap 或 slots。
- 禁止 detach；无法覆盖即 Component API Gap。
- 普通 Frame 只可作 Manifest 允许的页面容器或一次性内容几何。

## 制范固定顺序

```text
Project Profile → Accepted Reference Brief → Coverage Report / Mold Gap → Preflight Inventory → Registry Draft or Amendment Candidate → One Component Family
→ Machine Gates → InReview → Evidence → Human Visual Gate
→ Approved + Publish，或 ChangesRequested → bounded revision → resubmit
```

Codex 可以自动提交 `InReview`，不能自动决定 `Approved` 或 `ChangesRequested`。

多个独立 family 可以并行到 `InReview`；每个 candidate 的人工 verdict、Visual Review Record 与发布决定必须独立。Amendment 只验证 delta 和受影响回归面，不将 base revision 退回 `Draft`。

## 浇铸固定顺序

```text
Project Profile → Validated + Accepted Reference Brief → Coverage Report → Content Plan → Build Manifest
→ Manifest Preflight → Library Readiness → Approved Instances → Audit
→ Screenshots → Human Page Review → Theme / Output
```

每次写操作返回 mutated node IDs。第一项通过后才批量同类对象。

Coverage route 只允许四类：`cast`、`mold_making`、`owner_unblock`、`content_replan`。Mold Gap 仅用于设计资产/API缺口；Gap Report 仅用于权限、发布/订阅、字体等 owner 阻塞。

## Dark / Light

- 切换 Project Profile 定义的 semantic color mode 与批准的 effect/theme asset variant。
- 冻结结构、Auto Layout、文字层级、slots、x/y/width/height 与内容顺序。
- 若 Light 需要重新排版，返回制范或内容规划，不在生产实例上补丁式修正。

## 写前与写后校验

- 定调后：`validate-reference-brief.rb` 检查目的、信息结构、设计方向和 handoff；Production 要求 `--require-accepted`。
- 写前：Manifest 必须通过 Registry status/key、required bindings、content budget、allowed literals 与 readiness 检查。
- 写后：Audit 检查实际 nodes 的 instance provenance、bindings、literal、Auto Layout、absolute exceptions 与 Dark/Light geometry。
- 两者不可互相替代；任一失败都停止当前对象。

## Review Finding

Review 面对真实截图、结构、内容与数据证据，而不是 Agent 对自身意图的描述。先按 page type 选择评审重点，再记录 `evidence`、`blocking`、`owner_interface`、`return_step` 和 `required_change`，并运行 `validate-review-record.rb`。阻断问题优先于整体评价；Visual verdict 仍由人决定。

## Project Profile 约束

所有 Figma file keys、variables、recipes、fonts、registry 与 readiness 均从选定 Profile 读取。核心 skill 不得硬编码任何品牌值。
