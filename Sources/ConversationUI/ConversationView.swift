import SwiftUI

struct ConversationView: View {
    @Binding var messages: [Message]
    
    @Namespace private var animation
    @FocusState private var isFocused: Bool
    
    @State private var text = ""
    @State private var sentMessage: Message?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                            .matchedGeometryEffect(id: message.id, in: animation)
                            .id(message.id)
                            .padding(.bottom, 8)
                    }
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                textFieldContent(with: proxy)
            }
            .onChange(of: messages) { messages in
                withAnimation {
                    proxy.scrollTo(messages.last?.id)
                }
            }
        }
    }
    
    private func textFieldContent(with proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .bottom) {
            TextField("Message", text: $text, axis: .vertical)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .focused($isFocused)
                .onSubmit {
                    isFocused = true
                    submit()
                }
                .onChange(of: isFocused) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id)
                    }
                }
            Button(action: submit) {
                Image(systemName: "arrow.up.circle.fill")
                    .imageScale(.large)
            }
            .tint(.primary)
            .disabled(text.isEmpty)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .overlay(Color(.separator), in: .rect(cornerRadius: 18).stroke())
        .overlay(alignment: .leading) {
            if let sentMessage {
                MessageBubble(message: sentMessage)
                    .matchedGeometryEffect(id: sentMessage.id, in: animation)
            }
        }
        .padding()
        .background {
            Rectangle()
                .fill(.background.opacity(0.5))
                .background(.bar)
                .ignoresSafeArea()
        }
    }
    
    private func submit() {
        guard !text.isEmpty else { return }
        
        let message = Message(direction: .outgoing, kind: .text(text))
        text = ""

        sentMessage = message
        withAnimation(.smooth(duration: 0.2)) {
            sentMessage = nil
            messages.append(message)
        }
    }
}

#Preview {
    struct StatePreview: View {
        @State var messages = [Message]()
        
        var body: some View {
            NavigationStack {
                ConversationView(messages: $messages)
                    .navigationTitle("Conversation")
            }
        }
    }
    return StatePreview()
}
