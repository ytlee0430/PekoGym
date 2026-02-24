# Project Specification: IronMon (Project PokéGym / 肌力道館)

## 1. 專案概觀 (Project Overview)

IronMon 是一款將健身訓練遊戲化的 RPG App。核心理念是將真實世界的健身數據（重量、次數、組數、心率）轉化為戰鬥數值。

- **核心理念：**「訓練即戰鬥，進步即升級」
- **Unique Selling Point (USP):** 結合「漸進式超負荷 (Progressive Overload)」與「屬性相剋 (Type Matchups)」。
- **Target Audience:** 透過遊戲化激勵自己突破 PR (Personal Record) 的健身愛好者。

---

## 2. 技術堆疊 (Tech Stack)

- **Frontend:** Flutter (Dart) - 需支援 iOS HealthKit 與 Android Health Connect。
- **State Management:** Riverpod 或 Bloc。
- **Backend:** Firebase (Auth, Firestore, Cloud Functions)。
  - Realtime Database 用於團體戰同步。
- **Local Storage:** Hive or Isar (用於離線戰鬥數據緩存)。
- **Hardware Integration:**
  - iOS: `health` package (取得 Workout Session 與 Heart Rate) / HealthKit。
  - Android: Health Connect API。

---

## 3. 核心資料模型 (Data Models)

### 3.1 User Profile (Player)

```json
{
  "uid": "string",
  "level": "int",
  "exp": "int",
  "hp": "int",
  "pp": "int",
  "attributes": {
    "str": "int",
    "end": "int",
    "crt": "double"
  },
  "benchmarks": {
    "squat_5rm": "double",
    "bench_5rm": "double",
    "deadlift_5rm": "double",
    "ohp_5rm": "double"
  },
  "unlocked_moves": ["push_up", "bench_press", "squat"],
  "inventory": {
    "potion": "int",
    "ether": "int",
    "rare_candy": "int"
  },
  "weekly_frequency": "int",
  "training_history": [
    {
      "date": "ISO8601",
      "gym_type": "STRENGTH | HYPERTROPHY",
      "muscle_groups": ["FIRE", "ELECTRIC"],
      "total_volume": "double",
      "result": "WIN | LOSE"
    }
  ]
}
```

- **level:** 玩家等級
- **exp:** 累積經驗值
- **hp:** 玩家生命值 (力竭/被反擊時扣減)
- **pp:** 體力值 (每組動作消耗，Zone 5 額外消耗)
- **attributes:**
  - `str`: 力量 (影響物理攻擊)
  - `end`: 耐力 (影響 HP/PP 上限)
  - `crt`: 爆擊率 (由心率影響)
- **benchmarks:** 核心動作的 5RM 基準值

### 3.2 Move (Exercise/Skill)

```json
{
  "id": "bench_press",
  "name": "Barbell Bench Press",
  "name_zh": "槓鈴臥推",
  "type": "FIRE",
  "base_power": 100,
  "scaling_stat": "bench_5rm",
  "pp_cost": 10,
  "unlock_requirement": "level_5 OR item_tm_01",
  "evolution_chain": ["push_up", "bench_press", "incline_db_press"]
}
```

- **type:** 屬性 (對應肌群，見 4.1)
- **scaling_stat:** 該動作對應的 5RM 基準值欄位
- **pp_cost:** 每次使用消耗的 PP
- **evolution_chain:** 招式進化鏈 (例：伏地挺身 → 槓鈴臥推 → 啞鈴上斜臥推)

### 3.3 Enemy (Boss/Minion)

```json
{
  "id": "enemy_001",
  "name": "Geodude",
  "type": ["ROCK", "GROUND"],
  "role": "MINION",
  "stats": {
    "hp": "int",
    "defense": "int",
    "attack": "int",
    "evasion": "int"
  }
}
```

- **role:** `MINION` (熱身小怪), `MID_BOSS` (容量中 Boss), `GYM_LEADER` (道館主)
- **defense:** 防禦力 (力量道館的 Gym Leader 防禦極高)
- **attack:** 攻擊力 (力竭時反擊玩家用)

---

## 4. 遊戲機制與演算法 (Game Mechanics & Algorithms)

### 4.1 屬性相剋系統 (Type Effectiveness)

將肌群映射為寶可夢屬性，建立相剋關係：

| 肌群 | 屬性 | 剋制 (Super Effective 1.5x) | 被剋 (Not Effective 0.5x) |
|------|------|---------------------------|--------------------------|
| 胸 (Chest) | 火 (FIRE) | 草 (GRASS) | 水 (WATER) |
| 背 (Back) | 水 (WATER) | 火 (FIRE) | 電 (ELECTRIC) |
| 腿 (Legs) | 岩石/地面 (ROCK/GROUND) | 電 (ELECTRIC) | 水/草 (WATER/GRASS) |
| 肩 (Shoulders) | 電 (ELECTRIC) | 飛行 (FLYING) | 地 (GROUND) |
| 手臂/核心 (Arms/Core) | 格鬥 (FIGHTING) | 一般 (NORMAL) | 超能 (PSYCHIC) |

**戰鬥邏輯範例：** 若今日課表為「練胸」，系統會生成「草系」的道館主，迫使玩家使用「火系招式 (臥推)」來取得 1.5x 傷害加成。

### 4.2 角色狀態與基準 (Base Stats & Benchmark)

- **基準設定 (Calibration):** 玩家初次遊玩需輸入核心動作（深蹲、臥推、硬舉、肩推）的 **5RM** 數值。5RM 代表玩家當前的「攻擊力上限」。
- **漸進式超負荷 (Progressive Overload):** 若玩家在訓練中成功突破原有的 5RM（例如原本 100kg 做 5 下，今天做了 6 下或加重到 102.5kg），系統判定為「進化 (Evolution)」，觸發進化動畫，提升角色基礎攻擊力，並更新 5RM 數據。
- **Epley 公式：** 使用 `Estimated_1RM = Weight × (1 + Reps / 30)` 來判定是否突破紀錄。

### 4.3 戰鬥流程 (The Battle Loop - 3 Stages)

每次訓練 Session 固定生成 3 個階段：

#### Stage 1: The Minion (熱身階段 / Warm-up)

- **敵人:** 小拳石、綠毛蟲等級的小怪。
- **特徵:** 低 HP，低攻擊力。
- **通關條件:** 完成指定次數的熱身組 (輕重量)。
- **目的:** 喚醒肌肉，累積初始 PP (能量)。

#### Stage 2: The Mid-Boss (容量階段 / Hypertrophy)

- **敵人:** 豪力、隆隆石等級的中型怪。
- **特徵:** 高 HP (血牛)，中等防禦。
- **通關條件:** 累積足夠的 Volume (訓練容量 = 重量 × 次數 × 組數) 才能削減其血量。
- **適合動作:** 8-12 RM 的肌肥大組。

#### Stage 3: The Gym Leader (核心訓練 / Main Lift)

玩家在開始訓練前選擇「道館類型」，決定 Gym Leader 的數值分配：

**A. 力量道館 (Titan's Gym / Strength Gym) - 最大肌力取向**

- **Boss:** 像是大鋼蛇 (Steelix)。
- **數值:** HP 中等，DEF (防禦) 極高。
- **傷害判定:** 單發傷害 (`Hit_Damage`) 必須大於 `Boss_Def` 才能造成傷害。
- **邏輯:** 強迫玩家做大重量 (1-5 RM)。輕重量多次數會顯示 "It's not very effective..." (不破防)。
- **適合訓練:** 大重量、低次數、長休息。
- **對應指標:** 強度 (% of 1RM) > 總容量。

**B. 體格道館 (Colossus Gym / Hypertrophy Gym) - 肌肥大/容量取向**

- **Boss:** 像是卡比獸 (Snorlax)。
- **數值:** HP 極高，DEF 低。
- **傷害判定:** 只要有動都有傷，重點是累積總傷害量 (`Total_Damage`)。
- **邏輯:** 強迫玩家做多組數、力竭組。
- **適合訓練:** 中重量、中高次數 (8-12+ Reps)、短休息。
- **對應指標:** 總容量 (Volume) > 強度。

### 4.4 傷害計算公式 (The Damage Formula) v2.0

系統需實作此核心函式。

**Input:**

| 參數 | 說明 |
|------|------|
| `User_Weight` | 實際負重 (kg) |
| `User_Reps` | 次數 |
| `User_5RM` | 該動作對應的 5RM 基準 |
| `Heart_Rate` | 即時心率 (bpm) |
| `Move_Type` | 動作屬性 |
| `Enemy_Type` | 敵人屬性 |

**Step 1 - 強度係數 (Intensity Factor):**

```
Intensity = User_Weight / User_5RM
```

> 例: 100kg 5RM, 做 90kg → Intensity = 0.9

**Step 2 - 屬性加成 (Type Multiplier):**

| 關係 | 倍率 |
|------|------|
| Super Effective (剋制) | 1.5x |
| Neutral | 1.0x |
| Not Very Effective (被剋) | 0.5x |

**Step 3 - 心率爆擊 (Heart Rate Critical):**

| 心率區間 | 倍率 | 效果 |
|----------|------|------|
| Zone 1-2 (<60% max HR) | 1.0x | 穩定傷害，無加成 |
| Zone 3-4 (70-85% max HR) | 1.2x | Critical Hit (爆擊率 +30%) |
| Zone 5 (>85% max HR) | 1.5x | Dynamax Mode (傷害翻倍，但每回合扣自身 5% HP) |

> 判定邏輯：系統偵測到一組動作結束後的「峰值心率」來結算該回合傷害加成。

**Step 4 - 單發基礎傷害 (Base Hit Damage):**

```
Hit_Damage = (Intensity × 100) × Type_Mult × Heart_Mult
```

**Step 5 - 最終結算 (Final Calculation per Turn):**

Scenario A (Strength Gym - 力量道館):
```python
if Hit_Damage > Boss_Def:
    Total_Damage = (Hit_Damage - Boss_Def) * User_Reps
else:
    Total_Damage = 0  # 攻擊無效 - "It's not very effective..."
```

Scenario B (Hypertrophy Gym - 體格道館):
```python
Total_Damage = Hit_Damage * User_Reps
```

### 4.5 訓練排程演算法 (Scheduler Algorithm)

系統根據用戶輸入的「每週訓練頻率」自動生成對手與屬性：

#### 低頻率 < 3次/週 (Low Frequency)

- **模式:** 全身訓練 (Full Body)。
- **對手陣容:** 混合屬性隊伍 (Mixed Types)。
- **流程:** 需切換不同屬性招式 (胸 → 背 → 腿) 才能有效擊敗對手。

#### 高頻率 >= 3次/週 (High Frequency)

- **模式:** 分化訓練 (Split Routine - Push/Pull/Legs 或五分化)。
- **邏輯:** 確保同一肌群 (屬性) 每週至少被刺激兩次。
- **範例 (三分化 Push/Pull/Legs):**
  - Day 1: 推 (胸/肩/三頭) → 對戰「草/蟲」系道館
  - Day 2: 拉 (背/二頭) → 對戰「火/岩」系道館
  - Day 3: 腿 → 對戰「電」系道館
  - Day 4: 休息 (寶可夢中心恢復)
  - Day 5: 循環 Day 1

#### 推薦演算法

```
if Last_Workout_Date < 2 days ago:
    推薦 Split Routine (分化道館)
elif Last_Workout_Date > 3 days ago:
    推薦 Full Body (混合屬性道館)
```

### 4.6 漸進式超負荷系統 (Progressive Overload Trigger)

- **自動校正:** 若玩家在任一組的 `Estimated_1RM` (使用 Epley 公式計算) 超過系統紀錄的 `Current_Max`。
- **事件:** 戰鬥結束後觸發「進化動畫 (Evolution)」。
- **結果:** 更新 User Profile 的 5RM 數值，升級 Base Stats。

---

## 5. 延伸遊戲系統 (Extended Game Systems)

### 5.1 狀態異常與力竭 (Status Effects & Failure Mechanics)

- **力竭 (Failure):** 若該組未達目標次數（例如目標 10 下只做 6 下），判定為「招式未命中 (Miss)」或「被 Boss 反擊 (Counter)」，玩家扣血 (HP)。
- **戰鬥失敗:** 如果玩家 HP 歸零，戰鬥失敗，只能獲得一半經驗值。
- **受傷風險 (Injury Risk):** 若心率長期處於 Zone 5 且姿勢不穩 (需未來整合動態捕捉)，玩家陷入「混亂」狀態，命中率大幅下降。

### 5.2 道具系統 (Items)

| 道具 | 遊戲名 | 效果 | 獲取方式 |
|------|--------|------|----------|
| 傷藥 | Potion | 延長組間休息時間而不降低戰鬥評價。App 內的休息計時器暫停。 | 戰鬥獎勵、商店 |
| PP 回復劑 | Ether | 攝取 BCAA/碳水飲品 (需手動確認)，回復戰鬥體力 (PP)。 | 手動確認攝取 |
| 神奇糖果 | Rare Candy | 可用於升級特定招式等級。 | 攝取高蛋白餐或欺騙餐 (Cheat Meal)，手動輸入照片/紀錄 |

### 5.3 招式與升級系統 (Moves & Progression)

- **招式 (Moves):** 即具體的健身動作 (如：槓鈴臥推、啞鈴划船)。
- **初始招式:** 玩家初始只有基礎招式 (如：伏地挺身、徒手深蹲)。
- **解鎖機制:**
  - 擊敗道館主可獲得 `EXP` 和 `招式機 (TM)`。
  - 等級提升或使用招式機可解鎖進階動作。
  - **進化鏈範例：** 伏地挺身 → 槓鈴臥推 → 啞鈴上斜臥推
- **PP (招式次數):** 代表體能。若 PP 耗盡 (體力透支)，需要「PP 回復劑」(如：攝取 BCAA 或碳水)。

### 5.4 招式圖鑑 (Move Pokédex)

將健身動作收集化，類似寶可夢圖鑑但收集的是「動作」。

- **一般動作:** 等級提升解鎖。
- **稀有動作 (如：人體國旗、暴力上槓 Muscle-up):** 需擊敗特定活動 Boss 或達成特定體重比解鎖。
  - 範例：深蹲 2 倍體重 → 解鎖「地震」(Earthquake) 招式。
- 圖鑑記錄每個動作的使用次數、最佳紀錄、解鎖日期。

### 5.5 團體戰 (Raid Battles)

- **週末活動:** 出現超高血量的「傳說寶可夢」(如：超夢)。
- **機制:** 允許組隊。你與朋友當天的總訓練容量 (Total Volume) 加總來扣減 Boss 血量。
- **目的:** 社交激勵，合力擊敗超高難度目標。

### 5.6 心率同步系統 (Heart Rate Sync)

利用穿戴裝置 (Apple Watch / Garmin / 其他) 的即時心率作為爆擊與屬性判定：

- 系統偵測一組動作結束後的「峰值心率」來結算該回合傷害加成。
- 若無穿戴裝置，玩家可手動輸入自覺疲勞度 (RPE 1-10) 作為替代。

---

## 6. UI/UX 規格 (Detailed Screens)

### 6.1 Onboarding & Calibration

- **5RM Input:** 簡單的 Form 輸入深蹲、臥推、硬舉、肩推的當前數據。
- **頻率設定:** 選擇每週訓練次數 (影響排程演算法)。
- **Wearable Sync:** 請求 HealthKit / Google Fit 權限。

### 6.2 Home (The Map)

- 顯示當前位置（地圖 UI），有多個道館可選。
- **Daily Mission:** 根據歷史頻率與排程演算法推薦道館。
- 顯示玩家角色、當前等級、經驗值進度條。

### 6.3 Battle Interface (The Workout)

- **Top Half:** Boss Sprite (2D 像素風)、HP Bar、Boss Name & Attribute 標籤。
- **Bottom Half:** Card-based UI for moves。
  - Card 顯示：招式名稱、屬性圖示、PP 消耗。
  - 範例：Card 1: Barbell Bench Press (Fire) / Card 2: Dumbbell Fly (Fire)
- **Input Action:** 點擊卡片 → 輸入 Weight & Reps → 確認 (播放攻擊動畫)。
- **Live Overlay:** 右上角顯示即時心率與 Zone 顏色 (藍/綠/橘/紅)。
- **預估傷害值:** 根據當前輸入的重量即時顯示預估傷害。

### 6.4 Result Screen (結算畫面)

- 獲得經驗值動畫。
- 升級提示 (Level Up)。
- 新動作解鎖通知 (New Move Learned)。
- 若突破 5RM：觸發「進化動畫 (Evolution)」。

### 6.5 Item Shop & Inventory

- **Potion (休息):** 使用後，App 內的休息計時器暫停。
- **Rare Candy (升級):** 手動輸入「Cheat Meal」或「High Protein Meal」的照片/紀錄來獲得。
- **Ether (PP):** 手動確認攝取補給品來回復 PP。

### 6.6 Move Pokédex (招式圖鑑)

- 列表顯示所有動作，已解鎖/未解鎖狀態。
- 點擊可查看動作詳情、使用次數、PR 紀錄。

---

## 7. 資源需求 (Assets Requirements)

> **注意：** 任天堂 (Nintendo) 對版權非常嚴格，若打算上架 App Store，絕對不能直接使用官方的圖片或音樂。必須使用「風格相近」的合法授權素材。

### 7.1 音樂 (Audio)

- **風格:** 8-bit Chiptune 或 JRPG Orchestral。
- **需要的曲目類型:**
  - 主畫面 BGM
  - 戰鬥 BGM (小怪/中 Boss/道館主 各一)
  - 勝利 Jingle
  - 升級/進化 Jingle

**合法素材來源 (Royalty Free / Creative Commons):**

| 來源 | 說明 |
|------|------|
| [OpenGameArt.org](https://opengameart.org) | 搜尋 "JRPG Battle" 或 "8-bit"，免費戰鬥音樂 |
| [Peritune](https://peritune.com) | 日本免費音樂素材網，RPG 風格音樂 |
| [Maoudamashii (魔王魂)](https://maou.audio) | 知名日本遊戲音樂素材，戰鬥曲風熱血 |

**風格參考 (僅供開發測試，不可商用):**

| 來源 | 說明 |
|------|------|
| GlitchxCity (YouTube) | 高品質寶可夢 Remix |
| Zame (YouTube) | 各代寶可夢音樂重製 |

**YouTube 搜尋關鍵字:** `Pokemon Battle Music Theme`, `Gym Leader Theme Remix`, `8-bit Battle Music Royalty Free`

### 7.2 圖片 (Visuals)

- **風格:** Pixel Art (像素風) - 角色設計必須原創。

**合法素材來源:**

| 來源 | 說明 |
|------|------|
| [Itch.io Game Assets](https://itch.io/game-assets) | 搜尋 "Monster Sprites" 或 "Pixel Art Monsters"，獨立畫師的怪獸包 |
| [Kenney Assets](https://kenney.nl) | 免費且可商用的通用遊戲素材 (UI、圖示) |
| Creature Mixer | 可以自己組合怪獸部件 |

**僅供參考學習 (嚴禁直接使用):**

| 來源 | 說明 |
|------|------|
| The Spriters Resource | 所有寶可夢原始圖檔，僅供參考結構與配色 |

---

## 8. 未來擴充 (Backlog) - MVP 不實作

- **選美大會 (Contest Hall):** 強調柔軟度與伸展 (Flexibility)，判斷數據改為心率變異度 (HRV) 與持續時間。
- **瑜珈塔 (Zen Tower):** 強調肌肉控制與核心穩定 (Stability)。
- **團體戰完整版 (Raid Battle):** 多人連線即時同步，加總全隊 Volume 攻擊 Boss。
- **動態捕捉整合:** 判斷姿勢正確性，影響命中率。

---

## 9. 開發階段 (Development Phases)

### Phase 1 - Core Logic (核心邏輯)
- 實作 5RM 換算傷害公式。
- Python 模擬腳本驗證數值平衡。
- 定義所有招式、敵人、屬性相剋的資料表。

### Phase 2 - Basic App (基礎 App)
- Flutter UI 搭建。
- 靜態數據輸入 (不接手錶)。
- 完成單人戰鬥流程 (3 階段)。
- Onboarding 流程 (5RM 輸入)。

### Phase 3 - Gamification (遊戲化系統)
- 經驗值與升級系統。
- 解鎖招式與招式圖鑑。
- 道具系統 (Potion / Ether / Rare Candy)。
- 訓練排程演算法。
- 漸進式超負荷偵測與進化動畫。

### Phase 4 - Wearable Integration (穿戴裝置)
- 整合 HealthKit / Health Connect 讀取心率。
- 加入心率 Zone 加成機制。
- 即時心率 HUD 顯示。

---

## Appendix A: 傷害公式驗證腳本 (Python Simulation)

```python
class PokeGymBattle:
    def __init__(self, user_5rm, gym_type="HYPERTROPHY"):
        self.user_5rm = user_5rm
        self.gym_type = gym_type

        if gym_type == "STRENGTH":
            self.boss_hp = 500
            self.boss_defense = 80
            print(f"--- 進入力量道館 (BOSS: 鐵甲暴龍) ---")
            print(f"BOSS 狀態: HP {self.boss_hp} | 防禦 {self.boss_defense}")
        else:
            self.boss_hp = 2000
            self.boss_defense = 20
            print(f"--- 進入肌肥大道館 (BOSS: 卡比獸) ---")
            print(f"BOSS 狀態: HP {self.boss_hp} | 防禦 {self.boss_defense}")

    def perform_set(self, weight, reps, heart_rate_zone):
        intensity = weight / self.user_5rm
        base_attack = 100
        single_hit_damage = base_attack * intensity

        crit_multiplier = 1.0
        msg = ""
        if heart_rate_zone >= 4:
            crit_multiplier = 1.5
            msg = "⚡ 爆擊! (心率高)"
        elif heart_rate_zone >= 3:
            crit_multiplier = 1.2
            msg = "🔥 效果絕佳!"

        final_single_hit = single_hit_damage * crit_multiplier

        damage_dealt = 0
        if final_single_hit > self.boss_defense:
            damage_dealt = (final_single_hit - self.boss_defense) * reps
        else:
            print(f"❌ 攻擊無效! 重量太輕 ({weight}kg)，無法擊穿 BOSS 厚皮 (防禦 {self.boss_defense})")
            return

        self.boss_hp -= damage_dealt
        self.boss_hp = max(0, self.boss_hp)

        print(f"動作: {weight}kg x {reps}下 | 心率區間: Z{heart_rate_zone}")
        print(f"結果: 造成 {int(damage_dealt)} 點傷害 {msg}")
        print(f"BOSS 剩餘 HP: {int(self.boss_hp)}\n")


# --- 模擬測試 ---
player_5rm = 100  # 玩家深蹲 5RM 為 100kg

# 情境 A: 挑戰力量道館 (BOSS 防禦高)
battle_str = PokeGymBattle(player_5rm, "STRENGTH")
battle_str.perform_set(weight=50, reps=12, heart_rate_zone=2)   # 輕重量 -> 打不動
battle_str.perform_set(weight=90, reps=3, heart_rate_zone=4)    # 大重量 -> 有效

print("-" * 30)

# 情境 B: 挑戰肌肥大道館 (BOSS 血超厚)
battle_hyp = PokeGymBattle(player_5rm, "HYPERTROPHY")
battle_hyp.perform_set(weight=90, reps=3, heart_rate_zone=4)    # 高傷但次數少
battle_hyp.perform_set(weight=70, reps=12, heart_rate_zone=3)   # 中重量多次數 -> 高總傷
```

**預期結果驗證：**

- **力量道館:** 50kg 輕重量 → 攻擊無效 (不破防)。90kg 大重量 + Z4 心率 → 有效傷害。
- **肌肥大道館:** 90kg × 3 下 → 總傷較低；70kg × 12 下 → 總傷較高，鼓勵累積容量。
- **心率:** 大重量時心率飆高 → Critical Hit 1.5x 獎勵，符合現實體感。
