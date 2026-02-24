---
stepsCompleted: ['step-01-init', 'step-02-discovery', 'step-03-success', 'step-04-journeys', 'step-05-domain', 'step-06-innovation', 'step-07-project-type', 'step-08-scoping', 'step-09-functional', 'step-10-nonfunctional', 'step-11-polish', 'step-12-complete']
completedAt: '2026-02-17'
inputDocuments: ['spec.md']
workflowType: 'prd'
project_name: 'IronMon'
user_name: 'Bruce'
date: '2026-02-16'
documentCounts:
  briefs: 0
  research: 0
  brainstorming: 0
  projectDocs: 0
  otherInputs: 1
classification:
  projectType: 'mobile_app'
  domain: 'gaming_fitness'
  complexity: 'medium-high'
  projectContext: 'greenfield'
---

# Product Requirements Document - IronMon

**Author:** Bruce
**Date:** 2026-02-16

## Executive Summary

**IronMon** 是一款將健身訓練遊戲化的 RPG Mobile App。核心理念：「訓練即戰鬥，進步即升級」。

**Product Differentiator：** 將健身科學核心概念（漸進式超負荷、強度閾值、訓練容量）結構性映射為 RPG 遊戲機制（進化系統、破防門檻、HP 削減）。不同於 Fitocracy 的徽章系統或 Habitica 的待辦事項 RPG，IronMon 的遊戲機制本身就是健身科學。

**Target Users：** 有固定健身習慣的中級訓練者，對寶可夢有情懷，平常用 Strong App 記錄但覺得無聊。不設限——新手受吸引也歡迎。

**Tech Stack：** Flutter (Dart) + Riverpod + Isar（離線優先）。MVP 階段無雲端依賴，iOS TestFlight 發布。

**Project Context：** Greenfield side project，solo developer（Bruce），dogfooding 驗證。

## Success Criteria

### User Success

- **核心 Aha Moment：** 使用者突破個人 PR，觸發進化動畫時感受到「我真的變強了」的成就感
- **回訪動力：** 使用者因想打贏下一個道館主、解鎖新招式、或突破 PR 而主動回到健身房
- **習慣建立：** 使用者將「開 IronMon → 去健身房」建立為固定行為模式
- **直覺操作：** 第一場戰鬥即理解「輸入重量/次數 → 造成傷害 → 打倒 Boss」核心迴路，無需教學

### Business Success

- **定位：** Side project / Passion project，不以商業化為目標
- **品質指標：** 自己和朋友會真正想用來健身的 App
- **技術資產：** 可擴展的戰鬥引擎和訓練追蹤系統，未來有商業化潛力時能快速迭代

### Technical Success

- **離線優先：** 健身房無網路環境下完整戰鬥 + 訓練紀錄功能正常運作
- **數值平衡：** 傷害公式經驗證——輕重量打力量道館確實不破防，多次數打體格道館確實有效
- **狀態穩定：** 戰鬥 State Machine 在任何中斷（App 切背景、來電）後能正確恢復

### Measurable Outcomes

- 一場完整 3 階段戰鬥可在一次健身 session（45-90 分鐘）內完成
- 漸進式超負荷偵測準確觸發（Epley 公式與實際 PR 吻合）
- 屬性相剋系統覆蓋 5 大肌群 × 對應屬性

## Product Scope

### MVP Feature Set

**MVP Approach：** Experience MVP — 驗證「健身 = 戰鬥」的核心體驗是否有趣
**Resource：** Solo developer（Bruce），dogfooding 驗證
**發布管道：** iOS TestFlight

**Must-Have Capabilities：**

| # | 功能 | 理由 |
|---|---|---|
| 1 | 5RM Onboarding（含初學者模式） | 沒有基準值就無法計算傷害 |
| 2 | 傷害計算引擎 | 核心遊戲邏輯 |
| 3 | 3 階段戰鬥流程 | 核心體驗迴路 |
| 4 | 力量道館 & 體格道館 | USP 的具體表現 |
| 5 | 屬性相剋系統（5 屬性） | 讓「今天練什麼」有意義 |
| 6 | 經驗值 & 升級系統 | 長期留存動力 |
| 7 | 招式解鎖 & 進化鏈 | Aha moment 的載體 |
| 8 | 招式圖鑑 | 收集驅動力 |
| 9 | PR 偵測 & 進化動畫 | **核心 aha moment** |
| 10 | 手動 RPE 輸入（替代心率） | 心率加成的 MVP 替代方案 |
| 11 | 戰鬥失敗 + 部分獎勵 | 容錯，防止挫敗感 |
| 12 | Isar 本地儲存 | 離線優先 |
| 13 | 震動回饋 | 戰鬥手感 |

**Core User Journeys Supported：** 阿凱的覺醒、小美的冒險、阿凱的挫敗與恢復

### Post-MVP Roadmap

**Phase 2（Near-term）：**
- 道具系統（Potion / Ether / Rare Candy）
- 訓練排程演算法（自動推薦道館）
- 訓練歷史回顧 & 統計報表
- 戰鬥 BGM & 音效完善

**Phase 3（Growth）：**
- 穿戴裝置整合（HealthKit / Health Connect）
- 即時心率 HUD & Zone 加成
- Firebase 雲端同步 & 帳號系統

**Phase 4（Vision）：**
- 排行榜 & 社交功能
- 團體戰（Raid Battles）
- 教練模式
- 瑜珈塔、選美大會等延伸系統

### Risk Mitigation

| 風險類型 | 風險 | 緩解策略 |
|---|---|---|
| Technical | 戰鬥 State Machine 中斷恢復 | Isar 持久化戰鬥狀態 |
| Technical | 數值平衡 | Dart unit test 先驗證公式，再接 UI |
| Market | 核心假設不成立 | Dogfooding 一個月驗證 |
| Market | 輸入流程打斷節奏 | 預填數據 + 快速 +/- 按鈕 |
| Resource | Solo developer 時間不足 | 可再砍招式圖鑑，只保留戰鬥 + 升級 + 進化 |

## User Journeys

### Journey 1：阿凱的覺醒（核心用戶 — 中級訓練者，Success Path）

**阿凱，28 歲，軟體工程師。** 健身三年，每週練四天 Push/Pull/Legs，深蹲 5RM 120kg。手機裡有 Strong App，每次訓練都認真記錄，但最近打開 App 的感覺跟打開 Excel 一樣——只是在填表格。PR 已經三個月沒動了，不是不夠努力，而是缺少那股「再拼一下」的衝勁。

**Opening Scene：** 阿凱在 App Store 看到 IronMon，像素風戰鬥畫面讓他想起小時候玩寶可夢。下載後 Onboarding 輸入深蹲 120kg、臥推 90kg、硬舉 140kg、肩推 55kg 的 5RM，選擇每週訓練 4 次。

**Rising Action：** 練胸日。IronMon 推薦草系道館。第一階段——綠毛蟲，輕重量伏地挺身輕鬆解決。第二階段——妙蛙草，血量超厚，70kg 臥推 4 組 × 10 下看著血條被削，不自覺多做了第 5 組。第三階段選了力量道館——大鋼蛇，防禦極高。85kg 一組 8 下——「It's not very effective...」。加到 95kg，一組 3 下——爆擊！血條終於動了。

**Climax：** 最後一組，92.5kg 想做 5 下。第 5 下手在抖，想到「再一下就破防」，擠出第 6 下。畫面閃光——**「EVOLUTION! 臥推進化了！新 5RM：92.5kg × 6 = Est. 1RM 111kg！」**

**Resolution：** 走出健身房，App 顯示「你解鎖了新招式：上斜啞鈴臥推！」已經在想明天背日要挑戰什麼道館。三個月後，Strong App 被移到了最後一頁。

### Journey 2：小美的冒險（新手用戶 — Edge Case）

**小美，24 歲，行銷企劃。** 辦了健身房會員半年，去了不到 10 次。每次不知道要做什麼，在器材間晃來晃去很尷尬。

**Opening Scene：** Onboarding 要輸入 5RM，完全不知道能舉多重。App 提供「初學者模式」——從最輕重量開始，前幾次訓練自動校正基準值。初始招式：伏地挺身、徒手深蹲、彈力帶划船。

**Rising Action：** 第一場戰鬥，Lv.3 小拳石。徒手深蹲第一組 15 下——「哇，動作有意義！」第三組只撐 8 下——「Miss! 小拳石反擊！」HP 掉了一截。

**Climax：** 幾週後，第一次用空槓深蹲 5 下。系統解鎖「槓鈴深蹲」——從徒手深蹲進化。截圖發朋友：「我的招式進化了！」

**Resolution：** 不再在器材間迷路。IronMon 告訴她今天打什麼道館、用什麼招式。三個月後有了穩定訓練課表。

### Journey 3：阿凱的挫敗與恢復（核心用戶 — Error Recovery）

**同一個阿凱，但狀態很差。** 昨晚沒睡好，腿日挑戰電系道館。

**Rising Action：** 熱身還行，中 Boss 容量階段平常 100kg × 8 下今天只做 5 下就力竭。「Counter! HP -15%」。降重到 80kg 勉強過關。道館主選力量道館，110kg 只做 2 下——傷害不夠，Boss 剩 40% 血。

**Climax：** 戰鬥失敗。「You blacked out...」但緊接：「你仍然獲得了 60% 經驗值。今日訓練容量：2,400kg。」沒有懲罰——還是練了，只是沒贏。

**Resolution：** 隔天系統提示「上次腿日容量偏低，要不要挑戰體格道館？」選了體格道館，85kg × 5 組 × 8 下輕鬆通關。明白了——不是每天都要挑戰極限，堆容量也是一種「贏」。

### Journey 4：教練阿明的觀察（潛在 Secondary User — Post-MVP）

**阿明，32 歲，私人教練。** 學員開始用 IronMon 後訓練出席率明顯提高。自己試用後覺得力量道館的「不破防」機制完美詮釋「強度閾值」概念。但 MVP 沒有教練功能——無法幫學員設定計畫或查看數據。繼續推薦學員自行使用，期待未來教練模式。

### Journey Requirements Summary

| 旅程 | 揭示的核心能力需求 |
|---|---|
| 阿凱的覺醒 | 完整戰鬥流程、PR 偵測、進化動畫、招式解鎖 |
| 小美的冒險 | 初學者引導、自動校正 5RM、基礎招式進化鏈、容錯設計 |
| 阿凱的挫敗 | 戰鬥失敗機制、部分獎勵、訓練歷史回顧 |
| 教練阿明 | （Post-MVP）教練模式、多用戶數據查看 |

## Innovation & Novel Patterns

### Detected Innovation Areas

- **健身科學 × RPG 的直接映射：** 將漸進式超負荷、強度閾值、訓練容量結構性對應為進化系統、破防門檻、HP 削減
- **力量道館 vs 體格道館雙模式：** 用遊戲語言解釋 Strength vs Hypertrophy training 的本質差異

### Competitive Landscape

| 競品 | 做法 | IronMon 的差異 |
|---|---|---|
| Fitocracy | 動作完成 → 發徽章 | 實際重量/次數 → 計算傷害 |
| Habitica | 待辦事項 → RPG | 不理解健身數據 |
| Ring Fit Adventure | 體感動作 → 遊戲 | 非重量訓練 |
| Strong App | 純紀錄工具 | 無遊戲化 |

### Validation & Risk

- **驗證方式：** Dogfooding。成功信號：持續使用超過一個月，感覺比純紀錄 App 更有動力
- **核心風險：** 每組輸入可能打斷訓練節奏 → 預填上一組數據、快速 +/- 2.5kg 按鈕、大按鈕設計（戴手套可操作）

## Mobile App Specific Requirements

### Platform & Distribution

- Framework：Flutter (Dart)，MVP 優先 iOS（TestFlight）
- 最低支援：iOS 15+
- Android：MVP 不優先，Flutter 跨平台可保留

### Offline Architecture

- 完整離線運作：戰鬥、訓練紀錄、PR 偵測全部本地完成
- Local Storage：Isar database
- 無雲端依賴（MVP 階段）

### Device Features

- Haptic Feedback：攻擊命中、爆擊、進化觸發時提供觸覺反饋
- Audio：8-bit 戰鬥音效、進化 Jingle（需合法授權素材）
- 螢幕常亮：戰鬥進行中防止螢幕休眠

### UX Constraints

- 每組訓練輸入 <5 秒完成
- 預填上一組重量/次數
- 快速 +/- 2.5kg 按鈕
- 大按鈕設計（戴手套也能操作）

## Functional Requirements

### Onboarding & Calibration

- **FR1:** 使用者可以輸入核心動作（深蹲、臥推、硬舉、肩推）的 5RM 數值來建立基準
- **FR2:** 使用者可以選擇「初學者模式」，系統透過前 3-5 次訓練自動校正 5RM 基準值
- **FR3:** 使用者可以設定每週訓練頻率

### Battle System（戰鬥系統）

- **FR4:** 使用者可以選擇今日訓練的肌群/屬性來進入對應道館
- **FR5:** 使用者可以選擇道館類型（力量道館或體格道館）來決定 Boss 數值分配
- **FR6:** 系統根據道館類型和肌群屬性自動生成 3 階段敵人陣容（Minion → Mid-Boss → Gym Leader）
- **FR7:** 使用者可以在戰鬥中選擇招式來對敵人發動攻擊
- **FR8:** 使用者可以為每組訓練輸入實際負重和次數
- **FR9:** 系統根據傷害計算公式即時計算並顯示每組造成的傷害
- **FR10:** 系統根據屬性相剋關係調整傷害倍率（Super Effective 1.5x / Not Effective 0.5x）
- **FR11:** 力量道館中，系統判定單發傷害低於 Boss 防禦值時顯示「攻擊無效」
- **FR12:** 使用者可以輸入自覺疲勞度（RPE 1-10）作為心率 Zone 的替代方案
- **FR13:** 系統根據 RPE 值套用對應的傷害加成倍率（RPE 6-7: 1.0x、RPE 8: 1.2x、RPE 9-10: 1.5x）

### Battle Outcomes（戰鬥結算）

- **FR14:** 系統在 Boss HP 歸零時判定戰鬥勝利並進入結算
- **FR15:** 系統在玩家 HP 歸零時判定戰鬥失敗，並給予部分經驗值（60%）
- **FR16:** 使用者在戰鬥中該組完成次數低於前一組次數或系統建議次數時，系統判定為力竭（Miss/Counter）並扣減玩家 HP
- **FR17:** 系統在戰鬥結束後顯示本次訓練的總容量、傷害統計、獲得經驗值

### Progression System（成長系統）

- **FR18:** 系統根據戰鬥表現計算並授予經驗值
- **FR19:** 使用者累積足夠經驗值時自動升級，提升角色基礎屬性
- **FR20:** 系統使用 Epley 公式偵測使用者是否突破現有 5RM 紀錄
- **FR21:** 系統在偵測到 PR 突破時觸發進化動畫並更新 5RM 基準值
- **FR22:** 使用者透過升級或擊敗道館主解鎖新招式
- **FR23:** 招式沿進化鏈升級（例：伏地挺身 → 槓鈴臥推 → 啞鈴上斜臥推）

### Move Pokédex（招式圖鑑）

- **FR24:** 使用者可以瀏覽所有招式的列表，區分已解鎖/未解鎖狀態
- **FR25:** 使用者可以查看每個招式的詳情（屬性、威力、PP 消耗、進化鏈、使用次數、PR 紀錄）

### Type Effectiveness（屬性系統）

- **FR26:** 系統維護 5 大肌群對應 5 種屬性的相剋關係表
- **FR27:** 系統根據招式屬性和敵人屬性自動計算並套用傷害倍率

### Data Persistence（數據儲存）

- **FR28:** 系統在本地儲存使用者的完整訓練歷史（日期、道館類型、肌群、容量、結果）
- **FR29:** 系統在本地儲存使用者的角色狀態（等級、經驗值、屬性、5RM、已解鎖招式）
- **FR30:** 系統在戰鬥中途中斷（App 切背景、來電）後可恢復戰鬥狀態

### Feedback & Haptics（回饋系統）

- **FR31:** 系統在攻擊命中時提供震動回饋
- **FR32:** 系統在爆擊、進化、升級等關鍵事件時提供強化震動回饋
- **FR33:** 系統在戰鬥中即時顯示傷害數字和 Boss HP 變化動畫

## Non-Functional Requirements

### Performance

- **NFR1:** 傷害計算完成時間 <16ms（一幀內，確保動畫不卡頓）
- **NFR2:** 戰鬥畫面維持穩定 60fps
- **NFR3:** 每組訓練輸入到傷害顯示的端對端延遲 <200ms
- **NFR4:** 本地資料庫查詢回應時間 <200ms
- **NFR5:** App cold start 時間 <3 秒
- **NFR6:** 進化動畫完整播放不掉幀

### Reliability

- **NFR7:** 戰鬥狀態在 App 切背景後 100% 可恢復
- **NFR8:** 訓練數據零丟失——每組輸入確認後立即寫入本地儲存
- **NFR9:** App crash 後重啟可恢復到最近一組完成的戰鬥狀態
- **NFR10:** 5RM 基準值更新為不可分割操作——進化觸發時不會因中斷導致數據不一致
