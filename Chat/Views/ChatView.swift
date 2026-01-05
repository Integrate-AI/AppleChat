//
//  ChatView.swift
//  Chat
//
//  Created by Eric English on 11/24/25.
//
import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var input = ""
    @FocusState private var focused: Bool

    @State private var isUserNearBottom = true

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                                .animation(.easeOut(duration: 0.2), value: viewModel.messages.count)
                        }

                        if viewModel.isTyping {
                            IncomingBubbleContainer {
                                TypingBubblePulse()
                            }
                            .id("typingIndicator")
                            .transition(.opacity)
                        }
                    }
                    .padding(.vertical, 10)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: ScrollOffsetKey.self,
                                            value: geo.frame(in: .global).minY)
                        }
                    )
                }

                // MARK: - Detect if user is near bottom
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    // If scroll offset is near 0 → user is at the bottom
                    isUserNearBottom = offset > -40
                }

                // MARK: - Scroll when new messages appear
                .onReceive(viewModel.$messages) { messages in
                    guard let last = messages.last else { return }

                    // Only autoscroll if the user is already near bottom
                    if isUserNearBottom {
                        DispatchQueue.main.async {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }

                // MARK: - Scroll when typing indicator appears
                // Scroll when keyboard opens
                    .onChange(of: focused) { _, isFocused in
                        if isFocused {
                            scrollToBottom(proxy)
                        }
                    } 
                .onChange(of: viewModel.isTyping) { _, typing in
                    guard typing else { return }
                    

                    if isUserNearBottom {
                        DispatchQueue.main.async {
                            proxy.scrollTo("typingIndicator", anchor: .bottom)
                        }
                    }
                }
            }

            // MARK: - Input Bar
            inputBar
        }
        .background(Color(.systemBackground))
        .onTapGesture { focused = false }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                focused = true
            }
        }
    }

    func scrollToBottom(_ proxy: ScrollViewProxy) {
          guard let last = viewModel.messages.last else { return }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
              proxy.scrollTo(last.id, anchor: .bottom)
          }
      }
    // MARK: - Input Bar
    private var inputBar: some View {
        HStack(spacing: 10) {

            Button {
                viewModel.clearChat()
            } label: {
                Image(systemName: "trash.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white, .gray.opacity(0.8))
            }

            TextField("Ask me anything...", text: $input, axis: .vertical)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .lineLimit(1...5)        // prevents it from blowing up
                .focused($focused)

            Button {
                let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }

                viewModel.sendMessage(trimmed)
                input = ""
                focused = false
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(.white, input.isEmpty ? .gray : .blue)
            }
            .disabled(input.isEmpty)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .padding(.top, 8)
        //.background(.ultraThinMaterial)
    }
}


// MARK: - Scroll Offset Helper
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
