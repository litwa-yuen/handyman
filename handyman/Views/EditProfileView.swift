import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppStateViewModel
    @State private var displayName: String = ""
    @State private var originalDisplayName: String = ""
    @State private var isSaving = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                TextField("Display name", text: $displayName)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(false)
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let initial = appState.displayName ?? ""
            displayName = initial
            originalDisplayName = initial
        }
        .onDisappear {
            Task { await handleBack() }
        }
    }

    private func save() async throws {
        do {
            try await AuthenicationManager.shared.updateCurrentUserDisplayName(displayName)
            
        } catch {
            throw error
        }
    }

    private func handleBack() async {
        let newName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let oldName = originalDisplayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !newName.isEmpty && newName != oldName {
            appState.displayName = displayName
            await (try? save())
        }
        dismiss()
    }
}
