
import SwiftUI

struct EditUsernameView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var username: String
    @State private var newUsername: String

    init(username: Binding<String>) {
        _username = username
        _newUsername = State(initialValue: username.wrappedValue)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("新しいユーザー名", text: $newUsername)
            }
            .navigationTitle("ユーザー名を編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        username = newUsername
                        dismiss()
                    }
                }
            }
        }
    }
}
