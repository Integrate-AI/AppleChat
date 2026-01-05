//
//  TypingBubble.swift
//  Chat
//
//  Created by Eric English on 11/24/25.
//


struct TypingBubble: View {
    @State private var dotCount = 1

    var body: some View {
        HStack {
            Text(String(repeating: ".", count: dotCount))
                .font(.body.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemGray3))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: 200, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4).repeatForever()) {
                Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                    dotCount = (dotCount % 3) + 1
                }
            }
        }
    }
}