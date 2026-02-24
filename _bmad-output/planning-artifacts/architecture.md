---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments: ['_bmad-output/planning-artifacts/prd.md', 'spec.md']
workflowType: 'architecture'
project_name: 'IronMon'
user_name: 'Bruce'
date: '2026-02-17'
lastStep: 8
status: 'complete'
completedAt: '2026-02-18'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements：**
33 條 FR 橫跨 7 大能力領域。架構上最關鍵的是：
- 戰鬥系統（FR4-FR17）：驅動 State Machine 設計、傷害計算引擎、屬性系統
- 成長系統（FR18-FR23）：驅動 PR 偵測邏輯、進化觸發流程、招式解鎖圖
- 數據持久化（FR28-FR30）：驅動離線儲存策略、戰鬥狀態恢復機制

**Non-Functional Requirements：**
10 條 NFR 集中在 Performance 和 Reliability，架構影響最大的：
- NFR1: 傷害計算 <16ms → 純 Dart 同步計算，禁止 async/await
- NFR2: 60fps 戰鬥畫面 → Presentation 層需優化 rebuild 範圍
- NFR7/NFR9: 戰鬥狀態 100% 可恢復 → 每個 State 轉換需持久化
- NFR10: 5RM 更新不可分割 → 需 transaction-level 寫入

**Scale & Complexity：**
- Primary domain: Mobile (Flutter/Dart)
- Complexity level: Medium-High
- Estimated architectural components: 8-12（Battle Engine、Damage Calculator、Training Tracker、PR Detector、Type System、State Persistence、Move Registry、Progression Manager）

### Technical Constraints & Dependencies

- Flutter/Dart 單線程模型 — 重計算不能阻塞 UI thread
- Isar 作為唯一持久化層（PRD context sections 明確指定）
- MVP 無雲端 — 無 auth、無 sync、無 remote config
- iOS TestFlight 發布 — 需考慮 iOS 平台限制（HealthKit 權限保留但 MVP 不用）
- 無 push notification — 純 in-app 體驗

### Cross-Cutting Concerns Identified

1. **Battle State Lifecycle：** State Machine 狀態在每次轉換時持久化，支援任意中斷恢復
2. **Data Integrity：** 5RM 更新、經驗值授予、招式解鎖需保證一致性
3. **Type Effectiveness Matrix：** 5 屬性 × 5 屬性的相剋關係影響道館生成、傷害計算、招式選擇
4. **Performance Budget：** 16ms 傷害計算 + 60fps 動畫 = Presentation 和 Domain 層必須嚴格分離
5. **Offline-First Data Flow：** 所有數據讀寫本地完成，未來需預留 sync 擴展點

## Starter Template Evaluation

### Primary Technology Domain

Mobile (Flutter/Dart) — PRD 與 spec.md 明確指定

### Starter Options Considered

| Option | Verdict | Reason |
|--------|---------|--------|
| Very Good CLI | ❌ 不採用 | 預設 BLoC、多 flavor 過重、需大量改造 |
| Flutter Starter CLI | ❌ 不採用 | 通用架構不符合 domain-specific 需求 |
| `flutter create` + 手動組裝 | ✅ 採用 | 完全控制，量身定制 |

### Selected Starter: `flutter create` + Manual Setup

**Rationale：**
IronMon 的核心架構需求（Battle Engine State Machine、Damage Calculator、Type Effectiveness Matrix、PR Detector）是高度 domain-specific。通用模板的 CRUD/form-based 架構反而會阻礙。手動組裝讓我們從第一行就按 domain 需求設計。

**Initialization Command：**

```bash
flutter create --org com.ironmon --platforms ios ironmon
```

**Architectural Decisions Provided by Starter：**

- **Language & Runtime：** Dart 3.x with sound null safety
- **State Management：** flutter_riverpod + riverpod_annotation
- **Local Database：** isar 4.x + isar_flutter_libs
- **Styling Solution：** Flutter Material 3（像素風 UI 用 CustomPainter）
- **Build Tooling：** Flutter CLI + build_runner（Riverpod/Isar code generation）
- **Testing Framework：** flutter_test（內建）+ mocktail
- **Lint Rules：** very_good_analysis（僅 lint package）
- **Code Organization：** Feature-first + Domain layer 分離（Step 4 詳細定義）

**Note：** Project initialization 應為第一個 implementation story。

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation)：**
1. Isar Schema 策略 — 混合策略（flat + links）
2. Domain Layer 分離 — Pure Dart
3. Battle State Machine 模式 — Sealed Class + Pattern Matching

**Important Decisions (Shape Architecture)：**
4. Routing — go_router
5. Error Handling — 混合（Domain: Result Type / UI: AsyncValue）

**Deferred Decisions (Post-MVP)：**
- Authentication & Authorization → Phase 3 Firebase 整合時決定
- API Design → Phase 3 雲端同步時決定
- CI/CD Pipeline → 規模擴大時建立
- Monitoring & Analytics → Post-MVP

### Data Architecture

**Decision：** Isar 混合策略（Flat + Links）

| 場景 | 策略 | 理由 |
|------|------|------|
| 戰鬥中即時數據（ExerciseSet、damage） | Flat / Embedded | NFR1 <16ms，避免 Link.load() 延遲 |
| 角色狀態（UserProfile、5RM、招式） | Flat Collection | 頻繁讀取，單次查詢完成 |
| 歷史紀錄（WorkoutSession → ExerciseSet） | IsarLinks | 查詢頻率低，domain model 清晰 |
| 戰鬥狀態快照（BattleState） | 獨立 Collection | NFR7/NFR9 中斷恢復，每次 state 轉換寫入 |

**Isar Collections 規劃：**
- `UserProfile` — 角色狀態、5RM、等級、經驗值、已解鎖招式
- `WorkoutSession` — 訓練紀錄（日期、道館類型、肌群、結果）
- `ExerciseSet` — 單組數據（招式、重量、次數、RPE、傷害）
- `BattleState` — 戰鬥快照（phase、boss HP、player HP、當前階段數據）
- `MoveDefinition` — 招式定義（屬性、威力、PP、進化鏈）— 可用 JSON asset 替代

**Migration Strategy：** Isar 4.x 支援 schema migration。MVP 階段 schema 變更直接 deleteFromDisk + rebuild（TestFlight 用戶可接受）。

### Authentication & Security

**Decision：** MVP 完全跳過

無 Auth、無雲端、無 API。所有數據純本地 Isar 儲存。Post-MVP Phase 3 導入 Firebase Auth 時再設計。

### API & Communication Patterns

**Decision：** MVP 不適用

純本地 App，無 client-server 通訊。Domain 層 Repository Pattern 預留介面，未來加入 Remote Data Source 時不需改 domain 層。

### Frontend Architecture

**Routing：**
- **Decision：** go_router
- **Rationale：** Flutter 官方推薦、聲明式、社群最大。IronMon 路由簡單（Home → Battle → Result → Pokédex → Settings），不需 code generation
- **Routes：** `/` (Home) → `/battle` → `/battle/result` → `/pokedex` → `/pokedex/:moveId`

**State Management Patterns（Riverpod）：**
- Domain Services → `Provider`（singleton，如 DamageCalculator、TypeEffectivenessMatrix）
- Repositories → `Provider`（singleton，Isar 存取）
- Battle State → `NotifierProvider`（mutable state，BattleEngine 驅動）
- User Profile → `AsyncNotifierProvider`（async Isar 讀取）
- UI-only state → `StateProvider`（輕量 UI 狀態）

**Performance Optimization：**
- Battle screen 用 `ConsumerWidget` + `select()` 精確訂閱，避免整棵 widget tree rebuild
- Damage animation 用 `RepaintBoundary` 隔離重繪範圍
- Boss HP bar 用 `AnimatedBuilder` 而非 `setState`

### Infrastructure & Deployment

**Decision：** 最小化

- **Distribution：** iOS TestFlight（`flutter build ipa`）
- **CI/CD：** 手動 build，solo dev 不需 pipeline（Post-MVP 考慮 GitHub Actions）
- **Logging：** `dart:developer` log + Riverpod `ProviderObserver` 追蹤 state 變化
- **Error Reporting：** MVP 本地 log，Post-MVP 考慮 Sentry/Crashlytics

### Decision Impact Analysis

**Implementation Sequence：**
1. Project init（`flutter create`）+ 核心 dependencies
2. Isar schema 定義 + Repository 層
3. Pure Dart Domain Layer（DamageCalculator、TypeSystem、BattleEngine sealed class）
4. Riverpod providers 接線
5. go_router + Presentation 層
6. Battle UI + 動畫

**Cross-Component Dependencies：**
- BattleEngine（sealed class）→ 依賴 DamageCalculator + TypeSystem
- DamageCalculator → 依賴 UserProfile（5RM）+ MoveDefinition（屬性）
- BattleState persistence → 依賴 Isar BattleState collection
- PR Detection → 依賴 ExerciseSet 數據 + UserProfile 5RM

## Implementation Patterns & Consistency Rules

### Naming Patterns

**Dart 命名：**
- Classes: `UpperCamelCase` — `BattleEngine`、`DamageCalculator`、`TypeEffectiveness`
- Files: `snake_case.dart` — `battle_engine.dart`、`damage_calculator.dart`
- Variables/Functions: `lowerCamelCase` — `currentPhase`、`calculateDamage()`
- Enums: `UpperCamelCase` + `lowerCamelCase` values — `MuscleType.chest`、`BattlePhase.warmup`
- Private: `_prefix` — `_currentHp`、`_calculateMultiplier()`
- Constants: `lowerCamelCase` — `maxBossHp`、`expPerLevel`（Dart 官方規範，不用 SCREAMING_CASE）

**Isar Collection 命名：**
- Collection 名: `UpperCamelCase` 對應 domain model — `UserProfile`、`WorkoutSession`
- 5RM 欄位: `{exercise}FiveRm` — `squatFiveRm`、`benchPressFiveRm`、`deadliftFiveRm`、`overheadPressFiveRm`、`barbellRowFiveRm`
- ID 欄位: `Id id = Isar.autoIncrement`（Isar 慣例）

**Riverpod Provider 命名：**
- `{功能}Provider` — `battleEngineProvider`、`damageCalculatorProvider`
- `{功能}RepositoryProvider` — `userProfileRepositoryProvider`
- `{功能}NotifierProvider` — `battleStateNotifierProvider`
- 禁止 `Provider1`、`myProvider` 等無意義命名

**Route 命名：**
- Path: kebab-case — `/battle`、`/battle/result`、`/pokedex`
- Name: lowerCamelCase — `battleRoute`、`battleResultRoute`、`pokedexRoute`

### Structure Patterns

**Feature-First + Domain Layer 分離：**

```
lib/
├── domain/                    # Pure Dart — 零 Flutter 依賴
│   ├── battle/
│   │   ├── battle_engine.dart
│   │   ├── battle_phase.dart   # sealed class
│   │   ├── damage_calculator.dart
│   │   └── models/
│   │       ├── battle_state.dart
│   │       ├── boss.dart
│   │       └── damage_result.dart
│   ├── training/
│   │   ├── pr_detector.dart
│   │   └── models/
│   │       ├── exercise_set.dart
│   │       └── workout_session.dart
│   ├── type_system/
│   │   └── type_effectiveness.dart
│   └── shared/
│       ├── result.dart          # Result<T, E> type
│       └── models/
│           ├── muscle_type.dart
│           └── move_definition.dart
├── data/
│   ├── repositories/           # Repository implementations
│   ├── local/                  # Isar collections & schemas
│   └── mappers/                # Domain ↔ Isar 轉換
├── presentation/
│   ├── battle/
│   ├── home/
│   ├── onboarding/
│   ├── pokedex/
│   └── shared/                 # 共用 widgets
├── providers/                  # Riverpod provider definitions
├── router/                     # go_router configuration
└── main.dart
```

**Test 結構鏡像 lib/：**

```
test/
├── domain/
│   ├── battle/
│   │   ├── battle_engine_test.dart
│   │   └── damage_calculator_test.dart
│   ├── training/
│   │   └── pr_detector_test.dart
│   └── type_system/
│       └── type_effectiveness_test.dart
├── data/
│   └── repositories/
└── presentation/
    └── battle/
```

### State Management Rules

**不可變原則：**
- 所有 domain model 使用 `@immutable` 或 `freezed`
- State 更新必須透過 `copyWith` — 禁止直接 mutation
- BattleState sealed class 每個 variant 都是 immutable data class
- Riverpod Notifier 的 `state =` 賦值是唯一合法的 state 更新方式

### Error Handling Flow

**Domain 層：** `Result<T, E>` — 成功回傳 `Result.success(value)`，失敗回傳 `Result.failure(error)`
**Repository 層：** `try/catch` → 轉為 `Result.failure()`，永不讓 exception 穿透到 domain
**Presentation 層：** Riverpod `AsyncValue`（`data` / `loading` / `error`）自動處理 UI 狀態

### Enforcement Guidelines

**禁止事項：**
- `lib/domain/` 內禁止 `import 'package:flutter/...';`
- `lib/domain/` 內禁止 `import 'package:isar/...';`
- 所有 Isar 操作僅限 `lib/data/` 層
- Sealed class switch 禁止使用 `default` — 必須窮舉所有 variant
- Widget 內禁止直接呼叫 Isar — 必須透過 Repository → Provider

**Anti-Patterns：**
- ❌ 在 Widget 內直接計算傷害 → ✅ 透過 `DamageCalculator` provider
- ❌ `BattleState` 用 mutable class → ✅ sealed class + immutable variants
- ❌ Repository 回傳 Isar entity → ✅ 透過 Mapper 轉為 domain model
- ❌ 在 domain 層 catch exception → ✅ 用 `Result` type 表達失敗
- ❌ `setState()` 管理戰鬥狀態 → ✅ Riverpod `NotifierProvider`

## Project Structure & Boundaries

### Complete Project Directory Structure

```
ironmon/
├── README.md
├── pubspec.yaml
├── analysis_options.yaml
├── build.yaml                          # build_runner config (Riverpod/Isar codegen)
├── .gitignore
├── assets/
│   ├── data/
│   │   └── moves.json                  # MoveDefinition 靜態資料
│   ├── images/
│   │   ├── bosses/                     # Boss 像素圖
│   │   ├── moves/                      # 招式圖示
│   │   ├── types/                      # 屬性圖示
│   │   └── ui/                         # UI 元素
│   └── audio/
│       ├── sfx/                        # 8-bit 音效
│       └── bgm/                        # 戰鬥背景音樂
├── lib/
│   ├── main.dart                       # App entry point, Isar init, ProviderScope
│   ├── domain/                         # 🔒 Pure Dart — 零 Flutter/Isar 依賴
│   │   ├── battle/
│   │   │   ├── battle_engine.dart      # State Machine 核心邏輯
│   │   │   ├── battle_phase.dart       # sealed class: Idle/Warmup/MidBoss/GymLeader/Result
│   │   │   ├── damage_calculator.dart  # 傷害公式：Intensity × TypeMul × RPEMul
│   │   │   ├── boss_generator.dart     # 3 階段敵人陣容生成
│   │   │   └── models/
│   │   │       ├── battle_state.dart   # 戰鬥即時狀態（immutable）
│   │   │       ├── boss.dart           # Boss 定義（HP、屬性、防禦值）
│   │   │       ├── damage_result.dart  # 傷害計算結果
│   │   │       └── battle_outcome.dart # 戰鬥結算（勝/敗、經驗值、統計）
│   │   ├── training/
│   │   │   ├── pr_detector.dart        # Epley 公式 PR 偵測
│   │   │   ├── exp_calculator.dart     # 經驗值計算
│   │   │   ├── level_system.dart       # 升級判定、屬性提升
│   │   │   └── models/
│   │   │       ├── exercise_set.dart   # 單組訓練數據
│   │   │       ├── workout_session.dart # 訓練 session
│   │   │       └── user_profile.dart   # 角色狀態（等級、5RM、經驗值）
│   │   ├── type_system/
│   │   │   ├── type_effectiveness.dart # 5×5 屬性相剋矩陣
│   │   │   └── muscle_type.dart        # enum: chest/back/legs/shoulders/arms
│   │   ├── moves/
│   │   │   ├── move_registry.dart      # 招式查詢、解鎖邏輯
│   │   │   └── models/
│   │   │       └── move_definition.dart # 招式定義（屬性、威力、PP、進化鏈）
│   │   └── shared/
│   │       └── result.dart             # Result<T, E> type
│   ├── data/
│   │   ├── repositories/
│   │   │   ├── user_profile_repository.dart
│   │   │   ├── workout_session_repository.dart
│   │   │   ├── battle_state_repository.dart
│   │   │   └── move_repository.dart
│   │   ├── local/                      # Isar schemas（codegen target）
│   │   │   ├── user_profile_entity.dart
│   │   │   ├── workout_session_entity.dart
│   │   │   ├── exercise_set_entity.dart
│   │   │   ├── battle_state_entity.dart
│   │   │   └── isar_database.dart      # Isar instance 管理
│   │   └── mappers/
│   │       ├── user_profile_mapper.dart
│   │       ├── workout_session_mapper.dart
│   │       ├── exercise_set_mapper.dart
│   │       └── battle_state_mapper.dart
│   ├── presentation/
│   │   ├── home/
│   │   │   └── home_screen.dart        # 首頁：選擇肌群、開始戰鬥
│   │   ├── onboarding/
│   │   │   ├── onboarding_screen.dart  # 首次啟動：輸入 5RM
│   │   │   └── widgets/
│   │   │       └── five_rm_input_card.dart
│   │   ├── battle/
│   │   │   ├── battle_screen.dart      # 戰鬥主畫面
│   │   │   ├── battle_result_screen.dart # 結算畫面
│   │   │   └── widgets/
│   │   │       ├── boss_hp_bar.dart    # AnimatedBuilder HP 條
│   │   │       ├── damage_display.dart # 傷害數字動畫
│   │   │       ├── move_selector.dart  # 招式選擇面板
│   │   │       ├── set_input_panel.dart # 重量/次數/RPE 快速輸入
│   │   │       └── evolution_animation.dart # PR 進化動畫
│   │   ├── pokedex/
│   │   │   ├── pokedex_screen.dart     # 招式圖鑑列表
│   │   │   ├── move_detail_screen.dart # 招式詳情
│   │   │   └── widgets/
│   │   │       ├── move_list_tile.dart
│   │   │       └── evolution_chain_view.dart
│   │   └── shared/
│   │       ├── theme.dart              # Material 3 主題 + 像素風配色
│   │       ├── pixel_text.dart         # 像素字體 widget
│   │       └── type_badge.dart         # 屬性標籤 widget
│   ├── providers/
│   │   ├── battle_providers.dart       # BattleEngine、DamageCalculator providers
│   │   ├── training_providers.dart     # PRDetector、ExpCalculator providers
│   │   ├── repository_providers.dart   # 所有 Repository providers
│   │   ├── user_profile_providers.dart # UserProfile AsyncNotifier
│   │   └── type_system_providers.dart  # TypeEffectiveness provider
│   └── router/
│       └── app_router.dart             # go_router 設定
├── test/
│   ├── domain/
│   │   ├── battle/
│   │   │   ├── battle_engine_test.dart
│   │   │   ├── damage_calculator_test.dart
│   │   │   └── boss_generator_test.dart
│   │   ├── training/
│   │   │   ├── pr_detector_test.dart
│   │   │   ├── exp_calculator_test.dart
│   │   │   └── level_system_test.dart
│   │   ├── type_system/
│   │   │   └── type_effectiveness_test.dart
│   │   └── moves/
│   │       └── move_registry_test.dart
│   ├── data/
│   │   ├── repositories/
│   │   │   ├── user_profile_repository_test.dart
│   │   │   ├── workout_session_repository_test.dart
│   │   │   └── battle_state_repository_test.dart
│   │   └── mappers/
│   │       └── user_profile_mapper_test.dart
│   ├── presentation/
│   │   └── battle/
│   │       └── battle_screen_test.dart
│   └── fixtures/
│       ├── test_user_profile.dart      # 測試用 UserProfile 工廠
│       ├── test_battle_state.dart      # 測試用 BattleState 工廠
│       └── test_moves.dart             # 測試用 MoveDefinition
└── integration_test/
    └── battle_flow_test.dart           # 完整戰鬥流程整合測試
```

### Architectural Boundaries

**Domain Boundary（最嚴格）：**
- `lib/domain/` 是 Pure Dart 沙盒 — 禁止 import Flutter、Isar、Riverpod
- 僅允許 `dart:core`、`dart:math`、`dart:collection`
- 與外部世界的溝通必須透過 Repository 抽象介面（定義在 domain，實作在 data）

**Data Boundary：**
- `lib/data/` 是唯一允許 import Isar 的區域
- Repository 實作 domain 層定義的介面
- Mapper 負責 Isar Entity ↔ Domain Model 雙向轉換
- 禁止將 Isar Entity 暴露到 domain 或 presentation 層

**Presentation Boundary：**
- `lib/presentation/` 透過 Riverpod Provider 取得數據
- Widget 不直接持有業務邏輯 — 邏輯在 domain 層或 Notifier 中
- 跨 feature 共用的 widget 放 `presentation/shared/`

**Provider Boundary：**
- `lib/providers/` 是 domain 和 presentation 的接線層
- Provider 定義集中管理，避免散落各處
- 依賴方向：Presentation → Provider → Domain → (Provider → Data)

### Requirements to Structure Mapping

**FR 分類對應：**

| FR 類別 | Domain 模組 | Data 層 | Presentation 層 |
|---------|------------|---------|----------------|
| Onboarding (FR1-FR3) | `domain/training/models/user_profile.dart` | `data/repositories/user_profile_repository.dart` | `presentation/onboarding/` |
| Battle System (FR4-FR13) | `domain/battle/` 全模組 | `data/repositories/battle_state_repository.dart` | `presentation/battle/` |
| Battle Outcomes (FR14-FR17) | `domain/battle/battle_engine.dart` + `domain/training/exp_calculator.dart` | `data/repositories/workout_session_repository.dart` | `presentation/battle/battle_result_screen.dart` |
| Progression (FR18-FR23) | `domain/training/` 全模組 + `domain/moves/move_registry.dart` | `data/repositories/user_profile_repository.dart` | `presentation/battle/widgets/evolution_animation.dart` |
| Move Pokédex (FR24-FR25) | `domain/moves/` | `data/repositories/move_repository.dart` | `presentation/pokedex/` |
| Type System (FR26-FR27) | `domain/type_system/` | N/A（純計算，無持久化） | N/A（內嵌於 battle UI） |
| Data Persistence (FR28-FR30) | N/A（跨切面） | `data/local/` + `data/repositories/` 全部 | N/A |
| Feedback (FR31-FR33) | N/A | N/A | `presentation/battle/widgets/` |

**Cross-Cutting Concerns 對應：**

| Concern | 涉及模組 |
|---------|---------|
| Battle State Lifecycle | `domain/battle/battle_phase.dart` → `data/repositories/battle_state_repository.dart` → `providers/battle_providers.dart` |
| Data Integrity (5RM) | `domain/training/pr_detector.dart` → `data/repositories/user_profile_repository.dart`（transaction 寫入） |
| Type Effectiveness | `domain/type_system/type_effectiveness.dart` → 被 `damage_calculator.dart` 和 `boss_generator.dart` 引用 |
| Performance Budget | `domain/battle/damage_calculator.dart`（同步計算）+ `presentation/battle/widgets/`（`select()` + `RepaintBoundary`） |

### Data Flow

**戰鬥核心數據流：**

```
User Input (重量/次數/RPE)
  → SetInputPanel (Presentation)
  → BattleStateNotifier (Provider)
  → BattleEngine.processSet() (Domain)
    → DamageCalculator.calculate() (Domain, 同步 <16ms)
      → TypeEffectiveness.getMultiplier() (Domain)
    → BattlePhase transition (Domain)
  → BattleStateRepository.saveSnapshot() (Data, 每次 state 轉換)
  → UI rebuild via select() (Presentation, 精確訂閱)
```

**PR 偵測數據流：**

```
ExerciseSet 完成
  → PRDetector.check() (Domain, Epley 公式)
  → if PR detected:
    → UserProfileRepository.updateFiveRm() (Data, 不可分割寫入)
    → Evolution animation trigger (Presentation)
    → MoveRegistry.checkUnlock() (Domain)
```

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility：**
- Flutter 3.x + Dart 3.x + Riverpod 2.x + Isar 4.x + go_router — 版本相容，社群廣泛驗證
- Sealed class（Dart 3 feature）+ Riverpod pattern matching — 原生支援，無衝突
- Isar codegen + Riverpod codegen 共用 build_runner — 同一工具鏈
- Pure Dart domain layer 與 Flutter presentation layer 透過 Provider 解耦 — 架構一致

**Pattern Consistency：**
- Naming conventions（snake_case files、UpperCamelCase classes、lowerCamelCase providers）— 全域一致
- Immutable state（copyWith）+ sealed class exhaustive switch — 互相強化
- Result<T, E> 在 domain + AsyncValue 在 presentation — 各層職責分明
- Repository pattern（domain 定義介面、data 實作）— 依賴反轉一致

**Structure Alignment：**
- Feature-first presentation + domain-first core — 結構支援兩種開發視角
- Test 鏡像 lib/ — 測試對應清晰
- Provider 集中管理於 `lib/providers/` — 避免接線混亂
- Mapper 層隔離 Isar Entity — boundary 完整

### Requirements Coverage Validation ✅

**Functional Requirements（33 條）：**

| FR 類別 | 條數 | 架構支援 | 備註 |
|---------|------|---------|------|
| Onboarding (FR1-FR3) | 3 | ✅ | `user_profile.dart` + onboarding screen |
| Battle System (FR4-FR13) | 10 | ✅ | Battle Engine sealed class + DamageCalculator |
| Battle Outcomes (FR14-FR17) | 4 | ✅ | BattleEngine phase transition + ExpCalculator |
| Progression (FR18-FR23) | 6 | ✅ | PRDetector + LevelSystem + MoveRegistry |
| Move Pokédex (FR24-FR25) | 2 | ✅ | MoveRepository + Pokédex screens |
| Type System (FR26-FR27) | 2 | ✅ | TypeEffectiveness 5×5 矩陣 |
| Data Persistence (FR28-FR30) | 3 | ✅ | 4 Repositories + BattleState snapshot |
| Feedback (FR31-FR33) | 3 | ✅ | Presentation widgets + HapticFeedback |

**Non-Functional Requirements（10 條）：**

| NFR | 架構支援 | 實現機制 |
|-----|---------|---------|
| NFR1 (<16ms 傷害計算) | ✅ | Pure Dart 同步計算，零 async |
| NFR2 (60fps) | ✅ | `select()` 精確訂閱 + `RepaintBoundary` |
| NFR3 (<200ms 端對端) | ✅ | 同步 domain + 即時 UI update |
| NFR4 (<200ms 查詢) | ✅ | Isar 本地查詢，indexed fields |
| NFR5 (<3s cold start) | ✅ | 最小依賴，無網路請求 |
| NFR6 (動畫不掉幀) | ✅ | `RepaintBoundary` + `AnimatedBuilder` |
| NFR7 (背景恢復) | ✅ | 每次 phase transition 持久化 BattleState |
| NFR8 (數據零丟失) | ✅ | 每組確認後立即 Isar write |
| NFR9 (crash 恢復) | ✅ | BattleState 獨立 collection，啟動時檢查 |
| NFR10 (5RM 不可分割) | ✅ | Isar writeTxn 保證 transaction |

### Implementation Readiness Validation ✅

**Decision Completeness：**
- 5 項核心決策全部文件化（Isar 策略、Routing、Domain 分離、State Machine、Error Handling）
- 所有技術選型含具體版本策略
- Implementation patterns 涵蓋命名、結構、狀態管理、錯誤處理

**Structure Completeness：**
- 完整 project tree 含所有預期檔案
- 每個 FR 類別都有明確的檔案對應
- Test 結構完整鏡像

**Pattern Completeness：**
- Anti-patterns 明確列出，AI agent 可直接校驗
- Enforcement guidelines 可用 lint rules 或 import restrictions 自動化
- Domain boundary 規則清晰（import 黑名單）

### Gap Analysis Results

**Critical Gaps：** 0

**Important Gaps（建議在 Epics & Stories 階段補充）：**
1. **Isar Schema 詳細欄位定義** — 架構文件定義了 collections，但具體 field types、indexes、embedded objects 待 implementation story 細化
2. **moves.json 資料格式** — MoveDefinition 的 JSON schema 待定義，建議第一個 sprint 產出
3. **進化動畫規格** — 架構只定義了 widget 位置，動畫時長/效果待 UX 設計補充

**Nice-to-Have Gaps：**
1. Riverpod `ProviderObserver` 的具體 log format — 可在實作時自然決定
2. Error message 的 i18n 策略 — MVP 先用中文硬編碼，Post-MVP 再考慮

### Architecture Completeness Checklist

**✅ Requirements Analysis**

- [x] Project context thoroughly analyzed
- [x] Scale and complexity assessed
- [x] Technical constraints identified
- [x] Cross-cutting concerns mapped

**✅ Architectural Decisions**

- [x] Critical decisions documented with rationale
- [x] Technology stack fully specified
- [x] Integration patterns defined（Repository + Provider）
- [x] Performance considerations addressed（16ms budget、60fps strategy）

**✅ Implementation Patterns**

- [x] Naming conventions established（Dart、Isar、Riverpod、Route）
- [x] Structure patterns defined（Feature-first + Domain layer）
- [x] State management patterns specified（Immutable + copyWith）
- [x] Error handling patterns documented（Result + AsyncValue）

**✅ Project Structure**

- [x] Complete directory structure defined
- [x] Component boundaries established（Domain / Data / Presentation / Provider）
- [x] Integration points mapped（Data Flow diagrams）
- [x] Requirements to structure mapping complete（FR → 檔案對應表）

### Architecture Readiness Assessment

**Overall Status：** READY FOR IMPLEMENTATION

**Confidence Level：** High

**Key Strengths：**
- Domain layer 完全隔離，可獨立單元測試且不依賴 Flutter runtime
- Battle Engine sealed class 提供 compile-time exhaustiveness 保證
- 每個 FR 都有明確的檔案歸屬，AI agent 不會產生歧義
- Performance budget 從架構層面保證（同步計算、精確 rebuild）

**Areas for Future Enhancement：**
- Post-MVP: Firebase Auth 整合需新增 `data/remote/` 層
- Post-MVP: Cloud sync 需擴展 Repository 支援 remote data source
- Post-MVP: Analytics/Crashlytics 需新增 observability 層

### Implementation Handoff

**AI Agent Guidelines：**
- 嚴格遵守 domain boundary — `lib/domain/` 內禁止 Flutter/Isar import
- 所有新檔案按 project tree 放置，不得自行發明目錄
- State 更新只能透過 `copyWith` + Notifier `state =`
- Sealed class switch 必須窮舉，禁止 `default`

**First Implementation Priority：**
```bash
flutter create --org com.ironmon --platforms ios ironmon
```
→ 安裝核心 dependencies → 建立目錄骨架 → Isar schema 定義 → Pure Dart domain layer
