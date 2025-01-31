import SwiftUI

struct ChirpFailView: View {
    var body: some View {
        if #available(macOS 14.0, *) {
            ContentUnavailableView (
                "Failed to load chirps",
                systemImage: "exclamationmark.circle.fill",
                description: Text("Please check your internet connection")
            )
        } else {
            VStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundStyle(.gray)
                    .padding()
                Text("Failed to load chirps")
                    .font(.title)
                    .bold()
                Text("Please check your internet connection")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }

    }
}
