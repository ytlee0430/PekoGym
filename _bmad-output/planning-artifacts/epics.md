---
stepsCompleted: [1, 2, 3, 4]
status: 'complete'
completedAt: '2026-02-19'
inputDocuments: ['_bmad-output/planning-artifacts/prd.md', '_bmad-output/planning-artifacts/architecture.md']
workflowType: 'epics-and-stories'
project_name: 'IronMon'
user_name: 'Bruce'
date: '2026-02-18'
---

# IronMon - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for IronMon, decomposing the requirements from the PRD and Architecture into implementable stories.

## Requirements Inventory

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

### NonFunctional Requirements

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

### Additional Requirements

**From Architecture — Starter Template（影響 Epic 1 Story 1）：**
- `flutter create --org com.ironmon --platforms ios ironmon`
- 安裝核心 dependencies：flutter_riverpod、riverpod_annotation、isar、isar_flutter_libs、go_router、very_good_analysis、mocktail、build_runner
- 建立完整目錄骨架（domain/、data/、presentation/、providers/、router/）

**From Architecture — Data Layer：**
- Isar 混合策略：戰鬥即時數據用 Flat/Embedded，歷史紀錄用 IsarLinks
- 5 個 Isar Collections：UserProfile、WorkoutSession、ExerciseSet、BattleState、MoveDefinition
- 每次 BattlePhase 轉換需持久化 BattleState snapshot
- Mapper 層隔離 Isar Entity 與 Domain Model

**From Architecture — Domain Layer：**
- Pure Dart domain layer — 零 Flutter/Isar 依賴
- Battle Engine 使用 Sealed Class + Pattern Matching（Dart 3）
- BattlePhase: Idle → Warmup → MidBoss → GymLeader → Result
- DamageCalculator: Intensity × TypeMultiplier × RPEMultiplier（同步 <16ms）
- Result<T, E> type 錯誤處理

**From Architecture — Presentation Layer：**
- go_router 路由：/ → /battle → /battle/result → /pokedex → /pokedex/:moveId
- Riverpod select() 精確訂閱避免不必要 rebuild
- RepaintBoundary 隔離動畫重繪
- AnimatedBuilder 用於 Boss HP bar

**From Architecture — Static Data：**
- moves.json asset 檔案定義招式資料（屬性、威力、PP、進化鏈）
- 5×5 屬性相剋矩陣硬編碼於 TypeEffectiveness

### FR Coverage Map

| FR | Epic | 簡述 |
|-----|------|------|
| FR1 | Epic 1 | 輸入 5RM 建立基準 |
| FR2 | Epic 1 | 初學者模式自動校正 |
| FR3 | Epic 1 | 設定訓練頻率 |
| FR4 | Epic 2 | 選擇肌群/道館 |
| FR5 | Epic 2 | 選擇道館類型 |
| FR6 | Epic 2 | 生成 3 階段敵人 |
| FR7 | Epic 2 | 戰鬥中選擇招式 |
| FR8 | Epic 2 | 輸入負重和次數 |
| FR9 | Epic 2 | 傷害計算與顯示 |
| FR10 | Epic 2 | 屬性相剋倍率 |
| FR11 | Epic 2 | 力量道館破防判定 |
| FR12 | Epic 2 | RPE 輸入 |
| FR13 | Epic 2 | RPE 傷害加成 |
| FR14 | Epic 3 | 勝利判定 |
| FR15 | Epic 3 | 失敗 + 60% 經驗值 |
| FR16 | Epic 3 | 力竭/Counter 機制 |
| FR17 | Epic 3 | 戰鬥結算統計 |
| FR18 | Epic 3 | 經驗值計算 |
| FR19 | Epic 4 | 升級系統 |
| FR20 | Epic 4 | PR 偵測（Epley） |
| FR21 | Epic 4 | 進化動畫 |
| FR22 | Epic 4 | 招式解鎖 |
| FR23 | Epic 4 | 招式進化鏈 |
| FR24 | Epic 5 | 招式列表瀏覽 |
| FR25 | Epic 5 | 招式詳情查看 |
| FR26 | Epic 2 | 屬性相剋表 |
| FR27 | Epic 2 | 屬性傷害倍率計算 |
| FR28 | Epic 3 | 訓練歷史儲存 |
| FR29 | Epic 1 | 角色狀態儲存 |
| FR30 | Epic 2 | 戰鬥狀態恢復 |
| FR31 | Epic 3 | 攻擊震動回饋 |
| FR32 | Epic 3 | 關鍵事件強化震動 |
| FR33 | Epic 2 | 傷害數字動畫 |

## Epic List

### Epic 1: Project Foundation & Player Onboarding
使用者完成後可以：建立自己的訓練角色，設定 5RM 基準值，準備好進入戰鬥。
**FRs covered:** FR1, FR2, FR3, FR29
**Additional:** Architecture starter template 設定、目錄骨架、Isar schema、核心 dependencies

### Epic 2: Core Battle System
使用者完成後可以：選擇道館、發動攻擊、輸入每組訓練數據，即時看到傷害計算結果，體驗完整的屬性相剋和力量道館破防機制。
**FRs covered:** FR4, FR5, FR6, FR7, FR8, FR9, FR10, FR11, FR12, FR13, FR26, FR27, FR30, FR33

### Epic 3: Battle Outcomes & Rewards
使用者完成後可以：打完一場完整戰鬥（勝利或失敗），獲得經驗值，看到訓練統計摘要，感受觸覺回饋。
**FRs covered:** FR14, FR15, FR16, FR17, FR18, FR28, FR31, FR32

### Epic 4: Progression & Evolution
使用者完成後可以：升級角色、突破 PR 觸發進化動畫、解鎖新招式、體驗招式進化鏈。
**FRs covered:** FR19, FR20, FR21, FR22, FR23

### Epic 5: Move Pokédex
使用者完成後可以：瀏覽招式圖鑑、查看已解鎖/未解鎖招式、檢視招式詳情和進化鏈。
**FRs covered:** FR24, FR25

## Epic 1: Project Foundation & Player Onboarding

使用者完成後可以：建立自己的訓練角色，設定 5RM 基準值，準備好進入戰鬥。

### Story 1.1: Project Initialization & Architecture Scaffold

As a developer,
I want to initialize the Flutter project with all core dependencies and the full directory structure,
So that all future stories have a consistent, architecture-compliant foundation.

**Acceptance Criteria:**

**Given** no project exists
**When** the initialization script completes
**Then** the Flutter project builds and runs on iOS simulator
**And** all core dependencies are installed (flutter_riverpod, isar, isar_flutter_libs, go_router, very_good_analysis, mocktail, build_runner)
**And** the directory skeleton matches architecture spec (domain/, data/, presentation/, providers/, router/)
**And** build_runner codegen executes without errors
**And** very_good_analysis lint rules pass with zero warnings
**And** go_router is configured with placeholder routes (/, /battle, /battle/result, /pokedex, /pokedex/:moveId)

### Story 1.2: Player Profile Creation & Persistence

As a player,
I want to create my profile with 5RM values for core lifts and set my training frequency,
So that the system can calculate damage based on my actual strength.

**Acceptance Criteria:**

**Given** the app launches for the first time (no UserProfile exists)
**When** the user enters 5RM values for squat, bench press, deadlift, and overhead press
**Then** all four 5RM values are stored in the local database (FR1)
**And** the user can set weekly training frequency (1-7 days) (FR3)
**And** the UserProfile is persisted to Isar with all fields (level, EXP, 5RM values, unlocked moves) (FR29)
**And** the UserProfile can be retrieved on subsequent app launches without data loss
**And** the domain model UserProfile is Pure Dart with no Flutter/Isar dependency
**And** Isar Entity ↔ Domain Model mapping is handled by UserProfileMapper

### Story 1.3: Beginner Mode & Auto-Calibration

As a new player unfamiliar with my lifting capacity,
I want to select beginner mode so the system starts with minimum weights and auto-calibrates my 5RM over my first 3-5 sessions,
So that I don't need to know my 5RM to start playing.

**Acceptance Criteria:**

**Given** the user is on the onboarding screen
**When** the user selects "Beginner Mode"
**Then** initial 5RM values are set to predefined minimums (e.g., empty barbell or bodyweight)
**And** the system flags the profile as "calibrating" for the first 3-5 sessions (FR2)
**And** after each calibration session, the system updates estimated 5RM using recorded set data
**And** after calibration completes, the profile transitions to normal mode with finalized 5RM values
**And** the user can manually override calibrated values at any time

### Story 1.4: Home Screen

As a player,
I want to see my profile summary and a clear entry point to start training,
So that I know my current status and can begin a battle.

**Acceptance Criteria:**

**Given** the user has completed onboarding (UserProfile exists)
**When** the app launches
**Then** the home screen displays player level, EXP bar, and current 5RM summary
**And** a "Start Battle" button is prominently visible
**And** the app navigates directly to home (skipping onboarding) on subsequent launches
**And** cold start to home screen renders in <3 seconds (NFR5)

## Epic 2: Core Battle System

使用者完成後可以：選擇道館、發動攻擊、輸入每組訓練數據，即時看到傷害計算結果，體驗完整的屬性相剋和力量道館破防機制。

### Story 2.1: Type Effectiveness System

As a player,
I want the game to apply type advantages and disadvantages based on muscle groups,
So that my training choices have strategic meaning.

**Acceptance Criteria:**

**Given** 5 muscle types exist (Chest=Fire, Back=Water, Legs=Rock, Shoulders=Electric, Arms=Fighting)
**When** the type effectiveness matrix is queried
**Then** the 5×5 matrix returns correct multipliers (Super Effective 1.5x, Not Effective 0.5x, Neutral 1.0x) (FR26)
**And** the matrix is implemented as Pure Dart in domain/type_system/ with zero Flutter dependency
**And** unit tests verify all 25 type matchup combinations
**And** the multiplier is applied to damage calculation output (FR27)

### Story 2.2: Move Registry & Data Loading

As a player,
I want access to a variety of exercise-based moves with different types and power levels,
So that I have meaningful choices during battle.

**Acceptance Criteria:**

**Given** a moves.json asset file exists with move definitions
**When** the app loads
**Then** all moves are available via MoveRegistry with their attributes (type, power, PP, evolution chain)
**And** each move maps to a real exercise (e.g., Bench Press = Fire type, Squat = Rock type)
**And** the MoveDefinition domain model is Pure Dart
**And** the initial unlocked moves for a new player include basic bodyweight exercises per muscle group

### Story 2.3: Gym Selection & Boss Generation

As a player,
I want to choose my muscle group and gym type to face a challenging boss lineup,
So that my real workout drives a strategic battle.

**Acceptance Criteria:**

**Given** the player taps "Start Battle" on the home screen
**When** the player selects a muscle group (FR4) and gym type (Strength or Physique) (FR5)
**Then** the system generates a 3-stage enemy lineup: Minion → Mid-Boss → Gym Leader (FR6)
**And** Strength Gym bosses have high defense, low HP
**And** Physique Gym bosses have low defense, high HP
**And** boss types are assigned based on the selected muscle group's type effectiveness relationships
**And** boss stats scale with the player's current level

### Story 2.4: Damage Calculation Engine

As a player,
I want my actual training performance to translate into meaningful battle damage,
So that heavier weights and higher effort deal more damage.

**Acceptance Criteria:**

**Given** a player completes a set with weight, reps, and RPE
**When** damage is calculated
**Then** the formula applies: Intensity (weight/5RM) × Type Multiplier × RPE Multiplier (FR9)
**And** type effectiveness multiplier is applied (1.5x / 1.0x / 0.5x) (FR10)
**And** RPE multiplier is applied (RPE 6-7: 1.0x, RPE 8: 1.2x, RPE 9-10: 1.5x) (FR13)
**And** in Strength Gym, single-hit damage below boss defense threshold shows "Not Very Effective" (FR11)
**And** calculation completes in <16ms synchronously (NFR1)
**And** DamageCalculator is Pure Dart with unit tests covering all multiplier combinations

### Story 2.5: Battle Engine State Machine

As a player,
I want to fight through a 3-stage battle by selecting moves and entering my set data,
So that each gym session plays out as a complete RPG battle.

**Acceptance Criteria:**

**Given** the player has selected a gym and boss lineup is generated
**When** the battle begins
**Then** the BattleEngine transitions through phases: Idle → Warmup → MidBoss → GymLeader → Result
**And** BattlePhase is implemented as a Dart sealed class with exhaustive pattern matching
**And** the player can select a move from their unlocked moves for the current muscle group (FR7)
**And** the player can input weight (kg) and reps for each set (FR8)
**And** the player can input RPE (1-10) for each set (FR12)
**And** each set submission triggers damage calculation and applies damage to the current boss
**And** when a boss's HP reaches 0, the engine transitions to the next phase
**And** all state transitions are immutable (copyWith pattern)

### Story 2.6: Battle Screen UI

As a player,
I want to see an engaging battle screen with HP bars, damage numbers, and quick set input,
So that the training-as-battle experience feels immersive.

**Acceptance Criteria:**

**Given** a battle is in progress
**When** the battle screen renders
**Then** the boss sprite, boss HP bar, and player HP bar are displayed
**And** damage numbers animate on hit with pixel-style text (FR33)
**And** the boss HP bar uses AnimatedBuilder for smooth animation (NFR2: 60fps)
**And** the set input panel supports weight/reps/RPE entry in <5 seconds (prefill previous set, +/- 2.5kg buttons)
**And** the UI uses ConsumerWidget + select() for precise Riverpod subscriptions (avoid full tree rebuild)
**And** damage animation is isolated with RepaintBoundary

### Story 2.7: Battle State Persistence & Recovery

As a player,
I want my battle to resume exactly where I left off after an interruption,
So that phone calls or app switches don't ruin my gym session.

**Acceptance Criteria:**

**Given** a battle is in progress
**When** the app goes to background or is terminated
**Then** the current BattleState snapshot is persisted to Isar on every phase transition (FR30)
**And** on app resume/restart, the system detects an incomplete battle and offers to resume
**And** the restored battle state matches the exact phase, boss HP, player HP, and completed sets
**And** battle state is 100% recoverable after background (NFR7)
**And** crash recovery restores to the last completed set (NFR9)
**And** BattleState Isar entity uses Flat/Embedded strategy for read performance

## Epic 3: Battle Outcomes & Rewards

使用者完成後可以：打完一場完整戰鬥（勝利或失敗），獲得經驗值，看到訓練統計摘要，感受觸覺回饋。

### Story 3.1: Win & Lose Conditions

As a player,
I want the battle to end appropriately when I beat the boss or run out of HP,
So that every workout has a clear outcome.

**Acceptance Criteria:**

**Given** a battle is in progress
**When** the Gym Leader's HP reaches 0
**Then** the battle is marked as victory and transitions to Result phase (FR14)
**And** when the player's HP reaches 0, the battle is marked as defeat (FR15)
**And** when the player's set reps are lower than the previous set or system-suggested reps, it triggers exhaustion (Miss/Counter) and deducts player HP (FR16)
**And** defeat still awards 60% of the total earned EXP (FR15)

### Story 3.2: Battle Result Screen

As a player,
I want to see a summary of my workout performance after battle,
So that I know how much I accomplished and what rewards I earned.

**Acceptance Criteria:**

**Given** a battle has ended (victory or defeat)
**When** the result screen displays
**Then** total training volume (kg) is shown (FR17)
**And** damage statistics per stage are displayed (FR17)
**And** EXP earned is displayed with a breakdown
**And** victory/defeat status is clearly indicated
**And** a "Return Home" button navigates back to the home screen

### Story 3.3: Experience Points Calculation

As a player,
I want to earn EXP based on my battle performance,
So that consistent training progresses my character.

**Acceptance Criteria:**

**Given** a battle has concluded
**When** EXP is calculated
**Then** EXP is proportional to total damage dealt, sets completed, and battle outcome (FR18)
**And** victory awards 100% EXP, defeat awards 60% EXP (FR15)
**And** the EXP calculation is implemented in Pure Dart domain/training/exp_calculator.dart
**And** EXP is added to the player's UserProfile and persisted to Isar

### Story 3.4: Training History Storage

As a player,
I want all my training sessions to be saved locally,
So that I have a complete record of my workout history.

**Acceptance Criteria:**

**Given** a battle has concluded
**When** the result is saved
**Then** a WorkoutSession record is created with date, gym type, muscle group, total volume, and outcome (FR28)
**And** all ExerciseSet records (move, weight, reps, RPE, damage) are linked to the session
**And** data is written to Isar immediately upon confirmation (NFR8: zero data loss)
**And** WorkoutSession → ExerciseSet uses IsarLinks (per architecture: low-frequency read)
**And** historical sessions can be queried with <200ms response time (NFR4)

### Story 3.5: Haptic Feedback System

As a player,
I want to feel physical feedback during battle,
So that attacks and critical events feel impactful.

**Acceptance Criteria:**

**Given** a battle is in progress
**When** an attack hits a boss
**Then** a light haptic vibration is triggered (FR31)
**And** when a critical event occurs (critical hit, super effective, evolution, level up), enhanced vibration is triggered (FR32)
**And** haptic intensity varies by event type (normal hit < critical hit < evolution)
**And** haptic feedback works on iOS devices that support it

## Epic 4: Progression & Evolution

使用者完成後可以：升級角色、突破 PR 觸發進化動畫、解鎖新招式、體驗招式進化鏈。

### Story 4.1: Level Up System

As a player,
I want to level up when I accumulate enough EXP,
So that I feel my character growing stronger over time.

**Acceptance Criteria:**

**Given** the player earns EXP from a battle
**When** total EXP exceeds the current level threshold
**Then** the player levels up automatically (FR19)
**And** base stats are increased upon leveling
**And** the level up event is displayed to the player with enhanced haptic feedback
**And** the updated level and stats are persisted to UserProfile in Isar

### Story 4.2: PR Detection with Epley Formula

As a player,
I want the system to detect when I've broken a personal record,
So that real-world progress is recognized and celebrated.

**Acceptance Criteria:**

**Given** the player completes a set during battle
**When** the estimated 1RM (Epley: Weight × (1 + Reps/30)) exceeds the current stored 5RM equivalent
**Then** the system flags a PR breakthrough (FR20)
**And** the PR detection runs in Pure Dart domain/training/pr_detector.dart
**And** unit tests verify Epley calculation accuracy with known input/output pairs
**And** the detection runs synchronously after each set without blocking UI

### Story 4.3: Evolution Animation & 5RM Update

As a player,
I want to see an exciting evolution animation when I break a PR,
So that the moment feels as rewarding as evolving a Pokémon.

**Acceptance Criteria:**

**Given** a PR breakthrough is detected
**When** the evolution sequence triggers
**Then** an evolution animation plays (pixel-style, with screen flash effect) (FR21)
**And** the animation plays without frame drops (NFR6)
**And** the player's 5RM baseline is updated to the new value
**And** the 5RM update is an atomic Isar writeTxn operation (NFR10: no partial writes on interruption)
**And** enhanced haptic feedback accompanies the animation (FR32)

### Story 4.4: Move Unlock & Evolution Chain

As a player,
I want to unlock new moves by leveling up or defeating gym leaders,
So that my exercise repertoire grows as I progress.

**Acceptance Criteria:**

**Given** the player levels up or defeats a Gym Leader
**When** an unlock condition is met
**Then** the corresponding move is unlocked and available in battle (FR22)
**And** moves evolve along their evolution chain (e.g., Push-up → Barbell Bench Press → Incline Dumbbell Press) (FR23)
**And** the player is notified of newly unlocked moves
**And** unlocked moves are persisted in UserProfile

## Epic 5: Move Pokédex

使用者完成後可以：瀏覽招式圖鑑、查看已解鎖/未解鎖招式、檢視招式詳情和進化鏈。

### Story 5.1: Move List Screen

As a player,
I want to browse all available moves and see which ones I've unlocked,
So that I can plan my training and see my collection progress.

**Acceptance Criteria:**

**Given** the player navigates to the Pokédex screen
**When** the move list loads
**Then** all moves are displayed in a scrollable list (FR24)
**And** unlocked moves show full details (name, type badge, power)
**And** locked moves show silhouette/greyed-out state with unlock conditions
**And** moves can be filtered by type/muscle group
**And** the list loads within <200ms (NFR4)

### Story 5.2: Move Detail Screen

As a player,
I want to view detailed information about each move,
So that I understand its stats, evolution path, and my usage history.

**Acceptance Criteria:**

**Given** the player taps on an unlocked move in the Pokédex
**When** the detail screen opens
**Then** the screen displays: type, power, PP cost, evolution chain visualization (FR25)
**And** usage count (how many times used in battle) is shown
**And** PR record for the corresponding exercise is displayed (if applicable)
**And** the evolution chain shows previous and next evolution with unlock status
**And** navigation uses go_router with /pokedex/:moveId route

## Epic 6: PP & Item System

使用者完成後可以：在戰鬥中管理體力（PP）資源，使用道具延長休息、回復體力、升級招式，並在道具商店取得道具。
**Spec refs:** Section 3.1 (pp), Section 5.2 (Items), Section 5.3 (PP/Moves), Section 6.5 (Item Shop)

### Story 6.1: PP Resource System

As a player,
I want my moves to cost PP (stamina points) when used in battle,
So that I need to manage my energy strategically during a workout.

**Acceptance Criteria:**

**Given** the player has a PP pool (derived from `end` attribute)
**When** the player uses a move in battle
**Then** the move's `pp_cost` is deducted from the player's current PP
**And** when PP reaches 0, the player cannot use moves until PP is restored
**And** the PP bar is displayed alongside the HP bar on the battle screen
**And** PP is restored to full at the start of each new battle session
**And** PP logic is implemented in Pure Dart domain layer

### Story 6.2: Item Data Model & Inventory Management

As a player,
I want to own and manage an inventory of items,
So that I can use them strategically during or between battles.

**Acceptance Criteria:**

**Given** the item system defines three core items: Potion, Ether, Rare Candy
**When** the player acquires items (battle rewards or shop purchase)
**Then** items are stored in the player's inventory within UserProfile
**And** inventory counts are persisted to Isar
**And** the Item domain model is Pure Dart with no Flutter dependency
**And** an ItemRepository handles CRUD operations through the data layer

### Story 6.3: Item Effects & Battle Integration

As a player,
I want to use items during battle to gain tactical advantages,
So that I can recover from difficult situations mid-workout.

**Acceptance Criteria:**

**Given** the player has items in inventory
**When** the player uses a Potion during battle
**Then** the rest timer is paused/extended without reducing battle evaluation score
**And** when the player uses an Ether (confirms supplement intake)
**Then** PP is partially restored (e.g., 50% of max PP)
**And** when the player uses a Rare Candy on a move
**Then** the target move gains experience toward its next evolution
**And** item usage is integrated into the BattleEngine state machine
**And** items can only be used between sets (not mid-set)

### Story 6.4: Item Shop Screen

As a player,
I want to browse and purchase items from a shop,
So that I can prepare for challenging battles.

**Acceptance Criteria:**

**Given** the player navigates to the Item Shop
**When** the shop screen loads
**Then** all available items are displayed with name, description, price, and current inventory count
**And** the player can purchase items using in-game currency (EXP or battle rewards)
**And** purchased items are added to inventory and persisted
**And** the shop UI follows the existing pixel-art style
**And** navigation uses go_router with /shop route

## Epic 7: Training Scheduler & Daily Mission

使用者完成後可以：根據訓練頻率獲得自動化的訓練排程推薦，每日看到推薦道館任務。
**Spec refs:** Section 4.5 (Scheduler Algorithm), Section 6.2 (Daily Mission)

### Story 7.1: Training Scheduler Algorithm

As a player,
I want the system to recommend training splits based on my weekly frequency,
So that my workout plan is balanced and optimized.

**Acceptance Criteria:**

**Given** the player has set weekly training frequency in their profile
**When** the scheduler evaluates the next workout
**Then** frequency < 3 days/week → recommends Full Body (mixed type gym)
**And** frequency >= 3 days/week → recommends Split Routine (Push/Pull/Legs or 5-way split)
**And** the algorithm considers last workout date: >3 days ago → Full Body, <2 days ago → Split
**And** the same muscle group is scheduled at least twice per week for high-frequency plans
**And** the scheduler is implemented in Pure Dart domain/training/scheduler.dart
**And** unit tests cover all frequency tiers and edge cases

### Story 7.2: Daily Mission & Gym Recommendation

As a player,
I want to see a daily recommended gym/muscle group on the home screen,
So that I can follow a structured plan without manual scheduling.

**Acceptance Criteria:**

**Given** the player opens the app
**When** the home screen loads
**Then** a "Daily Mission" card displays the recommended muscle group and gym type
**And** the recommendation is generated by the Training Scheduler Algorithm (Story 7.1)
**And** the recommendation considers training history to avoid overtraining a muscle group
**And** the player can accept the recommendation (auto-selects gym) or choose manually
**And** completed daily missions grant bonus EXP

## Epic 8: Audio & Sound System

使用者完成後可以：在遊戲各場景聽到 BGM 和音效，包含戰鬥音樂、勝利/升級/進化音效。
**Spec refs:** Section 7.1 (Audio)

### Story 8.1: Audio Service Infrastructure

As a developer,
I want a centralized audio service that manages BGM and SFX playback,
So that all screens can play audio consistently.

**Acceptance Criteria:**

**Given** the app initializes
**When** the AudioService is created
**Then** it supports BGM playback (loop, fade in/out, crossfade)
**And** it supports SFX playback (one-shot, overlapping)
**And** volume can be adjusted independently for BGM and SFX
**And** audio can be globally muted via settings
**And** audio assets are loaded from the assets/audio/ directory
**And** the service is provided via Riverpod

### Story 8.2: Battle BGM & Stage Transitions

As a player,
I want different music for each battle stage,
So that the workout feels progressively more intense.

**Acceptance Criteria:**

**Given** a battle is in progress
**When** the battle transitions between stages (Warmup → MidBoss → GymLeader)
**Then** the BGM crossfades to the corresponding track
**And** Warmup uses a light/upbeat track
**And** MidBoss uses a mid-intensity battle track
**And** GymLeader uses a high-intensity boss battle track
**And** the home screen plays an ambient/exploration BGM
**And** BGM transitions do not cause audio gaps or stuttering

### Story 8.3: Event Sound Effects & Jingles

As a player,
I want to hear satisfying sound effects for key game events,
So that achievements and actions feel impactful.

**Acceptance Criteria:**

**Given** a game event occurs
**When** the event type is: attack hit, critical hit, super effective, level up, evolution, victory, defeat
**Then** the corresponding SFX or jingle plays
**And** victory jingle plays on the result screen for wins
**And** level up jingle plays during the level up animation
**And** evolution jingle plays during the evolution animation sequence
**And** SFX do not interrupt or conflict with BGM playback

## Epic 9: Wearable & Heart Rate Integration

使用者完成後可以：連接穿戴裝置（Apple Watch / Garmin），即時讀取心率並套用心率 Zone 傷害加成，體驗 Dynamax 模式。
**Spec refs:** Section 5.6 (Heart Rate Sync), Section 4.4 Step 3 (Heart Rate Critical), Section 2 (HealthKit)

### Story 9.1: HealthKit & Health Connect Setup

As a player,
I want to connect my wearable device to the app,
So that my real-time heart rate data can enhance the battle experience.

**Acceptance Criteria:**

**Given** the player has a compatible wearable device
**When** the player grants HealthKit (iOS) or Health Connect (Android) permission
**Then** the app can read real-time heart rate data during workouts
**And** the onboarding flow includes an optional wearable sync step
**And** if no wearable is connected, the system falls back to RPE manual input (existing behavior)
**And** the health data integration uses the `health` package
**And** permission handling follows platform-specific best practices

### Story 9.2: Heart Rate Zone Damage System

As a player,
I want my heart rate to influence battle damage,
So that training intensity is rewarded beyond manual RPE input.

**Acceptance Criteria:**

**Given** the player has a connected wearable providing heart rate data
**When** a set is completed during battle
**Then** the system reads the peak heart rate for that set
**And** Zone 1-2 (<60% max HR): 1.0x multiplier (steady damage)
**And** Zone 3-4 (70-85% max HR): 1.2x multiplier + increased critical hit chance (+30%)
**And** Zone 5 (>85% max HR): 1.5x multiplier (Dynamax Mode, see Story 9.4)
**And** if wearable is not connected, RPE multiplier is used instead (backward compatible)
**And** max HR is calculated as 220 - age (age stored in UserProfile)

### Story 9.3: Real-time Heart Rate HUD

As a player,
I want to see my heart rate and current zone on the battle screen,
So that I can adjust my intensity in real-time.

**Acceptance Criteria:**

**Given** a battle is in progress and wearable is connected
**When** the battle screen renders
**Then** a heart rate overlay displays in the top-right corner
**And** the display shows current BPM and zone color (blue/green/orange/red)
**And** the HUD updates in real-time (<1s delay)
**And** the HUD is hidden when no wearable is connected
**And** the HUD uses RepaintBoundary to avoid unnecessary rebuilds

### Story 9.4: Dynamax Mode

As a player,
I want an extreme power mode when my heart rate hits Zone 5,
So that pushing to maximum intensity has both high reward and risk.

**Acceptance Criteria:**

**Given** the player's heart rate enters Zone 5 (>85% max HR)
**When** damage is calculated for that set
**Then** damage multiplier is 1.5x (Dynamax Mode activated)
**And** the player loses 5% of max HP per turn while in Dynamax Mode
**And** a visual "Dynamax" overlay effect appears on the battle screen
**And** enhanced haptic feedback accompanies Dynamax activation
**And** the self-damage mechanic is clearly communicated to the player via UI indicator

## Epic 10: Map Home Screen

使用者完成後可以：在地圖風格的主畫面看到多個道館位置，選擇要挑戰的道館，體驗更沉浸的遊戲世界。
**Spec refs:** Section 6.2 (Home - The Map)

### Story 10.1: Map UI & Gym Locations

As a player,
I want to see a game world map on the home screen with multiple gym locations,
So that choosing a workout feels like exploring a game world.

**Acceptance Criteria:**

**Given** the player is on the home screen
**When** the map loads
**Then** a 2D pixel-art map displays with gym icons for each muscle group/type
**And** each gym shows its type badge (Fire/Water/Rock/Electric/Fighting)
**And** completed gyms show a badge/checkmark indicator
**And** the player's character is visible on the map
**And** the map scrolls/pans smoothly if larger than screen

### Story 10.2: Map Navigation & Gym Entry Flow

As a player,
I want to tap a gym on the map to start a battle there,
So that gym selection feels like an adventure rather than a menu.

**Acceptance Criteria:**

**Given** the player taps a gym icon on the map
**When** the gym is selected
**Then** a gym preview panel slides up showing gym name, type, recommended level, and daily mission indicator
**And** the player can confirm entry to start the battle (replaces current gym selection flow)
**And** the daily mission gym is highlighted with a special marker
**And** navigation transitions smoothly from map → gym preview → battle screen
**And** the existing gym selection logic (muscle group + gym type) is preserved underneath
