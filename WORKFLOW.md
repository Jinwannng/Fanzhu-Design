# 范铸 Codex + Figma Workflow

## 0. 选择 Project Profile

读取 `DESIGN_PRINCIPLES.md`、`projects/<project-id>/README.md` 与 interfaces。确认 Library source、production target、Variables/Styles、Registry、readiness、fonts 与安全 Pilot page。没有 Profile 不得写入 Figma。

## 1. 定调与覆盖判断

先用 `fanzhu-art-direction` 把内容 SSOT 与风格参考转成 Reference Brief。它合并 Intent Brief 与 Design Direction：主题、受众、唯一任务、事实与不确定项、信息关系、page types、视觉命题、字体/色彩角色、材质职责、Signature 与克制边界。定调不写 Figma，也不创建 token 或组件。

先运行 `ruby scripts/validate-reference-brief.rb <brief>`。人工接受后运行 `ruby scripts/validate-reference-brief.rb <brief> --require-accepted`，通过才创建 Coverage Report；将 visual grammar、layout grammar、component semantics、content capacity 与 theme behavior 对照 Approved Registry。

- 全部覆盖：`route=cast`，选择 `fanzhu-production`，进入浇铸。
- 缺设计资产/API：`route=mold_making`，写 Mold Gap，选择 `fanzhu-library`，进入制范。
- 缺权限、发布/订阅或字体：`route=owner_unblock`，写 Gap Report，停止等待 owner；不建替代资产。
- 内容超量：`route=content_replan`，返回内容规划；不写 Gap。
- 覆盖判断不确定：记录 `route=mold_making` 与原因，不用近似组件冒充。

## 2. 制范 Workflow

1. Inspect：本地与 remote/library inventory；不能因本地 API 看不到就误判不存在。
2. Choose one family：每次 mutation run 先写一个 Registry `Draft`，声明语义角色、正确用途、禁止误用、组合边界、states、API、容量、bindings、literals 与依赖。多个独立 family 可以并行至 `InReview`，但不得在同一次写入里混改。
3. Build Main Component：复用 Foundations；复杂材质结构存在 Recipe Component 内。
4. Expose API：text/boolean/variant/instance-swap/slots 必须覆盖生产需求；不可覆盖即 Component API Gap。
5. Validate：真实中文 Instance、Auto Layout、bindings、Dark/Light geometry、局部与整页 evidence。
6. Submit：机器 Gate 全过后 Codex 可自动提交 `InReview`。
7. Human Review：明确 pass 才记录 `Approved`；拒绝则记录 `ChangesRequested` 和 Visual Review Record。
8. Publish：生产文件必须能搜索并导入 component key；否则 readiness 仍 blocked。

### Amendment

对 Approved family 的小修创建 Amendment candidate，而不是把 base entry 改回 `Draft`。candidate 必须声明 base revision、delta scope 与受影响 Gate；Validate 与 Human Review 只审 delta 及其回归面。原 revision 保持可生产，直到 amendment 发布。

## 3. 浇铸 Workflow

1. Content Plan：校对数据，每页一个结论，匹配模板容量。
2. Build Manifest：列出 target、mode、template、instances、slots、bindings 和 literals。
3. Manifest Preflight：执行 `ruby scripts/validate-manifest.rb <manifest> <registry> <policy>`；失败不写 Figma。
4. Library Readiness：验证发布、订阅、remote search 与 disposable import。
5. Assemble：仅使用 Approved Instances；用 properties、variants、Instance Swap、slots 写入；禁止 detach。
6. Audit：输出问题与 node IDs；只修定位节点。
7. Screenshot + Review：先单页、后批量；按 page type 检查目的、可信度、信息结构、适用的交互就绪度、系统工艺与视觉表达。
8. Theme/Output：只切 mode/批准 theme asset；不改几何。

## 4. 失败处理

| 失败 | 产物 | 下一步 | 禁止 |
|---|---|---|---|
| 缺 Recipe / Template / slot / property / semantic Variable 或 Style | Mold Gap | 返回制范 | 临时近似组件 |
| 未发布、未订阅、无权限、字体缺失 | Gap Report | 由 owner 解除后重新 Coverage | 本地复制或静默换字体 |
| 内容超量 | 修订后的 Content Plan | 换模板、拆页或改文 | 缩小字号硬塞 |
| Audit 失败 | Issue list + node IDs | 有界修复并复查 | 自动重建整页 |
| 目标、事实、来源或领域语义失败 | Review Finding | 回到 Reference Brief / Content Plan | 用视觉效果掩盖内容问题 |
| 层级、顺序、对比或 page type 失败 | Review Finding | 回到 Art Direction 或 Template Mold | 在生产实例上重排整个系统 |
| Visual Gate 拒绝 | Visual Review Record | 按 `owner_interface` 与 `return_step` 有界返修 | 自动批准或写“再优化” |
| Deprecated | Migration Manifest | replacement 逐页迁移 | 删除旧范或强制回炉 |

Coverage Report 是所有路由的强制产物。每条 Review Finding 必须包含 `evidence`、`blocking`、`owner_interface`、`return_step` 和 `required_change`，并运行 `ruby scripts/validate-review-record.rb <review-record>`。定期按缺口种类和频率回顾：稳定重复的问题更新相应声明、Skill、Registry 或检查器，而不只修当前页面。

## 5. 三道门

1. Reuse：重复视觉来自 Approved Instance/Style。
2. Binding：无未授权 hardcode 或 detach；literal 有来源与理由。
3. Visual：人根据 page type 确认 Product Intent、Trust & Domain Fit、Information Architecture、适用的 Interaction Readiness、System Craft、Visual & Brand Expression 与 Dark/Light 几何；阻断问题不能被整体评价抵消。
