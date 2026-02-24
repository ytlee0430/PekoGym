---
stepsCompleted: [1, 2, 3, 4, 5, 6]
status: 'complete'
completedAt: '2026-02-19'
inputDocuments: ['_bmad-output/planning-artifacts/prd.md', '_bmad-output/planning-artifacts/architecture.md', '_bmad-output/planning-artifacts/epics.md']
workflowType: 'implementation-readiness'
project_name: 'IronMon'
user_name: 'Bruce'
date: '2026-02-19'
---

# Implementation Readiness Assessment Report

**Date:** 2026-02-19
**Project:** IronMon

## Document Discovery

### PRD Files Found

**Whole Documents:**
- `prd.md` — PRD 主文件（完成，12 步驟全通過）
- `prd-validation-report.md` — PRD 驗證報告（參考文件，非評估目標）

**Sharded Documents:** 無

### Architecture Files Found

**Whole Documents:**
- `architecture.md` — 架構決策文件（完成，8 步驟全通過）

**Sharded Documents:** 無

### Epics & Stories Files Found

**Whole Documents:**
- `epics.md` — Epics & Stories（完成，4 步驟全通過，5 Epics / 22 Stories）

**Sharded Documents:** 無

### UX Design Files Found

**⚠️ WARNING:** UX Design 文件不存在。MVP 階段可接受，PRD 中的 User Journeys 和 UX Constraints 提供基本 UI 方向。

### Issues Found

- 無重複文件
- UX Design 缺失（non-blocking for MVP）

## PRD Analysis

### Functional Requirements

FR1: 使用者可以輸入核心動作（深蹲、臥推、硬舉、肩推）的 5RM 數值來建立基準
FR2: 使用者可以選擇「初學者模式」，系統透過前 3-5 次訓練自動校正 5RM 基準值
FR3: 使用者可以設定每週訓練頻率
FR4: 使用者可以選擇今日訓練的肌群/屬性來進入對應道館
FR5: 使用者可以選擇道館類型（力量道館或體格道館）來決定 Boss 數值分配
FR6: 系統根據道館類型和肌群屬性自動生成 3 階段敵人陣容（Minion → Mid-Boss → Gym Leader）
FR7: 使用者可以在戰鬥中選擇招式來對敵人發動攻擊
FR8: 使用者可以為每組訓練輸入實際負重和次數
FR9: 系統根據傷害計算公式即時計算並顯示每組造成的傷害
FR10: 系統根據屬性相剋關係調整傷害倍率（Super Effective 1.5x / Not Effective 0.5x）
FR11: 力量道館中，系統判定單發傷害低於 Boss 防禦值時顯示「攻擊無效」
FR12: 使用者可以輸入自覺疲勞度（RPE 1-10）作為心率 Zone 的替代方案
FR13: 系統根據 RPE 值套用對應的傷害加成倍率（RPE 6-7: 1.0x、RPE 8: 1.2x、RPE 9-10: 1.5x）
FR14: 系統在 Boss HP 歸零時判定戰鬥勝利並進入結算
FR15: 系統在玩家 HP 歸零時判定戰鬥失敗，並給予部分經驗值（60%）
FR16: 使用者在戰鬥中該組完成次數低於前一組次數或系統建議次數時，系統判定為力竭（Miss/Counter）並扣減玩家 HP
FR17: 系統在戰鬥結束後顯示本次訓練的總容量、傷害統計、獲得經驗值
FR18: 系統根據戰鬥表現計算並授予經驗值
FR19: 使用者累積足夠經驗值時自動升級，提升角色基礎屬性
FR20: 系統使用 Epley 公式偵測使用者是否突破現有 5RM 紀錄
FR21: 系統在偵測到 PR 突破時觸發進化動畫並更新 5RM 基準值
FR22: 使用者透過升級或擊敗道館主解鎖新招式
FR23: 招式沿進化鏈升級（例：伏地挺身 → 槓鈴臥推 → 啞鈴上斜臥推）
FR24: 使用者可以瀏覽所有招式的列表，區分已解鎖/未解鎖狀態
FR25: 使用者可以查看每個招式的詳情（屬性、威力、PP 消耗、進化鏈、使用次數、PR 紀錄）
FR26: 系統維護 5 大肌群對應 5 種屬性的相剋關係表
FR27: 系統根據招式屬性和敵人屬性自動計算並套用傷害倍率
FR28: 系統在本地儲存使用者的完整訓練歷史（日期、道館類型、肌群、容量、結果）
FR29: 系統在本地儲存使用者的角色狀態（等級、經驗值、屬性、5RM、已解鎖招式）
FR30: 系統在戰鬥中途中斷（App 切背景、來電）後可恢復戰鬥狀態
FR31: 系統在攻擊命中時提供震動回饋
FR32: 系統在爆擊、進化、升級等關鍵事件時提供強化震動回饋
FR33: 系統在戰鬥中即時顯示傷害數字和 Boss HP 變化動畫

**Total FRs: 33**

### Non-Functional Requirements

NFR1: 傷害計算完成時間 <16ms（一幀內，確保動畫不卡頓）
NFR2: 戰鬥畫面維持穩定 60fps
NFR3: 每組訓練輸入到傷害顯示的端對端延遲 <200ms
NFR4: 本地資料庫查詢回應時間 <200ms
NFR5: App cold start 時間 <3 秒
NFR6: 進化動畫完整播放不掉幀
NFR7: 戰鬥狀態在 App 切背景後 100% 可恢復
NFR8: 訓練數據零丟失——每組輸入確認後立即寫入本地儲存
NFR9: App crash 後重啟可恢復到最近一組完成的戰鬥狀態
NFR10: 5RM 基準值更新為不可分割操作——進化觸發時不會因中斷導致數據不一致

**Total NFRs: 10**

### Additional Requirements

- **PRD 技術約束：** Flutter (Dart)、iOS 15+、TestFlight 發布、完整離線運作、Isar database
- **UX 約束：** 每組訓練輸入 <5 秒、預填上一組數據、+/- 2.5kg 快速按鈕、大按鈕設計（戴手套可操作）
- **Device Features：** Haptic Feedback、8-bit 音效、螢幕常亮（戰鬥中）
- **PRD 明確排除：** 雲端同步、帳號系統、教練模式、團體戰、排行榜（全部 Post-MVP）

### PRD Completeness Assessment

- ✅ 33 FRs 全部清晰、可測試、有明確編號
- ✅ 10 NFRs 全部有量化指標
- ✅ PRD 已通過完整驗證（4/5 Good，7/7 BMAD principles）
- ✅ 無遺漏的功能需求
- ⚠️ PRD 中 FR2「前 3-5 次訓練」的具體校正演算法未定義（實作時需細化）

## Epic Coverage Validation

### Coverage Matrix

| FR | PRD 需求摘要 | Epic 覆蓋 | Story | 狀態 |
|-----|------------|----------|-------|------|
| FR1 | 輸入 5RM 建立基準 | Epic 1 | 1.2 | ✅ Covered |
| FR2 | 初學者模式自動校正 | Epic 1 | 1.3 | ✅ Covered |
| FR3 | 設定訓練頻率 | Epic 1 | 1.2 | ✅ Covered |
| FR4 | 選擇肌群進入道館 | Epic 2 | 2.3 | ✅ Covered |
| FR5 | 選擇道館類型 | Epic 2 | 2.3 | ✅ Covered |
| FR6 | 生成 3 階段敵人 | Epic 2 | 2.3 | ✅ Covered |
| FR7 | 戰鬥中選擇招式 | Epic 2 | 2.5 | ✅ Covered |
| FR8 | 輸入負重和次數 | Epic 2 | 2.5 | ✅ Covered |
| FR9 | 傷害計算與顯示 | Epic 2 | 2.4 | ✅ Covered |
| FR10 | 屬性相剋倍率 | Epic 2 | 2.4 | ✅ Covered |
| FR11 | 力量道館破防判定 | Epic 2 | 2.4 | ✅ Covered |
| FR12 | RPE 輸入 | Epic 2 | 2.5 | ✅ Covered |
| FR13 | RPE 傷害加成 | Epic 2 | 2.4 | ✅ Covered |
| FR14 | 勝利判定 | Epic 3 | 3.1 | ✅ Covered |
| FR15 | 失敗 + 60% EXP | Epic 3 | 3.1 + 3.3 | ✅ Covered |
| FR16 | 力竭/Counter | Epic 3 | 3.1 | ✅ Covered |
| FR17 | 戰鬥結算統計 | Epic 3 | 3.2 | ✅ Covered |
| FR18 | EXP 計算 | Epic 3 | 3.3 | ✅ Covered |
| FR19 | 升級系統 | Epic 4 | 4.1 | ✅ Covered |
| FR20 | PR 偵測（Epley） | Epic 4 | 4.2 | ✅ Covered |
| FR21 | 進化動畫 + 5RM 更新 | Epic 4 | 4.3 | ✅ Covered |
| FR22 | 招式解鎖 | Epic 4 | 4.4 | ✅ Covered |
| FR23 | 招式進化鏈 | Epic 4 | 4.4 | ✅ Covered |
| FR24 | 招式列表瀏覽 | Epic 5 | 5.1 | ✅ Covered |
| FR25 | 招式詳情 | Epic 5 | 5.2 | ✅ Covered |
| FR26 | 屬性相剋表 | Epic 2 | 2.1 | ✅ Covered |
| FR27 | 屬性傷害倍率計算 | Epic 2 | 2.1 | ✅ Covered |
| FR28 | 訓練歷史儲存 | Epic 3 | 3.4 | ✅ Covered |
| FR29 | 角色狀態儲存 | Epic 1 | 1.2 | ✅ Covered |
| FR30 | 戰鬥狀態恢復 | Epic 2 | 2.7 | ✅ Covered |
| FR31 | 攻擊震動回饋 | Epic 3 | 3.5 | ✅ Covered |
| FR32 | 關鍵事件強化震動 | Epic 3 | 3.5 | ✅ Covered |
| FR33 | 傷害數字動畫 | Epic 2 | 2.6 | ✅ Covered |

### Missing Requirements

**Critical Missing FRs：** 0
**High Priority Missing FRs：** 0

### Coverage Statistics

- Total PRD FRs: 33
- FRs covered in epics: 33
- Coverage percentage: **100%**

## UX Alignment Assessment

### UX Document Status

**Not Found** — 無 UX Design 文件。

### UX Implied Assessment

IronMon 是使用者直接操作的 Mobile App，UI/UX 是核心體驗的關鍵部分：
- PRD 包含 4 條 User Journeys（阿凱的覺醒、小美的冒險、阿凱的挫敗、教練阿明）
- PRD「Mobile App Specific Requirements」章節定義了 UX Constraints（<5秒輸入、預填數據、+/-2.5kg、大按鈕）
- PRD「Feedback & Haptics」章節定義了觸覺和視覺回饋需求（FR31-FR33）
- Architecture 定義了像素風 UI（CustomPainter）、Material 3 主題、動畫策略（RepaintBoundary、AnimatedBuilder）

### Alignment Issues

**無嚴重對齊問題。** PRD 中的 UX Constraints 和 Architecture 的 Presentation 層設計一致。

### Warnings

- ⚠️ **UX Design 文件缺失：** 雖然 PRD 提供了基本 UI 方向，但缺少具體的 wireframes、screen flows、interaction patterns。對於像素風戰鬥畫面、進化動畫、Boss HP bar 等核心視覺體驗，開發時需額外設計決策。
- ⚠️ **建議：** Post-MVP 或 Sprint 1 開始前考慮補充 UX Design（`/bmad:bmm:workflows:create-ux-design`），特別是戰鬥畫面和 set input panel 的 wireframe。
- ℹ️ **MVP 可接受：** Solo developer dogfooding 場景下，邊開發邊迭代 UI 是合理策略。

## Epic Quality Review

### Best Practices Compliance Checklist

| Epic | 使用者價值 | 獨立可用 | Story 大小適當 | 無前向依賴 | DB 按需建立 | AC 清晰 | FR 可追溯 |
|------|----------|---------|-------------|----------|-----------|--------|----------|
| Epic 1 | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ |
| Epic 2 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Epic 3 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Epic 4 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Epic 5 | ✅ | ✅ | ✅ | ✅ | N/A | ✅ | ✅ |

### 🔴 Critical Violations

**無。** 所有 Epic 以使用者價值組織，無技術層面的 Epic。

### 🟠 Major Issues（1 項）

**Issue #1: Story 1.3 (Beginner Mode) 存在跨 Epic 前向依賴**

Story 1.3 的 AC 聲明：「after each calibration session, the system updates estimated 5RM using recorded set data」和「after calibration completes, the profile transitions to normal mode with finalized 5RM values」。

**問題：** 「calibration session」需要實際訓練數據（weight/reps），但訓練數據的記錄功能在 Epic 2（FR8）才實作。因此 Story 1.3 無法在 Epic 1 範圍內端對端測試校正流程。

**建議修正：** 將 Story 1.3 範圍縮小為：
- ✅ 選擇 Beginner Mode
- ✅ 設定預設最低 5RM 值
- ✅ 將 profile 標記為 "calibrating"
- ✅ 定義校正邏輯的 domain layer API（Pure Dart）
- ✅ 單元測試校正演算法（輸入模擬 set data → 輸出更新的 5RM）
- ❌ 移除「after each calibration session」的端對端 AC → 改為 Epic 3 Story 3.4 的附加 AC（當訓練歷史寫入時觸發校正檢查）

**嚴重程度：** 🟠 Major — 不影響其他 Stories，但 Story 1.3 的 AC 如現狀寫法會讓 dev agent 嘗試實作尚不存在的功能。

### 🟡 Minor Concerns（3 項）

**Concern #1: Story 1.1 是 Developer Story，非 User Story**
Story 1.1 用 "As a developer" 而非 "As a player"。這在 greenfield 項目中是可接受的例外（Architecture 明確要求此 Story），但需注意這是唯一允許的技術 Story。
**嚴重程度：** 🟡 Minor — 已知且可接受。

**Concern #2: Stories 2.1 和 2.2 的使用者價值較間接**
Story 2.1（Type Effectiveness System）和 2.2（Move Registry）是 domain 基礎設施。雖然用 "As a player" 包裝，但使用者無法直接感知這些功能，其價值透過 Story 2.3-2.5 才顯現。
**嚴重程度：** 🟡 Minor — domain-heavy 項目中的常見模式，Stories 2.3-2.6 的 AC 會覆蓋端對端驗證。

**Concern #3: 部分 NFR 缺少明確的 Story-level AC**
NFR3（<200ms 端對端延遲）未在任何 Story AC 中明確出現。NFR2（60fps）僅在 Story 2.6 提及。建議在 Story 2.5 或 2.6 補充 NFR3 的驗證 AC。
**嚴重程度：** 🟡 Minor — NFR3 可在整合測試階段驗證，不阻塞開發。

### Epic Independence Validation

| 測試 | 結果 |
|------|------|
| Epic 1 獨立運作 | ✅ 完成後有完整的 onboarding + home screen |
| Epic 2 不需 Epic 3 | ✅ 戰鬥可進行但沒有結算/獎勵（可用 placeholder result） |
| Epic 3 不需 Epic 4 | ✅ 戰鬥有結算和 EXP，但沒有升級/進化 |
| Epic 4 不需 Epic 5 | ✅ 進化和解鎖功能完整，不需圖鑑 |
| Epic 5 不需後續 | ✅ 純展示層 |

### Story Dependency Flow（within-epic）

**Epic 1：** 1.1 → 1.2 → 1.3 → 1.4 ✅ 全部正向
**Epic 2：** 2.1 → 2.2 → 2.3 → 2.4 → 2.5 → 2.6 → 2.7 ✅ 全部正向
**Epic 3：** 3.1 → 3.2 → 3.3 → 3.4 → 3.5 ✅ 全部正向
**Epic 4：** 4.1 → 4.2 → 4.3 → 4.4 ✅ 全部正向
**Epic 5：** 5.1 → 5.2 ✅ 全部正向

### Database Creation Timing

| Entity | 建立時機 | Story | 狀態 |
|--------|---------|-------|------|
| UserProfile | 首次需要時 | 1.2 | ✅ |
| BattleState | 首次需要時 | 2.7 | ✅ |
| WorkoutSession | 首次需要時 | 3.4 | ✅ |
| ExerciseSet | 首次需要時 | 3.4 | ✅ |

**無提前建立所有 tables 的問題。** ✅

### Starter Template Check

Architecture 指定 `flutter create --org com.ironmon --platforms ios ironmon`。
Story 1.1 正確實作此要求，包含 dependencies 安裝和目錄骨架建立。✅

## Summary and Recommendations

### Overall Readiness Status

**✅ READY** — 可進入 Phase 4 Implementation，附帶 1 項建議修正。

### Findings Summary

| 類別 | 🔴 Critical | 🟠 Major | 🟡 Minor | ⚠️ Warning |
|------|-----------|---------|---------|-----------|
| FR Coverage | 0 | 0 | 0 | 0 |
| UX Alignment | 0 | 0 | 0 | 1 |
| Epic Quality | 0 | 1 | 3 | 0 |
| **Total** | **0** | **1** | **3** | **1** |

### Critical Issues Requiring Immediate Action

**無 Critical Issues。**

### Major Issue — 建議在 Sprint Planning 前修正

**Story 1.3 (Beginner Mode) 前向依賴：** 校正邏輯的端對端 AC 依賴 Epic 2/3 的訓練數據記錄。建議將 Story 1.3 的 AC 縮限為「設定 beginner mode + 最低 5RM + 標記 calibrating + 校正演算法單元測試」，將實際觸發校正的 AC 移至 Epic 3 Story 3.4。

### Recommended Next Steps

1. **修正 Story 1.3 AC（建議，非必須）：** 縮小範圍，避免 dev agent 嘗試實作不存在的依賴
2. **進入 Sprint Planning：** 執行 `/bmad:bmm:workflows:sprint-planning` 產出 sprint-status.yaml
3. **開始 Story 循環：** Create Story → Validate Story → Dev Story → Code Review → 下一個 Story
4. **考慮 UX Design（可選）：** 在 Epic 2 開發前補充戰鬥畫面 wireframe，可大幅降低 UI 迭代次數

### Strengths

- **FR 覆蓋率 100%** — 33/33 FR 全數有明確 Story 對應
- **Architecture 對齊** — Epics 嚴格遵循架構文件的 domain boundary、data layer、state management 規範
- **Story 品質高** — 22 個 Stories 全部有 Given/When/Then AC，FR 可追溯性完整
- **依賴方向正確** — Epic 間和 Story 間無反向依賴
- **DB 按需建立** — 無提前建立所有 tables 的問題

### Final Note

本次評估共發現 5 個 issues（0 Critical、1 Major、3 Minor、1 Warning）。唯一的 Major issue（Story 1.3 前向依賴）可在 Sprint Planning 或 Create Story 階段快速修正。IronMon 的規劃文件品質優秀，三份核心文件（PRD、Architecture、Epics & Stories）之間的對齊度高，可以信心十足地進入實作階段。



