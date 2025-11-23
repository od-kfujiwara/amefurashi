# Amefurashi Project Overview

## Purpose
Amefurashiは、天気を記録するシンプルなSwiftUIアプリケーションです。ユーザーは毎日の天気を選択して登録でき、過去の天気記録から雨の日の割合を確認できます。

## Tech Stack
- **Language**: Swift
- **Framework**: SwiftUI
- **Platform**: iOS
- **Build System**: Xcode (xcodebuild)
- **Persistence**: UserDefaults (JSON encoding)
- **Architecture Pattern**: MVVM with ObservableObject (ロジックとViewの分離)

## Project Structure
```
Amefurashi/
├── App/
│   └── AmefurashiApp.swift          # アプリケーションエントリーポイント
├── Views/
│   ├── ContentView.swift            # タブコンテナ
│   ├── HomeView.swift               # 天気登録画面
│   ├── CalendarView.swift           # カレンダー表示画面
│   └── UsernameEditSheet.swift      # ユーザー名編集シート
├── Models/
│   └── DailyWeatherRecord.swift     # データモデル
├── Storage/
│   ├── DailyWeatherStorage.swift    # 天気データ永続化層 + ビジネスロジック
│   └── UserSettingsStorage.swift    # ユーザー設定永続化層
├── Utilities/
│   └── DateFormatters.swift         # 日付フォーマット用ユーティリティ
├── Assets.xcassets/
│   └── cloud.png                    # アメフラシ度表示用の雲画像
└── CLAUDE.md                        # Claude Code用ガイダンス
```

## Key Components
### Data Layer
- **DailyWeatherStorage**: 天気データの永続化クラス + ビジネスロジック (ObservableObject)
  - `@Published var dailyRecords`: 天気記録配列（didSetで自動保存）
  - `rainyDayPercentage`: 雨の日の割合を計算
  - `hasRecordForDate()`: 指定日の記録存在チェック
  - `addRecordIfNeeded()`: バリデーション付き記録追加
  - `weatherDictionary`: カレンダー表示用の高速検索辞書（O(1)）
  
- **UserSettingsStorage**: ユーザー設定の永続化クラス (ObservableObject)
  - `@Published var username`: ユーザー名（didSetで自動保存、デフォルト: "風太郎"）
  
- **DailyWeatherRecord**: 日付と天気タイプを保持 (Identifiable, Codable)
- **WeatherType**: 4つの天気タイプ (sunny, cloudy, lightRain, heavyRain) - SF Symbolsアイコンと日本語ラベル付き

### Utilities Layer
- **DateFormatters**: 日付フォーマット用のシングルトンコレクション
  - `japaneseFullDate`: "YYYY年M月d日(E)"形式
  - `japaneseMonthYear`: "YYYY年M月"形式
  - `dayNumber`: "d"形式
  - パフォーマンス最適化のためDateFormatterを再利用

### UI Layer
- **HomeView**: メイン画面 - ユーザー名表示/編集、日付選択、天気登録、雨の日の割合表示
  - offsetを使わない適切なレイアウト（padding/Spacerベース）
  - ユーザー名編集はSheetモーダルで実装
- **UsernameEditSheet**: ユーザー名編集用のシートビュー
  - NavigationStackベースのフォーム
  - リアルタイム文字数カウンター（20文字制限）
  - バリデーション付き
- **CalendarView**: カレンダー表示画面
  - 月次カレンダー表示と天気記録の表示
  - O(1)の辞書検索でパフォーマンス最適化
- **ContentView**: タブベースのナビゲーション

## Data Flow
1. Storage層が@Published var でデータを管理
2. didSetでUserDefaultsに自動保存 (JSON encoding)
3. SwiftUIの@StateObjectと@Publishedで自動的にUI更新
4. 初期化時にUserDefaultsからデータ読み込み
5. ViewはStorage層のビジネスロジックを呼び出すのみ（ロジック分離）
