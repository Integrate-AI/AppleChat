//
//  ChatViewModel.swift
//  Chat
//
//  Created by Eric English on 11/24/25.
//


import SwiftUI
import Combine
import FoundationModels 

@available(iOS 26.0, *)
@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isTyping = false
    private let session = LanguageModelSession()

    func sendMessage(_ text: String) {
        messages.append(ChatMessage(text: text, isUser: true))
        Task {
            await generateResponse(for: text)
        }
    }
    
    func clearChat() {
        messages.removeAll()
        isTyping = false
    } 

    private func insertAssistantPlaceholder() {
        messages.append(ChatMessage(text: "", isUser: false))
    }

    private func updateAssistantMessage(_ text: String) {
        if let last = messages.last, !last.isUser {
            messages[messages.count - 1].text = text
        }
    }

    private func generateResponse(for prompt: String) async {
        isTyping = true

        do {
            let stream = session.streamResponse(to: prompt)
            var hasInsertedMessage = false

            for try await chunk in stream {
                let content = chunk.content

                if !hasInsertedMessage {
                    // First chunk = replace typing bubble with real message
                    hasInsertedMessage = true
                    isTyping = false
                    messages.append(ChatMessage(text: content, isUser: false))
                } else {
                    // Update the last assistant message
                    messages[messages.count - 1].text = content
                }
            }
        } catch {
            isTyping = false
            messages.append(ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false))
        }
    }
}


