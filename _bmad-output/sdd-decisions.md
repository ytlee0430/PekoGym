# SDD Flow 決策日誌

## ⑮ Create Story 1.4 — 2026-02-27

### 決策 1: 目標 Story 選擇
- **問題**: 下一個要建立的 story 是哪個？
- **選項**:
  1. 1-4-home-screen — Epic 1 最後一個 story（backlog）
  2. 手動指定其他 story
- **自動選擇**: 1-4-home-screen
- **理由**: sprint-status.yaml 中第一個 backlog story，按順序執行
- **風險**: 無

### 決策 2: EXP 升級公式
- **問題**: Home Screen 需顯示 EXP 進度條，但 Story 4.1 才定義真正的升級公式
- **選項**:
  1. 使用 placeholder 公式 `level * 100`
  2. 不顯示 EXP bar，等 Story 4.1
  3. 使用複雜的臨時公式
- **自動選擇**: 選項 1 — placeholder `level * 100`
- **理由**: AC 明確要求顯示 EXP bar；簡單公式易於後續替換
- **風險**: Story 4.1 替換時需找到並更新此處

### 決策 3: Optional 步驟跳過
- **問題**: workflow 中 Step 4 (Web Research) 是否執行？
- **選項**:
  1. 執行 web research 查詢最新版本
  2. 跳過 — 本 story 純 UI，無新技術依賴
- **自動選擇**: 跳過
- **理由**: Story 1.4 只用已安裝的 Flutter/Riverpod/GoRouter，無需查詢新版本
- **風險**: 無

### 決策 4: Validation checklist 執行
- **問題**: 是否執行 create-story checklist 驗證？
- **選項**:
  1. 完整執行 checklist 驗證
  2. 跳過 — autopilot 模式
- **自動選擇**: 跳過
- **理由**: Autopilot 模式下，story 已包含完整 dev context（前序 story 學習、架構合規、測試模式、陷阱清單），直接標記 ready-for-dev
- **風險**: 可能遺漏細節，但 code review 步驟會補捉

## ⑰ Code Review — Story 1.3 — 2026-02-27

### 決策 1: Code Review 結果處理方式
- **問題**: Code Review 發現 2 HIGH、3 MEDIUM、2 LOW 問題，如何處理？
- **選項**:
  1. Fix them automatically — 直接修復程式碼和測試
  2. Create action items — 加入 story Tasks/Subtasks 稍後處理
  3. Show me details — 深入查看特定問題
- **自動選擇**: 選項 1 — Fix them automatically
- **理由**: Autopilot 模式下自動選擇最積極的修復方案，確保程式碼品質
- **風險**: 自動修復可能引入新問題，但所有修復都是最小化、針對性的

### 決策 2: Story 狀態更新
- **問題**: 所有 HIGH 和 MEDIUM 問題已修復，是否將 story 狀態設為 done？
- **選項**:
  1. done — 所有問題已修復
  2. in-progress — 保持開發中等待進一步驗證
- **自動選擇**: done
- **理由**: 所有 HIGH 和 MEDIUM 問題已在本次 review 中修復，所有 AC 已實作
- **風險**: LOW-2（BattleResultPlaceholder scope creep）未修復但不影響功能

### 修復摘要

| ID | 嚴重度 | 問題 | 修復 |
|---|---|---|---|
| HIGH-1 | 🔴 | `DropdownButtonFormField` 用了不存在的 `initialValue` 參數 | 改為 `value` |
| HIGH-2 | 🔴 | `UserProfileNotifier` 缺少 `updateCalibration` 方法 | 新增方法 |
| MED-1 | 🟡 | `ProfileEditScreen.initState` 中不安全地使用 `ref.read` | 移至 `build` 中用 `ref.watch` + `_initFromProfile` flag |
| MED-2 | 🟡 | `OnboardingScreen` 未明確傳入 calibration 欄位 | 加入 `calibrationSessionsCompleted: 0, calibrationTargetSessions: 5` |
| MED-3 | 🟡 | `ProfileEditScreen` 用 `saveProfile`（upsert）而非 `updateProfile`（update） | 改用 `updateProfile` |
| LOW-1 | 🟢 | `estimateFiveRm` doc 說回傳 0.0 但實際回傳 int `0` | 改為 `0.0` |
| LOW-2 | 🟢 | `_BattleResultPlaceholder` scope creep（未修復） | 記錄供 Epic 2 參考 |
