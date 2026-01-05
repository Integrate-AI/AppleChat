//
//  ChatMessage.swift
//  Chat
//
//  Created by Eric English on 11/24/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    var isUser: Bool
}
