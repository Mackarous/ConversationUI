import SwiftUI

public struct MessageBubble: View {
    let message: Message
    
    public init(message: Message) {
        self.message = message
    }
    
    public var body: some View {
        HStack {
            if message.direction == .outgoing {
                Spacer(minLength: .messageInsetPadding)
            }
            Group {
                switch message.kind {
                case let .text(text):
                    Text(text)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(foregroundStyle)
                        .padding(.vertical, .messageVerticalPadding)
                        .padding(.horizontal)
                        .background(backgroundStyle, in: .rect(cornerRadius: .cornerRadius, style: .continuous))
                        .contentShape(.contextMenuPreview, .rect(cornerRadius: .cornerRadius, style: .continuous))
                        .contextMenu {
                            copyButton { UIPasteboard.general.string = text }
                        }
                case let .image(image):
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadius: .cornerRadius, style: .continuous))
                        .contentShape(.contextMenuPreview, .rect(cornerRadius: .cornerRadius, style: .continuous))
                        .contextMenu {
                            copyButton { UIPasteboard.general.image = image }
                            Button {
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            } label: {
                                Label("Save", systemImage: "square.and.arrow.down")
                            }
                        }
                }
            }
            .padding(.trailing, message.direction == .incoming ? .messageInsetPadding : 0)
        }
    }
    
    private func copyButton(copy: @escaping () -> Void) -> some View {
        Button(action: copy) {
            Label("Copy", systemImage: "doc.on.doc")
        }
    }
    
    private var foregroundStyle: AnyShapeStyle {
        switch message.direction {
        case .incoming:
            return AnyShapeStyle(.background)
        case .outgoing:
            return AnyShapeStyle(.white)
        }
    }
    
    private var backgroundStyle: AnyShapeStyle {
        switch message.direction {
        case .incoming:
            return AnyShapeStyle(.primary)
        case .outgoing:
            return AnyShapeStyle(.tint)
        }
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 20
    static let messageInsetPadding: CGFloat = 60
    static let messageVerticalPadding: CGFloat = 9
}

#Preview {
    ScrollView {
        VStack(alignment: .leading) {
            MessageBubble(message: Message(direction: .outgoing, kind: .text("Image of a dog")))
            MessageBubble(message: Message(direction: .incoming, kind: .text("What kind of dog?")))
            MessageBubble(message: Message(direction: .outgoing, kind: .text("A dalmation")))
            MessageBubble(message: Message(direction: .incoming, kind: .image(UIImage(resource: .kitten))))
            MessageBubble(message: Message(direction: .outgoing, kind: .text("This is a super long message to see how this will work with padding on the left and right sides, as well as multi-line text")))
            MessageBubble(message: Message(direction: .incoming, kind: .text("This is a super long message to see how this will work with padding on the left and right sides, as well as multi-line text")))
        }
        .padding()
    }
}
