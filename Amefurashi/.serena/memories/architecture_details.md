# Architecture Details

## Design Patterns

### MVVM Pattern
Amefurashiは、SwiftUIの推奨パターンに従ったMVVMアーキテクチャを採用しています。

- **Model**: `DailyWeatherRecord`, `WeatherType`
- **ViewModel**: `DailyWeatherStorage` (ObservableObject)
- **View**: `HomeView`, `CalendarView`, `ContentView`

### Data Persistence Strategy
```swift
class DailyWeatherStorage: ObservableObject {
    @Published var dailyRecords: [DailyWeatherRecord] {
        didSet {
            // 自動保存: didSetを使用してUserDefaultsに保存
            if let encoded = try? JSONEncoder().encode(dailyRecords) {
                UserDefaults.standard.set(encoded, forKey: "dailyWeatherRecords")
            }
        }
    }
}
```

**特徴:**
- `didSet` によるリアクティブな永続化
- JSONエンコーディングでCodableプロトコルを活用
- UserDefaultsのキー: `"dailyWeatherRecords"`

### State Management
- `@StateObject`: ビュー所有のObservableObjectインスタンス管理
- `@Published`: プロパティ変更の自動通知
- `@State`: ビューローカルな状態管理

## Business Logic

### 日付制約
```swift
// 今日より先の日付には移動できない
if !Calendar.current.isDateInToday(currentDate) {
    // 翌日ボタンを有効化
}
```

### 重複登録防止
```swift
// 同じ日に複数回登録できないようチェック
if dailyWeatherStorage.dailyRecords.contains(where: { record in
    Calendar.current.isDate(record.date, inSameDayAs: currentDate)
}) {
    // 登録ボタンを無効化
}
```

### 雨の日の計算
```swift
var rainyDayPercentage: Double {
    let rainyDays = dailyRecords.filter { record in
        record.weatherType == .lightRain || record.weatherType == .heavyRain
    }.count
    return Double(rainyDays) / Double(totalDays) * 100
}
```

**ルール:**
- 小雨 (`lightRain`) と大雨 (`heavyRain`) の両方を雨の日としてカウント
- パーセンテージで表示

## UI Components

### Custom Components
- **WeatherTypeButton**: 再利用可能な天気選択ボタン
- **CalendarDayCell**: カレンダーの日付セル (CalendarView内)

### SF Symbols Usage
天気アイコンにはSF Symbolsを使用:
- 晴れ: `"sun.max.fill"`
- 曇り: `"cloud.fill"`
- 小雨: `"cloud.drizzle.fill"`
- 大雨: `"cloud.heavyrain.fill"`

## Future Considerations
- CalendarViewの完全実装 (現在は基本構造のみ)
- テストの追加
- データエクスポート機能
- より高度な統計機能
