# Important Constraints and Guidelines

## Development Constraints

### 日付制約
- **現在日以降に進めない**: `currentDate`は今日より先の日付に設定できない
- チェック方法: `Calendar.current.isDateInToday(currentDate)`
- ユーザーは過去の日付を選択して記録できるが、未来の日付は選択不可

### データ制約
- **1日1回のみ登録可能**: 同じ日に複数の天気記録を登録できない
- 既存のレコードがある日付には、登録ボタンが無効化される
- 重複チェックは `Calendar.current.isDate(_:inSameDayAs:)` で実施

### 画像アセット
- **必須アセット**: `Assets.xcassets/cloud.png` がアプリにバンドルされている必要がある
- アセットの変更時は、Xcodeプロジェクトで正しく参照されているか確認

## Performance Considerations

### CalendarViewの最適化
- CalendarViewでは不要な再計算を削減する実装がされている
- コミット履歴参照: "CalendarViewの不要な再計算を削減" (commit: 5a5ee89)

## Project Workflow Rules

### ドキュメント管理 (最重要！)
**プロジェクトの運用ルール:**
- コード変更を行った場合は、**必ず `GEMINI.md` ファイルを更新する**
- これはプロジェクトの明示的な運用ルールです
- CLAUDE.mdも必要に応じて更新

### ブランチ戦略
- メインブランチ: `main`
- 開発ブランチ: `develop` が存在
- フィーチャー実装時はブランチを作成してPRを作成

### コミットメッセージ
- 日本語で明確に記述
- 例: "アプリアイコンを追加", "カレンダータブを追加"

## Data Migration Considerations
- UserDefaultsを使用しているため、アプリアップデート時のデータ移行を考慮
- `DailyWeatherRecord` の構造変更時は、既存データとの互換性を維持
- Codableプロトコルの変更には特に注意

## Testing Strategy (将来)
現時点ではテストが未実装ですが、将来的には以下をテスト対象とすべき:
- `DailyWeatherStorage` の永続化ロジック
- 雨の日のパーセンテージ計算
- 日付制約のロジック
- 重複登録防止のロジック
