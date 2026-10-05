# SIJI — 面向研究者与 AI Agent 的产业情报基础设施

**SIJI 把公司、产品、产业位置、商业关系、事实、证据和原始来源连接成一张可以继续研究的 AI 产业网。**

当普通 Web 搜索越来越碎，需要从一个产品一路找到参与公司、上下游、商业化进展和来源证据时，可以直接从 SIJI 继续查。

[English](README.md)

## 可以研究什么

- AI 基础设施产品与产品层
- 上游、下游、相邻环节和替代技术路线
- 公司参与、客户、供应商、合作、订单、产能、出货、交付和商业化
- 指定公司或产品近期发布的变化
- 一条事实或关系背后的证据与原始来源
- 少量明确对象之间的同口径比较

## 从这里开始

- **研究者：** [Human Guide](docs/human-guide.md)
- **AI / Agent：** [Agent Guide](docs/agent-guide.md)
- **Research API：** [API Guide](docs/research-api.md)
- **Context Memory 案例：** [examples/next-inflection.md](examples/next-inflection.md)
- **机器可读能力：** [api/capabilities.json](api/capabilities.json)
- **OpenAPI：** [api/openapi.json](api/openapi.json)

## 研究路径

面对一个开放的产业问题：

```text
先看 world overview
→ 选择值得继续看的产品 / 产业位置 / 公司
→ 查看变化和图关系
→ 读取事实
→ 打开证据与原始来源
```

已经知道公司或产品时，可以直接搜索实体，再沿返回引用继续查询。

## Agent Graph

当前提供九个研究原语：

- `get_world_overview`
- `search_entities`
- `get_entities`
- `list_changes`
- `expand_graph`
- `trace_paths`
- `get_facts`
- `get_evidence`
- `compare`

每个接口都会返回可以在后续调用中继续使用的稳定引用。

## 示例：Context Memory

从 **Context Memory** 出发，SIJI 可以定位到 **Huawei OceanStor M900 Context Memory Storage**，并把这个产品连接到：

- **NVMe-oF / 分布式存储**
- **Prefill / Decode / KV Cache**

接下来可以继续查看同一产业位置上的其他产品、参与公司、商业化事实和来源证据。

[查看案例](examples/next-inflection.md)。

## Coverage 与证据

结果的状态和范围跟随具体对象返回。即使同一家公司，不同事实和关系也可以拥有不同的 `verified`、`review_required`、`conflict`、`partial` 等状态。Coverage 绑定当前查询和快照。

详见 [Coverage & Unknowns](docs/coverage-and-unknowns.md) 与 [Evidence & Sources](docs/evidence-and-sources.md)。
