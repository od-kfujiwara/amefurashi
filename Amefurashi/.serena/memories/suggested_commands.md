# Suggested Commands for Amefurashi

## Build Commands
```bash
# プロジェクトのビルド
cd /Users/kohei/Desktop/dev/Amefurashi
xcodebuild -project Amefurashi.xcodeproj -scheme Amefurashi -configuration Debug build

# シミュレータでのビルド・実行
xcodebuild -project Amefurashi.xcodeproj -scheme Amefurashi -destination 'platform=iOS Simulator,name=iPhone 15' build

# Xcodeで開く
open Amefurashi.xcodeproj
```

## Testing
現時点でテストは未実装です。

## Formatting & Linting
現時点でSwiftLintなどの設定ファイルは見つかりませんでした。
コードスタイルはXcodeのデフォルトに従っています。

## Git Commands (macOS/Darwin)
```bash
# 基本的なGitコマンド
git status
git add .
git commit -m "message"
git push
git pull
git log --oneline -10

# ブランチ操作
git branch
git checkout -b new-branch
git merge branch-name
```

## File System Commands (macOS/Darwin)
```bash
# ディレクトリ操作
ls -la                    # ファイル一覧表示
cd directory/             # ディレクトリ移動
pwd                       # 現在のディレクトリ表示
mkdir directory_name      # ディレクトリ作成

# ファイル操作
cat filename              # ファイル内容表示
grep "pattern" file       # パターン検索
find . -name "*.swift"    # ファイル検索
```

## iOS Simulator Commands
```bash
# シミュレータ一覧
xcrun simctl list devices

# 特定のシミュレータで実行
xcodebuild -project Amefurashi.xcodeproj -scheme Amefurashi \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -configuration Debug build
```
