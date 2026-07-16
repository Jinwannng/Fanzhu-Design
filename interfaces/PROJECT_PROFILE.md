# Project Profile interface

每个 `projects/<project-id>/` 至少包含：

- `README.md`：领域语义、项目目的、Figma roles、环境、当前 readiness 与人工 owner。
- `VARIABLES.md` 与 `VISUAL_RECIPES.md`：项目自己的设计真值和视觉语法。
- `interfaces/component-registry.yaml`：Mold Registry。
- `interfaces/binding-policy.yaml`：项目 binding 分类与例外。
- `interfaces/readiness-gates.yaml`：Production 硬阻塞、owner、pass conditions 与 evidence。
- `interfaces/pilot-status.yaml`：当前 family 状态与下一步。
- 每次任务的 Reference Brief：合并 Intent Brief 与 Design Direction，记录状态与人工接受。
- Manifest、Gap Report、带 evidence / blocking / owner_interface / return_step 的 Visual Review 示例。
- Coverage Report：记录灵感覆盖、缺口分类、路由与高频缺口回顾数据。

核心字段保持稳定；品牌名、Figma keys、component keys、variable/style names 和视觉值只存在于私有 Profile。新增项目不得复制其他项目的实际 token 值或 component keys。
