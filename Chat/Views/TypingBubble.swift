//
//  TypingBubble.swift
//  Chat
//
//  Created by Eric English on 11/24/25.
//
import SwiftUI

struct TypingBubble: View {
    @State private var dotCount = 1

    var body: some View {
        
        HStack {
            Text(String(repeating: ".", count: dotCount))
                .font(.body.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: 200, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 400_000_000)
                withAnimation(.easeInOut(duration: 0.4)) {
                    dotCount = (dotCount % 3) + 1
                }
            }
        }
    }
}

struct TypingBubblePulse: View {
    @State private var pulse = false

    var body: some View {
        Image(systemName: "ellipsis.bubble.fill")   // you can change icon here
            .font(.system(size: 16))
            .foregroundColor(.white)
            .padding(12)
            .background(Color(.systemGray3))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .scaleEffect(pulse ? 1.15 : 0.9)
            .opacity(pulse ? 1.0 : 0.6)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true)
                ) {
                    pulse.toggle()
                }
            }
    }
}
