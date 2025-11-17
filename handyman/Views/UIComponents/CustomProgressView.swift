import SwiftUI

public struct CustomProgressView: View {
    public let size: CGFloat

    public init(size: CGFloat = 120) {
        self.size = size
    }

    public var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .frame(width: size, height: size)
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
    }
}
