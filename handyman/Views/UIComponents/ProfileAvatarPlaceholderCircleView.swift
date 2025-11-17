import SwiftUI

public struct ProfileAvatarPlaceholderCircleView: View {
    public let size: CGFloat
    public let title: String
    public let onTap: () -> Void

    public init(size: CGFloat = 120, title: String = "Tap to Add", onTap: @escaping () -> Void) {
        self.size = size
        self.title = title
        self.onTap = onTap
    }

    public var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: size, height: size)
            .overlay(
                Text(title)
                    .foregroundColor(.gray)
                    .font(.caption)
            )
            .contentShape(Circle())
            .onTapGesture { onTap() }
    }
}
