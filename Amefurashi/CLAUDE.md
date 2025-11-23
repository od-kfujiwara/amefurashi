# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

Amefurashiは、天気を記録するシンプルなSwiftUIアプリケーションです。ユーザーは毎日の天気を選択して登録でき、過去の天気記録から雨の日の割合を確認できます。

## ビルド・実行コマンド

```bash
# プロジェクトのビルド
cd /Users/kohei/Desktop/dev/Amefurashi
xcodebuild -project Amefurashi.xcodeproj -scheme Amefurashi -configuration Debug build

# シミュレータでのビルド・実行
xcodebuild -project Amefurashi.xcodeproj -scheme Amefurashi -destination 'platform=iOS Simulator,name=iPhone 15' build

# Xcodeで開く
open Amefurashi.xcodeproj
```

## アーキテクチャ

### ディレクトリ構造

```
Amefurashi/
├── App/
│   └── AmefurashiApp.swift          # アプリケーションエントリーポイント
├── Views/
│   ├── ContentView.swift            # タブコンテナ
│   ├── HomeView.swift               # 天気登録画面
│   └── CalendarView.swift           # カレンダー表示画面
├── Models/
│   └── DailyWeatherRecord.swift     # データモデル
├── Storage/
│   └── DailyWeatherStorage.swift    # データ永続化層 + ビジネスロジック
├── Utilities/
│   └── DateFormatters.swift         # 日付フォーマット用ユーティリティ
└── Assets.xcassets/
```

### データフロー

1. **永続化層**: `Storage/DailyWeatherStorage`がUserDefaultsを使用して天気記録を自動的に保存・読み込み
2. **データモデル**: `Models/DailyWeatherRecord`が日付と天気タイプ(`WeatherType`)を保持
3. **UI層**: SwiftUIの`@StateObject`と`@Published`を使用した自動的なUI更新

### 主要コンポーネント

#### App層
- **App/AmefurashiApp.swift**: アプリケーションのエントリーポイント

#### Views層
- **Views/ContentView.swift**: タブベースのメインコンテナ
- **Views/HomeView.swift**: 天気登録のメイン画面
  - 日付選択機能(前日・翌日への移動、今日より先には移動不可)
  - 天気タイプ選択ボタン(晴れ・曇り・小雨・大雨)
  - 雨の日の割合をパーセンテージで表示
  - 1日1回のみ登録可能(重複登録を防止)
- **Views/CalendarView.swift**: カレンダー画面（月次カレンダー表示と天気記録の表示）

#### Models層
- **Models/DailyWeatherRecord.swift**:
  - `WeatherType` enum: 4つの天気タイプ(SF Symbolsアイコンと日本語ラベルを含む)
  - `DailyWeatherRecord` struct: 日付と天気タイプを保持(`Identifiable`, `Codable`)

#### Storage層
- **Storage/DailyWeatherStorage.swift**: UserDefaultsを使用した永続化クラス + ビジネスロジック(`ObservableObject`)
  - `@Published var dailyRecords`の変更を自動的にUserDefaultsに保存
  - `rainyDayPercentage`: 雨の日の割合を計算
  - `hasRecordForDate()`: 指定日の記録存在チェック
  - `addRecordIfNeeded()`: バリデーション付き記録追加
  - `weatherDictionary`: カレンダー表示用の高速検索辞書（O(1)）

#### Utilities層
- **Utilities/DateFormatters.swift**: 日付フォーマット用のシングルトンコレクション
  - `japaneseFullDate`: "YYYY年M月d日(E)"形式
  - `japaneseMonthYear`: "YYYY年M月"形式
  - `dayNumber`: "d"形式
  - パフォーマンス最適化のためDateFormatterを再利用

### データ永続化の仕組み

`DailyWeatherStorage`は`didSet`を使用して、`dailyRecords`配列が更新されるたびに自動的にJSONエンコードしてUserDefaultsに保存します。初期化時には、UserDefaultsからデータを読み込みます。

### UIパターン

- SwiftUIの宣言的UI
- `@StateObject`によるデータストレージの管理
- カスタムビューコンポーネント(`WeatherTypeButton`)の再利用
- NavigationViewとToolbarの使用

## 開発時の注意事項

- **ディレクトリ構造**: ファイルは機能別に整理されています（App/Views/Models/Storage/Utilities）
- **ロジック分離**: ViewはUI表示のみに専念し、ビジネスロジックはStorage層に配置
- **パフォーマンス最適化**:
  - DateFormatterはシングルトンパターンで再利用（Utilities/DateFormatters）
  - カレンダー表示では辞書検索でO(1)のパフォーマンスを実現
- **画像アセット**: `Assets.xcassets/cloud.png`の画像がアプリにバンドルされていることを確認
- **日付制約**: `currentDate`は今日以降に進めない実装になっている(`Calendar.current.isDateInToday(currentDate)`でチェック)
- **重複登録防止**: `DailyWeatherStorage.addRecordIfNeeded()`でバリデーション
- **雨の日の計算**: 小雨(`lightRain`)と大雨(`heavyRain`)の両方を雨の日としてカウント
