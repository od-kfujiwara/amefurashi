# Task Completion Checklist

## タスク完了時の確認事項

### 1. コードの動作確認
- [ ] Xcodeでビルドエラーがないことを確認
- [ ] シミュレータで動作確認
- [ ] 既存機能が壊れていないことを確認

### 2. コード品質
- [ ] コーディング規約に従っている
- [ ] 適切な命名規則を使用している
- [ ] 不要なコメントやデバッグコードを削除

### 3. ドキュメント更新 (重要！)
- [ ] **GEMINI.mdファイルを更新する** (プロジェクトの運用ルール)
- [ ] 必要に応じてCLAUDE.mdも更新

### 4. Git操作
```bash
# 変更内容の確認
git status
git diff

# コミット
git add .
git commit -m "適切なコミットメッセージ"

# プッシュ (必要に応じて)
git push
```

### 5. ビルドコマンド
```bash
# 最終確認のビルド
cd /Users/kohei/Desktop/dev/Amefurashi
xcodebuild -project Amefurashi.xcodeproj -scheme Amefurashi -configuration Debug build
```

## 注意事項
- **最重要**: コード変更を行った場合は、必ずGEMINI.mdファイルを更新する
- 画像アセット変更時は、Assets.xcassetsの整合性を確認
- UserDefaults依存のコードは、データ移行への影響を考慮
