import SwiftUI

public struct ProfileAvatarImageView: View {
    public let image: UIImage
    public let size: CGFloat
    public let showsEditBadge: Bool
    public let onTap: (() -> Void)?

    public init(image: UIImage, size: CGFloat = 120, showsEditBadge: Bool = true, onTap: (() -> Void)? = nil) {
        self.image = image
        self.size = size
        self.showsEditBadge = showsEditBadge
        self.onTap = onTap
    }

    public var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture { onTap?() }
            .overlay(alignment: .bottomTrailing) {
                if showsEditBadge {
                    ZStack {
                        Circle()
                            .foregroundStyle(.gray)
                            .frame(width: 25, height: 25)
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .offset(x: -5, y: -5)
                }
            }
    }
}
