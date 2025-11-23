import Foundation

/// ユーザー設定を管理するストレージクラス
class UserSettingsStorage: ObservableObject {
    /// ユーザー名（変更時に自動的にUserDefaultsに保存）
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }

    init() {
        // UserDefaultsから読み込み、存在しない場合はデフォルト値を使用
        self.username = UserDefaults.standard.string(forKey: "username") ?? "風太郎"
    }
}
