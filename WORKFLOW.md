# 范铸 Codex + Figma Workflow

## 0. 选择 Project Profile

读取 `projects/<project-id>/README.md` 与 interfaces。确认 Library source、production target、Variables/Styles、Registry、readiness、fonts 与安全 Pilot page。没有 Profile 不得写入 Figma。

## 1. 灵感覆盖判断

把灵感转成 Reference Brief，再将需要的 visual grammar、layout grammar、content capacity 与 theme behavior 对照 Approved Registry。

- 全部覆盖：选择 `fanzhu-production`，进入浇铸。
- 任一缺失：写 Mold Gap，选择 `fanzhu-library`，进入制范。
- 覆盖判断不确定：视为缺失，不用近似组件冒充。

## 2. 制范 Workflow

1. Inspect：本地与 remote/library inventory；不能因本地 API 看不到就误判不存在。
2. Choose one family：先写 Registry `Draft`，声明用途、API、容量、bindings、literals 与依赖。
3. Build Main Component：复用 Foundations；复杂材质结构存在 Recipe Component 内。
4. Expose API：text/boolean/variant/instance-swap/slots 必须覆盖生产需求；不可覆盖即 Component API Gap。
5. Validate：真实中文 Instance、Auto Layout、bindings、Dark/Light geometry、局部与整页 evidence。
6. Submit：机器 Gate 全过后 Codex 可自动提交 `InReview`。
7. Human Review：明确 pass 才记录 `Approved`；拒绝则记录 `ChangesRequested` 和 Visual Review Record。
8. Publish：生产文件必须能搜索并导入 component key；否则 readiness 仍 blocked。

## 3. 浇铸 Workflow

1. Content Plan：校对数据，每页一个结论，匹配模板容量。
2. Build Manifest：列出 target、mode、template、instances、slots、bindings 和 literals。
3. Manifest Preflight：执行 `ruby scripts/validate-manifest.rb <manifest> <registry> <policy>`；失败不写 Figma。
4. Library Readiness：验证发布、订阅、remote search 与 disposable import。
5. Assemble：仅使用 Approved Instances；用 properties、variants、Instance Swap、slots 写入；禁止 detach。
6. Audit：输出问题与 node IDs；只修定位节点。
7. Screenshot：先单页、后批量；人工检查视觉与中文层级。
8. Theme/Output：只切 mode/批准 theme asset；不改几何。

## 4. 失败处理

| 失败 | 产物 | 下一步 | 禁止 |
|---|---|---|---|
| Missing component / API / binding | Mold Gap | 返回制范 | 临时近似组件 |
| 未发布、无权限、字体缺失 | Gap Report | 由 owner 解除 | 本地复制或静默换字体 |
| 内容超量 | 修订后的 Content Plan | 换模板、拆页或改文 | 缩小字号硬塞 |
| Audit 失败 | Issue list + node IDs | 有界修复并复查 | 自动重建整页 |
| Visual Gate 拒绝 | Visual Review Record | `ChangesRequested` 后返修 | 自动批准或用 Gap 代替 |
| Deprecated | Migration Manifest | replacement 逐页迁移 | 删除旧范或强制回炉 |

## 5. 三道门

1. Reuse：重复视觉来自 Approved Instance/Style。
2. Binding：无未授权 hardcode 或 detach；literal 有来源与理由。
3. Visual：人确认层级、材质、中文排版、焦点与 Dark/Light 几何。
