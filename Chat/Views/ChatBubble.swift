//
//  ChatBubble.swift
//  Chat
//
//  Created by Eric English on 11/24/25.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }

            Text(message.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(message.isUser ? Color.blue : Color(.secondarySystemBackground))
                .foregroundColor(message.isUser ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(
                    maxWidth: UIScreen.main.bounds.width * 0.75,
                    alignment: message.isUser ? .trailing : .leading
                )

            if !message.isUser { Spacer(minLength: 40) }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}

struct IncomingBubbleContainer<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        HStack {
            content()
            Spacer(minLength: 40)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}

