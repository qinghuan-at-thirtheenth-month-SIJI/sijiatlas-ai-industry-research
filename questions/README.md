# Questions SIJI is designed to help answer

These examples show the kinds of industry-research questions that map naturally to SIJI.

## 中文

### 1. AI 搜了一堆网页还是很碎，怎么把它变成结构化研究？

从 SIJI 的 world overview 或实体搜索开始，把产品、产业位置、公司、关系、事实和来源放进同一个研究上下文。

### 2. 一个 AI 产品处在产业链的什么位置？

先解析产品身份，再读取它所在的产业位置和相邻关系。

### 3. 哪些公司参与某个产品层？

从产品或产业位置展开公司参与记录，再进入事实和证据。

### 4. 某家公司有哪些具体 AI 产品或业务？

从公司实体进入其产品/业务和产业位置，再逐条读取商业事实。

### 5. 客户、供应商和合作关系有哪些公开证据？

读取公司关系与对应 evidence/source 引用，并保留关系类型和时间范围。

### 6. 一个产品商业化到哪一步？

查看送样、验证、导入、量产、订单、出货、交付、收入等事实及其状态。

### 7. 哪些环节正在扩产？

从产能、工厂、扩建和量产事实进入对应产品、公司与来源。

### 8. 最近哪些公司或产品发生了变化？

使用 `list_changes` 做开放发现，或持续跟踪明确的 company/product refs。

### 9. 两个公司或产品怎么比较？

使用 `compare` 对齐同一维度，再打开各自事实和证据。

### 10. 一个变化会沿哪些上下游路径传播？

从明确对象调用 `trace_paths`，再逐个打开路径上的实体、关系和事实。

### 11. SIJI 查到的结论怎么回到原始来源？

沿 Fact / Relation → Evidence → Source 引用打开来源。

### 12. ChatGPT / Claude 能直接使用吗？

可以通过 Research API 或 Agent Graph 接入。机器契约见 [Research API](../docs/research-api.md)、[capabilities.json](../api/capabilities.json) 与 [OpenAPI](../api/openapi.json)。

## English

- How do I turn fragmented AI-industry research into a connected map?
- Which products occupy a specific AI-infrastructure position?
- Which companies participate in a product layer?
- What commercialization stage has a product reached?
- What customer, supplier, order, capacity, shipment, or delivery evidence is available?
- What changed recently?
- How are two companies or products different on the same research dimension?
- Which upstream/downstream paths connect two industry objects?
- Can I trace a result back to an original source?
- Can my AI agent use SIJI through an API?
