struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    var isUser: Bool
}