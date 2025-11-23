import SwiftUI

struct UsernameEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var username: String

    @State private var editedUsername: String
    @FocusState private var isTextFieldFocused: Bool

    private let maxLength = 20

    init(username: Binding<String>) {
        self._username = username
        self._editedUsername = State(initialValue: username.wrappedValue)
    }

    private var isValid: Bool {
        let trimmed = editedUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count <= maxLength
    }

    private var characterCount: Int {
        editedUsername.count
    }

    private var characterCountColor: Color {
        characterCount > maxLength ? .red : .gray
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("ユーザー名", text: $editedUsername)
                        .focused($isTextFieldFocused)
                        .autocorrectionDisabled()

                    HStack {
                        Spacer()
                        Text("\(characterCount)/\(maxLength)文字")
                            .font(.caption)
                            .foregroundColor(characterCountColor)
                    }

                    if characterCount > maxLength {
                        Text("ユーザー名は\(maxLength)文字以内にしてください")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                } footer: {
                    Text("ユーザー名は1文字以上\(maxLength)文字以内で入力してください")
                }
            }
            .navigationTitle("ユーザー名を編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") {
                        saveAndDismiss()
                    }
                    .disabled(!isValid)
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
        }
    }

    private func saveAndDismiss() {
        let trimmed = editedUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && trimmed.count <= maxLength {
            username = trimmed
            dismiss()
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var username = "風太郎"

        var body: some View {
            UsernameEditSheet(username: $username)
        }
    }

    return PreviewWrapper()
}
