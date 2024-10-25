struct list: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
        }.frame(maxWidth: .infinity).padding(10).background {
            switch colorScheme {
            case .light:
                Color.white.clipShape(RoundedRectangle(cornerRadius: 10))
            case .dark:
                Color(UIColor.secondarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 10))
            @unknown default:
                Color.white.clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}