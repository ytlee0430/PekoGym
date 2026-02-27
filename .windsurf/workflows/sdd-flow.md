---
description: 'BMAD 完整軟體開發流程自動導航。Autopilot 模式：不問問題、自動選最佳方案、記錄決策到 log、完成後 auto commit+push。使用者說「sdd flow」「開始開發流程」「bmad 全流程」時觸發。'
auto_execution_mode: 3
---

# SDD Flow — BMAD 全流程自動導航器

此 workflow 引導使用者按照 BMAD BMM 模組的標準 phase 順序，從分析到交付完成整個軟體開發流程。

**核心原則：Autopilot 模式** — 最大限度減少使用者介入，所有決策自動選擇最推薦方案。

---

## Model 分配規則

| 類型 | Model | 適用步驟 |
|------|-------|---------|
| 技術文件 / 規劃 | **Claude Opus 4.6** | Phase 1 ~ Phase 3 全部，Phase 4 的 create-story、sprint-planning、sprint-status |
| 開發實作 | **Claude Sonnet 4.6** | Phase 4 的 dev-story |
| Code Review | **Codex 5.3** | Phase 4 的 code-review |

---

## 流程總覽

啟動時先展示以下流程地圖，然後自動偵測進度決定從哪一步開始：

```
Phase 1: Analysis ─────────────────────────────── [Opus 4.6]
  ① Brainstorm Project          /bmad-brainstorming
  ② Market Research (optional)  /bmad-bmm-market-research
  ③ Domain Research (optional)  /bmad-bmm-domain-research
  ④ Technical Research (opt.)   /bmad-bmm-technical-research
  ⑤ Create Product Brief        /bmad-bmm-create-product-brief

Phase 2: Planning ─────────────────────────────── [Opus 4.6]
  ⑥ Create PRD ★必要            /bmad-bmm-create-prd
  ⑦ Validate PRD (optional)     /bmad-bmm-validate-prd
  ⑧ Edit PRD (optional)         /bmad-bmm-edit-prd
  ⑨ Create UX Design (opt.)     /bmad-bmm-create-ux-design

Phase 3: Solutioning ──────────────────────────── [Opus 4.6]
  ⑩ Create Architecture ★必要   /bmad-bmm-create-architecture
  ⑪ Create Epics & Stories ★必要 /bmad-bmm-create-epics-and-stories
  ⑫ Check Implementation Readiness ★必要 /bmad-bmm-check-implementation-readiness

Phase 4: Implementation ───────────────────────── [混合 Model]
  ⑬ Sprint Planning ★必要       /bmad-bmm-sprint-planning        [Opus 4.6]
  ⑭ Sprint Status               /bmad-bmm-sprint-status          [Opus 4.6]
  ── 以下為 Story 循環 ──
  ⑮ Create Story ★必要          /bmad-bmm-create-story           [Opus 4.6]
  ⑯ Dev Story ★必要             /bmad-bmm-dev-story              [Sonnet 4.6]
  ⑰ Code Review                 /bmad-bmm-code-review            [Codex 5.3]
  ── 回到 ⑭ 檢查狀態，如果還有 story 則回到 ⑮ ──
  ⑱ Retrospective (optional)    /bmad-bmm-retrospective          [Opus 4.6]
```

★ = required（必要步驟），其餘為 optional

---

## Autopilot 行為規則

### 決策日誌

每個步驟執行時，在專案根目錄維護一個決策日誌檔案：`_bmad-output/sdd-decisions.md`

當 BMAD workflow 過程中遇到任何需要使用者選擇或回答的問題時：

1. **不要詢問使用者** — 直接選擇最推薦 / 最常見 / 最佳實踐的選項
2. **記錄到決策日誌** — 把問題、所有可選項、你選了什麼、為什麼選它，都寫進 `_bmad-output/sdd-decisions.md`

決策日誌格式：

```markdown
# SDD Flow 決策日誌

## [步驟名稱] — [時間戳]

### 決策 1: [問題摘要]
- **問題**: [workflow 問的完整問題]
- **選項**:
  1. [選項A] — [說明]
  2. [選項B] — [說明]
  3. [選項C] — [說明]
- **自動選擇**: [選了哪個]
- **理由**: [為什麼這是最佳選擇]
- **風險**: [如果這個選擇不對，可能的影響]

### 決策 2: ...
```

### 自動執行規則

- 當 workflow 提供多個選項時 → 選最推薦的（通常是第一個或標記為 recommended 的）
- 當 workflow 要求輸入名稱/描述 → 根據專案 context 自動生成合理內容
- 當 workflow 要求確認（Y/N）→ 一律 Yes，繼續執行
- 當 workflow 要求驗證結果需要修正 → 自動修正，不問使用者
- **唯一例外**：如果決策會導致資料遺失或不可逆操作，必須在決策日誌中標記 `⚠️ HIGH RISK` 並暫停詢問使用者

### 每步驟完成後：自動 Commit & Push

每個 workflow 步驟完成後，自動執行：

```bash
# 1. Stage 所有變更
git add -A

# 2. Commit，把決策摘要放在 commit message 中
git commit -m "sdd-flow: [步驟名稱] completed

[該步驟產出的 artifacts 列表]

Decisions made (review these):
- [決策1摘要]: 選了 [X] (其他選項: [Y], [Z])
- [決策2摘要]: 選了 [X] (其他選項: [Y], [Z])
...

Full decision log: _bmad-output/sdd-decisions.md"

# 3. Push
git push origin HEAD
```

Commit message 規則：

- 第一行：`sdd-flow: [步驟名稱] completed`
- 空行後列出產出的 artifacts
- 再空行後列出所有本步驟做的決策摘要，格式為 `- [問題]: 選了 [答案] (其他選項: [A], [B])`
- 最後提醒 full log 位置
- 這讓使用者可以在 git log 中快速 review 所有自動決策

---

## 執行指引

### 啟動時

1. 顯示流程地圖（見上方流程總覽）
2. 自動偵測專案進度：檢查 `_bmad-output/` 下已有的 artifacts 判斷從哪一步開始
3. 如果是全新專案 → 從 Phase 1 第一步開始
4. 如果已有進度 → 顯示偵測結果，從下一個未完成步驟繼續
5. 建立或更新 `_bmad-output/sdd-decisions.md` 決策日誌檔

### 每個步驟的執行模式

對每個步驟，按以下流程操作：

1. **宣告目前步驟**：簡短一行顯示步驟編號、名稱、所需 model
2. **檢查 model**：如果當前 model 不符合要求，提示使用者切換並開新 chat：
   ```
   ⚠️ 請切換至 [目標 model] → 開新 chat → 執行 /sdd-flow
   ```
3. **直接執行對應的 BMAD workflow**，遇到任何問題都 autopilot 處理（見上方規則）
4. **步驟完成後**：
   - 執行 `git add -A && git commit && git push`（commit message 含決策摘要）
   - 顯示下一步指引：
   ```
   ✅ [步驟名稱] done → 下一步：[名稱] [model]
   🔄 開新 chat 執行 /sdd-flow
   ```

### Phase 4 Story 循環

Phase 4 的核心是 story 循環，每個 story 需要經過三個步驟且涉及不同 model：

```
┌─────────────────────────────────────────────┐
│  Story 循環（每個 story 重複一次）           │
│                                             │
│  1. /bmad-bmm-create-story   [Opus 4.6]    │
│     ↓ 清 context + 換 model                │
│  2. /bmad-bmm-dev-story      [Sonnet 4.6]  │
│     ↓ 清 context + 換 model                │
│  3. /bmad-bmm-code-review    [Codex 5.3]   │
│     ↓ 清 context + 換 model                │
│  4. /bmad-bmm-sprint-status  [Opus 4.6]    │
│     ↓ 如果還有 story → 回到 1              │
└─────────────────────────────────────────────┘
```

每次 story 循環中的 model 切換：

- **create-story → dev-story**：Opus 4.6 → Sonnet 4.6（開新 chat + 換 model）
- **dev-story → code-review**：Sonnet 4.6 → Codex 5.3（開新 chat + 換 model）
- **code-review → sprint-status**：Codex 5.3 → Opus 4.6（開新 chat + 換 model）
- **sprint-status → create-story**（下一個 story）：維持 Opus 4.6（僅開新 chat）

### Code Review 未通過時

自動處理：
1. 將 review 問題記錄到決策日誌
2. commit review 結果
3. 提示切換至 Sonnet 4.6 → 開新 chat → `/sdd-flow` 會自動偵測到需要修復並執行 dev-story
4. 修復後再次提示切換 Codex 5.3 做 review

---

## 進度偵測（自動恢復）

每次 `/sdd-flow` 啟動時，自動掃描以下位置判斷進度：

| 檢查項目 | 路徑 | 對應完成步驟 |
| --- | --- | --- |
| Product Brief | `_bmad-output/planning-artifacts/*brief*` | ① ~ ⑤ |
| PRD | `_bmad-output/planning-artifacts/*prd*` | ⑥ |
| UX Design | `_bmad-output/planning-artifacts/*ux*` | ⑨ |
| Architecture | `_bmad-output/planning-artifacts/*architecture*` | ⑩ |
| Epics & Stories | `_bmad-output/planning-artifacts/*epic*` | ⑪ |
| Readiness Report | `_bmad-output/planning-artifacts/*readiness*` | ⑫ |
| Sprint Status | `_bmad-output/implementation-artifacts/sprint-status.yaml` | ⑬ |
| Story Files | `_bmad-output/implementation-artifacts/stories/` | ⑮⑯⑰ |

根據偵測結果，自動跳到下一個未完成的步驟。如果偵測到 sprint-status.yaml 存在，直接用 `/bmad-bmm-sprint-status` 的 data mode 取得精確的 next action。

---

## 注意事項

- 每個步驟在**獨立新 chat** 中執行，確保 context 乾淨
- Model 切換在開新 chat **之前**完成
- **Autopilot 不等於不檢查** — 所有決策都記錄在 `_bmad-output/sdd-decisions.md` 和 git commit message 中，使用者應定期 review
- Optional 步驟在 autopilot 模式下**自動跳過**，除非使用者明確要求執行
- Required（★）步驟不可跳過
- 如果需要回顧所有自動決策：`git log --grep='sdd-flow'` 或查看 `_bmad-output/sdd-decisions.md`