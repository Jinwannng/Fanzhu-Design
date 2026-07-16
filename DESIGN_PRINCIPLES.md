# 范铸 Design Declarations

范铸把设计判断与执行过程分开：Design Declarations 定义什么算对，Execution Contracts 规定何时读取、如何生成、怎样验收和向哪里回流。人建立 taste 与判断标准；Agent 负责执行、复用和暴露缺口，不能自行批准视觉质量。

## 1. 三类设计声明

### Intent Brief

定义设计为何存在：主题、受众、输出类型、唯一任务、核心结论、事实与来源、非目标、领域语义以及不确定项。内容 SSOT 与事实准确性优先于参考图和视觉偏好。

### Design Direction

定义内容如何被表达：信息关系、阅读顺序、视觉命题、语义色彩角色、字体角色、密度、材质职责、图像与数据处理、Dark/Light 行为、一个 Signature 和明确的克制边界。

Intent Brief 与 Design Direction 合并保存在每次任务的 Reference Brief 中，避免同一意图被多份文件重复解释。

### Asset Contract

定义可复用实现边界：Component Registry、Binding Policy、Variables、Styles、Recipe Components 和 Template Components。它不仅登记“有什么”，还必须说明语义角色、正确用途、禁止误用、组合边界、variants、states、slots、内容容量和主题行为。

## 2. 通用设计原则

### Purpose before pixels

先确认页面帮助谁理解、判断或行动，再决定界面形式。Deck 的每页只承担一个主要结论；Dashboard 的每个区域必须服务状态判断、诊断或操作。

### Structure carries meaning

层级、分组、顺序、对比、标签、编号和留白必须表达真实内容关系。只有真实序列使用编号，只有真实差异使用对比结构；数据必须支持结论，不能只填满画面。

### Visual craft has responsibility

- 色彩负责强调、状态和数据编码；品牌色越强，使用范围越小。
- 材质负责层级、焦点或状态；Glass、Glow、Gradient 和 Shadow 不能成为默认装饰。
- Typography 负责身份与阅读节奏；中文字体、字重、行高和标点必须显式处理。
- 空间与几何负责关系和密度；内部、组件间与页面区域间距必须分层，圆角服从嵌套关系。
- 动效只解释状态、空间或反馈；静态 Deck/Poster 不引入虚假的 motion 语言。
- 图表颜色、标签、来源和时间窗必须支持可信判断；缺失值不得伪装成零。

### Components carry semantics

外观相似不等于语义相同。每个组件和 Template 必须具有稳定角色与适用条件；生产阶段根据语义和信息任务选择范，不按视觉相似度凑用。

### Boundaries are part of design

产品界面必须考虑 Empty、Loading、Error、Disabled、Permission、Timeout、Unknown 和 Recovery。静态输出也必须区分事实、假设、不确定、缺失数据、来源和时间范围。

### Restraint creates focus

每个方向最多使用一个 Signature，其余元素保持安静。删除不服务内容、状态、层级或品牌身份的装饰。Glass、卡片墙、渐变、Glow、任意编号和统一大圆角本身都不构成独特性。

## 3. 页面类型决定评审重点

范铸不使用统一的“高级感”评价所有页面，也不引入复杂加权总分。先确认 page type，再选择主要评审镜头：

| Page type | 主要任务 | 优先判断 |
|---|---|---|
| Cover / Poster | 建立主题、兴趣与记忆 | Product Intent、Visual & Brand Expression |
| Hero / Narrative | 传达单一结论与叙事推进 | Product Intent、Information Architecture |
| Compare | 帮助识别真实差异 | Information Architecture、Trust & Domain Fit |
| Data / Infographic | 用证据支持判断 | Trust & Domain Fit、Information Architecture |
| Dashboard | 判断状态、诊断变化或行动 | Information Architecture、System Craft、Interaction Readiness |
| Documentation | 找到、理解并应用信息 | Information Architecture、Trust & Domain Fit |

所有类型仍需检查六个镜头：Product Intent、Trust & Domain Fit、Information Architecture、Interaction Readiness（适用时）、System Craft、Visual & Brand Expression。它们是定位问题的语言，不是自动批准视觉的分数。

## 4. 执行与证据

固定 Design I/O 为：

```text
Intent → Information Architecture → Design Direction → Coverage
→ Mold Making or Casting → Evidence → Review → Directed Return
```

- 约束从上游持续进入每一步，不等到末端才检查。
- Evaluator 面对真实产物和证据，不接受 Agent 对自身意图的声明作为通过依据。
- 截图负责视觉事实；Registry、Manifest、bindings 和 node IDs 负责结构事实；内容 SSOT、来源和时间窗负责语义事实。
- 阻断问题优先于整体评价。内容错误、结构错配、错误组件语义、detach、未授权 literal 或关键状态缺失不能被其他优点抵消。
- 每条 Review Finding 必须包含 `evidence`、`blocking`、`owner_interface`、`return_step` 和 `required_change`；禁止只写“再优化一下”。

## 5. 回流与进化

| 问题 | owner_interface | return_step |
|---|---|---|
| 目标、事实、领域语义或来源不清 | `reference_brief.intent` | `art_direction` 或 `content_replan` |
| 层级、顺序、对比或页面类型错误 | `reference_brief.information_architecture` | `art_direction` 或 `template_mold` |
| 视觉命题、克制或 Signature 失效 | `reference_brief.design_direction` | `art_direction` |
| 色彩、字体、材质或主题系统缺口 | `asset_contract.foundations_or_recipe` | `mold_making` |
| 组件语义、状态、slot 或组合边界缺口 | `asset_contract.registry` | `mold_making` |
| Manifest、binding、实例来源或局部组装错误 | `execution.production` | `bounded_production_fix` |
| 发布、订阅、权限或字体环境阻塞 | `environment.readiness` | `owner_unblock` |

重复出现的稳定问题应更新对应声明、Skill、Registry 或检查器；不要只修当前页面。自动化可以积累证据并提出修改，但不能自行改变 taste 或批准 Visual Gate。
