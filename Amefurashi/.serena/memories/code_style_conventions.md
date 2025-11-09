# Code Style and Conventions

## Naming Conventions
- **Classes/Structs/Enums**: PascalCase (例: `DailyWeatherStorage`, `WeatherType`, `HomeView`)
- **Properties/Variables**: camelCase (例: `dailyRecords`, `selectedWeather`, `currentDate`)
- **Functions/Methods**: camelCase (例: `rainyDayPercentage`, `dateFormatter`)
- **Enum Cases**: camelCase (例: `sunny`, `cloudy`, `lightRain`, `heavyRain`)

## Swift Code Style
### Property Definitions
```swift
// @State, @Published, @StateObject などのプロパティラッパーを適切に使用
@State private var selectedWeather: WeatherType?
@Published var dailyRecords: [DailyWeatherRecord]
@StateObject private var dailyWeatherStorage = DailyWeatherStorage()
```

### Computed Properties
```swift
// 計算プロパティは var で定義し、型を明示
var rainyDayPercentage: Double {
    // implementation
}
```

### Enum Patterns
```swift
// Enumは適切なプロトコル準拠を明記
enum WeatherType: String, Codable, CaseIterable {
    case sunny, cloudy, lightRain, heavyRain
    
    // 計算プロパティでUI表示用の値を提供
    var iconName: String { /* ... */ }
    var label: String { /* ... */ }
}
```

### SwiftUI View Structure
```swift
struct SomeView: View {
    // 1. Property wrappers (@State, @Binding, etc.)
    @State private var someState: Type
    
    // 2. Regular properties
    let someProperty: Type
    
    // 3. Computed properties
    var computedValue: Type { /* ... */ }
    
    // 4. body
    var body: some View {
        // View hierarchy
    }
}
```

## Documentation
- コード内のコメントは必要最小限
- 複雑なロジックには適切なコメントを追加
- 日本語のコメントとラベルを使用 (UI表示文字列は日本語)

## SwiftUI Patterns
- `@StateObject` でデータストレージを管理
- `@Published` で状態変更を通知
- カスタムビューコンポーネントの再利用 (例: `WeatherTypeButton`)
- NavigationViewとToolbarの活用

## File Organization
- 1ファイル = 1主要コンポーネント (例外: 小さな補助構造体は同じファイルに含めてもよい)
- 関連する型は同じファイルにまとめる (例: `WeatherType` と `DailyWeatherRecord`)
