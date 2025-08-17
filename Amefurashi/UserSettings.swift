
import Foundation

class UserSettings: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }

    init() {
        self.username = UserDefaults.standard.string(forKey: "username") ?? "風太郎"
    }
}
