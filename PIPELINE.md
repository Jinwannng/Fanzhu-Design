# 范铸 Master Pipeline

## 目标

让 Codex 将内容与灵感快速、高质量地实现到 Figma，同时把“定义设计”“探索新视觉”和“稳定生产页面”分开。速度来自 Approved 范的复用；质量来自明确目的、真实信息结构、具有职责的视觉工艺、机器 Gate 和人工 Visual Gate。

## Design I/O

范铸使用三类 Design Declarations：Reference Brief 内的 Intent Brief 与 Design Direction，以及由 Registry、Binding Policy、Variables、Styles、Recipes 和 Templates 共同组成的 Asset Contract。Skills 与校验器是 Execution Contracts，不重新定义审美。

```text
Intent → Information Architecture → Design Direction → Coverage
→ Mold Making or Casting → Evidence → Review → Directed Return
```

约束从上游持续进入每一步。Review 失败必须携带证据并回到所属声明或执行步骤，不在整页上反复打补丁。

## 入口：灵感覆盖路由

先用 `fanzhu-art-direction` 把内容 SSOT 与 Pinterest、Stitch、截图、网页或代码参考转成 Reference Brief。它必须说明主题、受众、唯一任务、核心结论、事实与不确定项、信息关系、page types、视觉命题、字体/色彩角色、材质职责、唯一 Signature 与克制边界；参考只作为证据，不直接决定实现。

Reference Brief 先运行 `ruby scripts/validate-reference-brief.rb <brief>`；人工接受后再以 `--require-accepted` 复查，随后写入 Coverage Report：

- 视觉意图：光源、材质、边缘、层级、状态、构图。
- 内容意图：信息类型、核心结论、中文长度、数据形态。
- 生产约束：尺寸、比例、主题、目标文件、Project Profile。

Coverage Report 必须逐项检查 Approved Registry，并输出单一 `route`：

- `cast`：Recipe、Template、API、theme behavior 与 content budget 全部覆盖 → 进入循环 B · 浇铸。
- `mold_making`：缺视觉语法、结构、slot/property 或需要新增 semantic Variable/Style → 输出 Mold Gap，进入循环 A · 制范。
- `owner_unblock`：Library 发布/订阅、权限、字体或其他行政访问阻塞 → 输出 Gap Report，owner 解除后重新生成 Coverage Report。
- `content_replan`：内容超出现有模板容量 → 修改内容计划、拆页或换 Template 后重新生成 Coverage Report。

外部参考只提供意图，不直接进入 Registry。

## 循环 A：制范

**入口**：Mold Gap、Project Profile、现有 Figma Foundations 与 Reference Brief。

1. Preflight Inventory：检查 Variables、Modes、Styles、Components、linked/remote libraries、字体与命名冲突。
2. 选择一个 family：Primitive、Recipe 或 Template。**一次 Figma mutation run 只改一个 family**，但多个独立 family 可以并行建设到 `InReview`。
3. Foundations：复用或补齐 semantic Variables 与批准 Styles；色彩、字体、间距、材质和数据编码必须承担 Reference Brief 声明的职责。
4. Main Component：用 Auto Layout 和可复用内部结构构建唯一权威范；组件外观与语义角色同时成立。
5. Component API：声明正确用途、禁止误用、组合边界、variants、states、properties、slots、中文容量、required bindings、allowed literals 与 theme behavior。
6. Machine Gates：创建真实中文测试 Instance，验证 Reuse、Binding、API、Auto Layout、内容边界与 Dark/Light geometry。
7. 提交审核：证据齐全后，Codex 将 `Draft` / `ChangesRequested` 改为 `InReview`。
8. Human Visual Gate：人决定 `Approved` 或 `ChangesRequested`；Codex 不得推断 verdict。
9. Publish：Approved key 与 screenshot 写入 Registry，并发布/开放 Library。

出口：`Approved Mold Registry entry + accessible component key + approved screenshot`。

### Amendment 快速路径

已有 Approved family 的小修（例如新增 badge variant、暴露一个 slot、补一个 property）不重置原 entry。创建 linked Amendment candidate，记录 `base_revision`、`delta_scope`、受影响的 bindings 与 theme geometry；只为差异和受影响回归项生成证据。机器 Gate 与 Human Visual Gate 都必须通过，但人工 verdict 逐候选记录，不能用一次模糊的“都可以”代替。

## 并行与审核

Codex 可并行推进多个互不依赖的 family 至 `InReview`，前提是每个 mutation run、Registry entry、evidence 与 Amendment candidate 都独立。Human Visual Gate 是串行决策边界：可以在同一评审会话批量查看，但每个 family/candidate 必须有独立 verdict 与 Visual Review Record。

## 循环 B：浇铸

**入口**：已校对内容、目标尺寸/mode、通过覆盖检查的 Approved Registry。

1. Content Plan：每页一个核心结论；校对数字、术语与内容预算。
2. Build Manifest：声明 target、template key/variant、instances、slots、Variable/Style keys 与 allowed literals。
3. Manifest Preflight：在任何 Figma 写入前检查 Approved 状态、keys、bindings、内容预算与 literal allowlist。
4. Library Readiness：确认目标文件可搜索、导入 Approved key，且不会创建 local copy。
5. Assemble：只创建 Instances；通过 properties、variants、Instance Swap 与 slots 写内容，禁止 detach。
6. Binding Audit：定位 hardcode、local/detached copy、binding 失效、Auto Layout 与 absolute positioning 例外。
7. Screenshot + Page Review：检查局部与整页；按 page type 选择评审重点。每条问题记录 `evidence`、`blocking`、`owner_interface`、`return_step` 与 `required_change`；第一张代表页面通过后再批量同类页面。
8. Theme/Output：Dark/Light 只切 mode 或批准的 theme assets；冻结几何、层级和 slot order。

出口：`validated manifest + audited instances + approved page screenshots`。

## 强制回流

- 缺视觉语法、Component API、slot/property 或需要新增 Variable/Style → Mold Gap → 停止当前铸件 → 制范。
- Library 未发布/未订阅、无权限、字体缺失 → Gap Report → 停止当前对象 → owner 解除后重新 Coverage。
- 中文超出 slot budget → 换范、拆页或返回内容规划；禁止缩字硬塞。
- Manifest Preflight 失败 → 不写 Figma。
- Binding Audit 失败 → 只修定位节点，不自动重建整页。
- 目的、事实或来源失败 → 回到 Reference Brief / Content Plan，不用视觉补丁掩盖。
- 信息结构或 page type 失败 → 回到 Art Direction 或 Template Mold。
- 组件语义、Recipe 或系统工艺失败 → 回到对应 Asset Contract / Mold Making。
- Visual Gate 拒绝 → 带证据与责任接口的 Visual Review Record → `ChangesRequested` → 有界修改。
- Deprecated → 新生产拒绝；旧实例通过 replacement + Migration Manifest 迁移。

Coverage Report 定期按缺口种类与频率回顾。高频 `mold_making` 原因进入制范 backlog，减少未来慢路径；高频 `owner_unblock` 原因进入环境/readiness 改进，不误建设计资产。

## Project Profile 边界

范铸核心只定义状态机、接口和执行规则。品牌 Variables、Figma keys、Recipes、Templates、readiness 与 pilot evidence 全部属于使用者自己的 `projects/<project-id>/`，不属于通用公开管线。
