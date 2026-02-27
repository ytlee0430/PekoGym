# SDD Flow 決策日誌

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
