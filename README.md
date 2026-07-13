# 范铸 Fànzhù — Figma × Codex Mold & Cast Pipeline

范铸是一套把**视觉灵感变成可复用 Figma 设计资产，再由 Codex 稳定生产页面**的工作流与工具包。它借用铸范法的流程结构作为产品隐喻：先制范，再浇铸；范未验收，不能投入生产。

它不属于某个品牌。AEGIS X 是第一个 Project Profile，用来验证这套管线能否生产 Deck、Poster、Dashboard 与 Dark/Light 版本。

## 1. 为什么需要范铸

Pinterest、Stitch、网页截图和代码案例很适合找方向，却不能直接成为生产规范。灵感经过 Stitch、Figma、Codex 多次重新解释后，常见结果是结构漂移、页面级 hardcode、组件重复、材质失真、Variables 未绑定，以及 Dark/Light 版式分叉。

范铸把一次性的 prompt 结果改造成三个可持续对象：

1. **范**：已批准的 Variables、Styles、Recipe Components 与 Template Components。
2. **铸造计划**：机器可读的 Registry、Binding Policy 与 Build Manifest。
3. **铸件**：只由 Approved Instances 组装、经过 Audit 与人工视觉确认的页面。

因此它优化的不是“第一次就一键生成”，而是**先制范，再浇铸；第一次把范做好，第二次以后快速且稳定地复用**。

## 2. 范铸能做什么

- 把外部灵感拆成光源、材质、层级、状态、构图与内容容量，而不是复制随机像素。
- 判断当前 Approved 范是否足以表达该灵感：足够则直接浇铸，不足则先生成 Mold Gap 并进入制范。
- 把复杂的 glass、chrome、glow、noise、data panel 等视觉语法封装为 Recipe Components。
- 让 Codex 通过 Variables、Styles、variants、properties、Instance Swap 与 slots 生产页面。
- 在写入前阻止错误计划，在写入后定位 detach、hardcode、错误 binding 与几何漂移。
- 在同一设计语言下稳定扩展 Deck、Poster、Dashboard 与 Dark/Light 输出。

它不能替代人的审美判断，也不能保证任意新视觉方向当天完成。没有 Approved 范的新方向必须先完成制范与人工 Visual Gate。

## 3. 核心模型

范铸严格区分两个循环：

1. **循环 A · 制范（Mold Making）**：Reference Brief → Foundations → Main Component → Component API → Machine Gates → `InReview` → Human Visual Gate → Approved Mold Registry → 发布 Library。
2. **循环 B · 浇铸（Casting）**：Content Plan → Build Manifest → Manifest Preflight → Library Readiness → Approved Instances → Slots/Properties → Audit → Screenshot → Output。

两个循环之间有一个**灵感覆盖路由**：

- 现有 Approved Recipe 与 Template 能覆盖视觉意图和内容容量 → 直接进入浇铸。
- 缺少视觉语法、模板结构、slot、variable、font 或 library access → 输出 Mold Gap，停止当前铸件，返回制范。
- Production 不得顺手造范；制范也不得顺手生产正式页面。

## 4. 从灵感到 Figma 的新工作流

```text
灵感来源 + 已校对内容
        ↓
Reference Brief：提取意图，不复制实现
        ↓
Approved 范是否覆盖？
   ├─ 是 → Build Manifest → 浇铸 → Audit → Visual Gate → 输出
   └─ 否 → Mold Gap → 制范 → InReview → Human Visual Gate
                         ├─ Approved → 发布 Library → 回到 Manifest
                         └─ ChangesRequested → 有界修改 → 重新提交
```

“快速高质量”有两个明确档位：

- **已覆盖的灵感**：主要工作是选择 Template、填充 slots、切换 variants 与 mode，可快速生产。
- **未覆盖的新视觉方向**：第一轮有意变慢，因为必须先建设可复用范；批准后，同类页面才进入快速通道。

详细步骤见 [`PIPELINE.md`](./PIPELINE.md) 与 [`WORKFLOW.md`](./WORKFLOW.md)。

## 5. 三道门与生命周期

### Reuse Gate

可复用视觉结构必须来自 Approved Instance。普通 Frame 只能承担 Manifest 明确允许的页面容器或一次性内容几何；禁止 detach 与复制 Recipe 内部结构。

### Binding Gate

颜色、间距、圆角、描边、透明度等使用 semantic Variables；完整 typography、shadow、blur 与 paint 组合使用 Styles；多层视觉语法使用 Components。Literal 必须同时被 Registry 与 Manifest 明确允许。

### Visual Gate

人负责判断材质克制、信息层级、中文排版、焦点与品牌感。机器 Gate 通过后 Codex 可以把 `Draft` 或 `ChangesRequested` 自动提交为 `InReview`，但只有人能给出 `pass` 或 `changes_requested`。Visual rejection 生成 Visual Review Record，不生成 Gap Report。

生命周期：`Draft → InReview → Approved`，或 `InReview → ChangesRequested → InReview`。`Deprecated` 禁止新铸件使用；已有铸件继续存在，按 replacement 与 Migration Manifest 渐进迁移。

## 6. 工具与机器接口

| 资产 | 用途 |
|---|---|
| `fanzhu-library` | 制范：盘点 Foundations，建设/修改一个 Component Family，验证并提交人工审核。 |
| `fanzhu-production` | 浇铸：路由灵感、验证 Manifest、实例化 Approved 范、Audit 与截图。 |
| Component Registry | 记录每个范的 Figma key、API、内容容量、bindings、literals、状态与证据。 |
| Binding Policy | 定义哪些属性必须使用 Variable、Style、Component 或 Allowed Literal。 |
| Build Manifest | 在 Figma 写入前声明目标、模板、实例、内容、bindings 与允许例外。 |
| Gap Report | 缺失范、API、变量、字体、权限或 Library 时停止当前铸件并回流。 |
| Visual Review Record | 记录人工视觉通过或具体返修意见。 |
| Preflight / Audit scripts | 写前验证计划，写后定位实际节点问题；不自动重建整页。 |
| `pipeline.drawio` | 中文可编辑流程图，展示覆盖路由、制范、浇铸与失败回流。 |

Figma 是当前设计 SSOT。HTML/CSS Gallery 只是 Recipe 的可读实现参考，不与 Figma 双向同步。没有真实产品代码库与 Storybook 时不启用 Code Connect。

## 7. Project Profile

通用管线不保存任何品牌值。每个项目在 `projects/<project-id>/` 中提供自己的：

- Figma Library source 与 Production targets
- Variables、Styles 与 Visual Recipes
- Component Registry、Binding Policy 与 Readiness Gates
- Manifest / Gap / Visual Review 示例
- Code Reference Gallery、批准截图与 Pilot 状态

当前 Profile：AEGIS X（[`projects/aegis-x/README.md`](./projects/aegis-x/README.md)）。新增项目应复制接口结构和状态机，而不是复制 AEGIS 的视觉值。

## 8. 运行环境

必需环境：macOS、Codex Desktop、Figma 文件权限、Figma MCP、`figma-use`、`figma-generate-library`、`figma-generate-design`。Figma Slides 额外加载 Slides skill；流程图导出需要 Draw.io Desktop CLI。

仓库位置：

- Canonical：`<repository-root>`
- WIP Cloud mirror：`<local-wip-mirror>`
- Skills：`<codex-skills>/fanzhu-library` 与 `<codex-skills>/fanzhu-production`

## 9. 人如何使用

给出灵感、已校对内容、目标尺寸、目标 Figma 文件与 Project Profile。先审阅 Reference Brief 和覆盖判断：如果走制范，一次只批准一个 family；如果走浇铸，先批准第一张代表页面，再批量同类页面。人始终保留 Visual Gate 与 Library 发布/订阅权限。

## 10. AI 如何开始

AI 固定读取顺序：

1. 根目录 `README.md`、`PIPELINE.md`、`WORKFLOW.md`。
2. 目标 Project Profile 的 `README.md`、`pilot-status.yaml`、`readiness-gates.yaml`、`component-registry.yaml`、`binding-policy.yaml`。
3. 输出 Reference Brief 与覆盖判断。
4. 制范调用 `fanzhu-library`；浇铸调用 `fanzhu-production`。

修改核心文档或接口后运行 `ruby scripts/check-readme-structure.rb --self-test`。Production 写入前运行 `ruby scripts/validate-manifest.rb <manifest> <registry> <policy>`；失败时禁止调用 Figma 写工具。

## 11. AEGIS X 当前状态

范铸核心规则、两个 skills、机器接口、流程图与 AEGIS Glass Pilot 已建立，但 **AEGIS X 目前还不能端到端浇铸正式页面**：

- Glass Panel 已过 Reuse、Binding、Geometry，状态为 `InReview`，等待人工 Visual Gate。
- Brand Assets Library 尚未在生产文件完成发布/订阅证明，Production 被硬阻塞。
- Cover、Compare、Data 仍是 Draft，尚无 Approved component keys。
- Legacy Dashboard Light variables 的 rename-and-quarantine 尚未执行。

所以今天给 Codex 任意灵感并不能保证直接出高质量页面。只有落在 Approved 范覆盖范围内的灵感才会进入快速通道；AEGIS 需先解除上述阻塞。

## 12. 下一步

P0：人工完成 Glass Visual Gate；Figma admin 完成 Library 发布、订阅与 disposable import proof；制范循环执行 legacy variable namespace 迁移。

P1：按 Cover → Compare → Data 逐个制范，每个 family 完成 API、中文容量、Dark/Light、机器 Gate、人工 Visual Gate 与 Approved Registry。

P2：用三张真实中文页面跑通第一次浇铸：Reference Brief → Coverage → Manifest → Preflight → Instances → Audit → Screenshot。

P3：在 AEGIS 稳定后，用第二个视觉项目验证 Project Profile 的可移植性；这是判断范铸是否真正脱离 AEGIS 的关键测试。

## 13. 非目标

- 不承诺任意新视觉方向一键完成。
- 不让 Stitch 或参考网页直接决定 Figma 页面结构。
- 不让 Codex 在 Production 临时发明组件或近似替代品。
- 不把 Pinterest、截图或外部 CSS 直接登记成 Approved 范。
- 不把 Deck 几何缩放成 Dashboard Template。
- 不在没有真实产品代码库时引入 Code Connect 或复杂双向 Token 同步。
