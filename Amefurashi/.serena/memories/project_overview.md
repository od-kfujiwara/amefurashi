# Amefurashi Project Overview

## Purpose
Amefurashiは、天気を記録するシンプルなSwiftUIアプリケーションです。ユーザーは毎日の天気を選択して登録でき、過去の天気記録から雨の日の割合を確認できます。

## Tech Stack
- **Language**: Swift
- **Framework**: SwiftUI
- **Platform**: iOS
- **Build System**: Xcode (xcodebuild)
- **Persistence**: UserDefaults (JSON encoding)
- **Architecture Pattern**: MVVM with ObservableObject

## Project Structure
```
Amefurashi/
├── AmefurashiApp.swift          # アプリケーションのエントリーポイント
├── ContentView.swift             # タブベースのメインコンテナ
├── HomeView.swift                # 天気登録のメイン画面
├── CalendarView.swift            # カレンダー画面
├── DailyWeatherRecord.swift      # データモデル (WeatherType enum + DailyWeatherRecord struct)
├── DailyWeatherStorage.swift     # 永続化クラス (ObservableObject)
├── Assets.xcassets/              # 画像アセット
├── CLAUDE.md                     # Claude Code用ガイダンス
└── GEMINI.md                     # Gemini用ガイダンス
```

## Key Components
### Data Layer
- **DailyWeatherStorage**: UserDefaultsを使用した永続化 (ObservableObject)
- **DailyWeatherRecord**: 日付と天気タイプを保持 (Identifiable, Codable)
- **WeatherType**: 4つの天気タイプ (sunny, cloudy, lightRain, heavyRain) - SF Symbolsアイコンと日本語ラベル付き

### UI Layer
- **HomeView**: メイン画面 - 日付選択、天気登録、雨の日の割合表示
- **CalendarView**: カレンダー表示画面 (現在実装中)
- **ContentView**: タブベースのナビゲーション

## Data Flow
1. DailyWeatherStorageが@Published var dailyRecordsを管理
2. didSetでUserDefaultsに自動保存 (JSON encoding)
3. SwiftUIの@StateObjectと@Publishedで自動的にUI更新
4. 初期化時にUserDefaultsからデータ読み込み
