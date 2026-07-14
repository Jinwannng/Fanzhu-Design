# 范铸 Fànzhù — Mold & Cast Design Pipeline

范铸是一套把视觉灵感、内容与设计系统转化为高质量 Figma 页面的方法。它适用于 Deck、Poster、Dashboard 等界面设计，也适用于深色/浅色主题的成套输出。

范铸借用“先制范、后浇铸”的工艺结构：先把可复用的视觉规则和页面模板做好，再用同一套范稳定生产页面。它不是一次性生成器，而是让第一次建设可复用、让后续生产更快更一致的设计管线。

## 1. 为什么需要范铸

灵感来源、草图工具和 AI 往往会分别解释同一个设计意图，容易产生版式漂移、重复造组件、样式 hardcode、主题不一致和大量人工返工。

范铸把设计过程拆成可复用的视觉资产、明确的内容接口和可验证的生产步骤，让人负责判断，AI 负责执行，Figma 保存最终设计真值。

## 2. 范铸能做什么

- 从一张风格参考中提取色彩、字体、材质、光源、网格、层级和状态规则。
- 将长文本切分为页面结论，并匹配合适的页面模板。
- 将复杂视觉语法封装为 Recipe Components，将页面结构封装为 Template Components。
- 通过 Variables、Styles、variants、properties 和 slots 组装页面。
- 在写入前检查计划，在写入后检查复用、绑定、文字容量和几何一致性。
- 使用同一套视觉范生产 Deck、Poster、Dashboard 和主题变体。

## 3. 核心模型

范铸包含两个循环和一个覆盖判断：

1. **制范（Mold Making）**：Reference Brief → Foundations → Main Component → Component API → Machine Gates → `InReview` → Human Visual Gate → Approved Mold。
2. **浇铸（Casting）**：Content Plan → Build Manifest → Manifest Preflight → Library Readiness → Approved Instances → Audit → Screenshot → Output。
3. **覆盖判断（Coverage）**：先判断现有 Approved Mold 是否能表达目标；判断结果写入 Coverage Report。

Coverage Report 只允许四种路由：

- `cast`：现有范完整覆盖，直接生产页面。
- `mold_making`：缺少视觉资产、组件 API、slot、property 或设计 token，进入制范并生成 Mold Gap。
- `owner_unblock`：缺少发布、订阅、权限或字体等外部条件，生成 Gap Report，等待条件解除。
- `content_replan`：内容超过模板容量，返回内容规划，不修改组件。

## 4. 从灵感到页面

```text
灵感 + 内容
   ↓
Reference Brief
   ↓
Coverage Report
   ├─ cast → Manifest → Instances → Audit → Screenshot → 页面
   ├─ mold_making → Mold Gap → 制范 → Review → Approved → 回到 Manifest
   ├─ owner_unblock → Gap Report → 条件解除 → 重新 Coverage
   └─ content_replan → 拆页/改文/换模板 → 重新 Coverage
```

新视觉方向的第一轮需要先做范；一旦范通过审核，同类页面就可以快速浇铸。

## 5. 三道门与生命周期

### Reuse Gate

可复用视觉结构必须来自 Approved Instance、Style 或 Component。禁止在生产页面复制或 detach 组件内部结构。

### Binding Gate

颜色、间距、圆角、描边和透明度使用 Variables；完整字体、阴影、模糊和绘制组合使用 Styles；复杂材质和结构使用 Components。例外值必须登记。

### Visual Gate

人工确认层级、材质、排版、焦点和主题一致性。机器可以提交 `InReview`，不能代替人工批准。

状态为 `Draft → InReview → Approved`，或 `InReview → ChangesRequested → InReview`。小修使用 Amendment candidate，只验证变更范围和受影响的回归面；旧版本在新版本发布前继续可用。

## 6. 项目接口

范铸通过以下接口让人和 AI 使用同一套规则：

| 接口 | 作用 |
|---|---|
| Component Registry | 记录范的组件、变体、属性、slots、内容容量和状态。 |
| Binding Policy | 规定属性应使用 Variable、Style、Component 或允许的固定值。 |
| Coverage Report | 记录覆盖判断、缺口分类和下一步路由。 |
| Build Manifest | 在写入 Figma 前声明目标、模板、实例、内容和绑定。 |
| Mold Gap | 记录需要建设的设计资产或 API。 |
| Gap Report | 记录权限、发布、订阅和字体等外部阻塞。 |
| Visual Review Record | 记录人工视觉审核与返修意见。 |

## 7. 项目扩展

范铸核心不绑定品牌。不同项目可以提供自己的 Variables、Styles、Recipes、Templates、Registry 和 Code Reference，并复用同一套状态机、校验器和生产技能。

## 8. 使用环境

常见环境包括 Figma、Codex、Figma MCP、Variables/Styles、Draw.io，以及用于页面组装和审计的项目技能。具体工具由项目自行选择；范铸核心只依赖清晰的输入、批准的设计资产和可验证的输出。

## 9. 人如何使用

提供三项输入：

1. SSOT 文本或内容计划。
2. 一张或多张风格参考。
3. 输出尺寸、主题和页面类型。

先审核 Reference Brief、Coverage Report 和三张代表页；代表页通过后，再批量生成同类页面。

## 10. AI 如何开始

AI 应先读取项目规则，生成 Reference Brief 和 Coverage Report，再选择制范或浇铸技能。生产写入前必须通过 Coverage、Manifest 和依赖检查；失败时停止当前对象并输出对应报告，不创建近似替代品。

## 11. 公开发布内容

本仓库公开的是范铸的通用方法、接口示例、校验脚本、技能规范和流程图。品牌专属 token、设计文件标识、内部截图、凭据和机器配置应由使用者自行保管，不属于公共项目说明。

## 12. 后续方向

- 为常见页面类型积累 Approved Mold。
- 回顾 Coverage Report，优先补齐高频缺口。
- 用多个不同项目验证范铸的可移植性。
- 在存在真实产品代码库后，再评估 Code Connect。

## 13. 非目标

- 不承诺任意新视觉方向一键完成。
- 不让参考网页或草图工具直接决定最终页面结构。
- 不让 AI 在生产阶段临时发明组件。
- 不把外部截图或 CSS 直接登记为 Approved Mold。
- 不用复杂的双向 token 同步增加维护成本。
