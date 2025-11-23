# Architecture Details

## Design Patterns

### MVVM Pattern with Logic Separation
Amefurashiは、SwiftUIの推奨パターンに従ったMVVMアーキテクチャを採用しています。
**重要**: ViewはUI表示のみに専念し、ビジネスロジックはStorage層に配置しています。

- **Model**: `DailyWeatherRecord`, `WeatherType`
- **ViewModel**: `DailyWeatherStorage`, `UserSettingsStorage` (ObservableObject)
- **View**: `HomeView`, `CalendarView`, `ContentView`, `UsernameEditSheet`
- **Utilities**: `DateFormatters` (シングルトンパターン)

### Data Persistence Strategy
```swift
// 天気データの永続化
class DailyWeatherStorage: ObservableObject {
    @Published var dailyRecords: [DailyWeatherRecord] {
        didSet {
            if let encoded = try? JSONEncoder().encode(dailyRecords) {
                UserDefaults.standard.set(encoded, forKey: "dailyWeatherRecords")
            }
        }
    }
}

// ユーザー設定の永続化
class UserSettingsStorage: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
}
```

**特徴:**
- `didSet` によるリアクティブな永続化
- JSONエンコーディングでCodableプロトコルを活用
- UserDefaultsのキー: `"dailyWeatherRecords"`, `"username"`

### State Management
- `@StateObject`: ビュー所有のObservableObjectインスタンス管理（ContentViewで初期化）
- `@EnvironmentObject`: 子ビューへのインスタンス注入
- `@Published`: プロパティ変更の自動通知
- `@State`: ビューローカルな状態管理（Sheet表示フラグなど）

### Performance Optimizations

#### DateFormatter Singleton Pattern
```swift
enum DateFormatters {
    static let japaneseFullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY年M月d日(E)"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
}
```
**目的**: DateFormatterの再作成を避け、パフォーマンスを最適化

#### Calendar Dictionary for O(1) Lookup
```swift
var weatherDictionary: [Date: WeatherType] {
    Dictionary(uniqueKeysWithValues: dailyRecords.map {
        (calendar.startOfDay(for: $0.date), $0.weatherType)
    })
}
```
**目的**: カレンダー表示で42セル × O(n)検索 → O(1)検索に最適化

## Business Logic (Storage Layer)

### 雨の日の計算
```swift
var rainyDayPercentage: Int {
    guard !dailyRecords.isEmpty else { return 0 }
    let rainyDays = dailyRecords.filter {
        $0.weatherType == .lightRain || $0.weatherType == .heavyRain
    }.count
    return Int(Double(rainyDays) / Double(dailyRecords.count) * 100)
}
```

### 重複登録防止
```swift
func hasRecordForDate(_ date: Date) -> Bool {
    let targetDay = calendar.startOfDay(for: date)
    return dailyRecords.contains { record in
        calendar.isDate(record.date, inSameDayAs: targetDay)
    }
}

@discardableResult
func addRecordIfNeeded(_ record: DailyWeatherRecord) -> Bool {
    guard !hasRecordForDate(record.date) else {
        print("すでにこの日の天気を登録済みです")
        return false
    }
    dailyRecords.append(record)
    return true
}
```

### 日付制約
HomeViewで実装:
```swift
Button(action: { /* 翌日 */ })
    .disabled(Calendar.current.isDateInToday(currentDate))
```
今日より先の日付には移動できない

## UI Components

### Custom Components
- **WeatherTypeButton**: 再利用可能な天気選択ボタン（HomeView内で定義）
- **CalendarDayCell**: カレンダーの日付セル（CalendarView内で定義）
- **UsernameEditSheet**: ユーザー名編集用のシートビュー
  - NavigationStackベースのフォーム
  - リアルタイム文字数カウンター（20文字制限）
  - バリデーション付き（空白除去、文字数チェック）

### Layout Best Practices
**重要**: offsetの多用を避け、padding/Spacerでレイアウト調整
- ❌ `.offset(y: -40)` などの多用は避ける（タップ領域とビジュアルがズレる）
- ✅ `VStack(spacing: 0)` + `.padding()` で明示的に間隔制御
- ✅ `Spacer()` で柔軟な間隔調整

### SF Symbols Usage
天気アイコンにはSF Symbolsを使用:
- 晴れ: `"sun.max.fill"`
- 曇り: `"cloud.fill"`
- 小雨: `"cloud.drizzle.fill"`
- 大雨: `"cloud.heavyrain.fill"`
- その他: ユーザー名編集 `"square.and.pencil"`

## User Interactions

### ユーザー名編集フロー
1. HomeViewのユーザー名+アイコンをタップ
2. SheetでUsernameEditSheetが表示
3. リアルタイムバリデーション（文字数カウンター、赤字警告）
4. 「完了」ボタンで保存（無効時はボタン無効化）

### 天気登録フロー
1. 日付を選択（前日/翌日ボタン、今日より先は無効）
2. 天気タイプを選択（4種類のボタン）
3. 「天気を登録する」ボタンで登録
4. 重複チェック（既存の場合はコンソールに警告）
