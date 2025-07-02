import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: Settings
    @Environment(\.dismiss) private var dismiss
    var onResetBoard: (() -> Void)? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Game Settings")) {
                    Toggle("Show Move Hints", isOn: $settings.showMoveHints)
                        .tint(.blue)
                    
                    Toggle("Use Traditional Pieces", isOn: $settings.useTraditionalPieces)
                        .tint(.blue)
                    
                    Button(action: {
                        onResetBoard?()
                    }) {
                        Text("Reset Board")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(settings: Settings())
} 