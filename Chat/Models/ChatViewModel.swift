//
//  ChatViewModel.swift
//  Chat
//
//  Created by Eric English on 11/24/25.
//


import Foundation
import AI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []

    private var chat: AIChat?

    init() {
        let config = AIModelConfiguration(
            usage: .onDevice,                // Force on-device Foundation models
            model: .foundationSmall          // Use Foundation-Small or change to .foundationMedium
        )

        chat = AIChat(configuration: config)
    }

    func sendMessage(_ text: String) {
        guard let chat = chat else { return }

        let userMessage = ChatMessage(text: text, isUser: true)
        messages.append(userMessage)

        Task {
            do {
                let stream = try await chat.stream(text)
                
                var responseText = ""
                for try await chunk in stream {
                    responseText += chunk
                    updateAssistantMessage(responseText)
                }
            } catch {
                messages.append(ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false))
            }
        }
    }

    private func updateAssistantMessage(_ text: String) {
        if let last = messages.last, !last.isUser {
            messages[messages.count - 1].text = text
        } else {
            messages.append(ChatMessage(text: text, isUser: false))
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    var isUser: Bool
}