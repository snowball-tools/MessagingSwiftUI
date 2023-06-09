//
//  MessageModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/11/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct MessageModel: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var content: String
    var username: String
    var timestamp: Timestamp
    var conversationId: String
    var photoURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case username = "userId"
        case timestamp
        case conversationId
        case photoURL
    }
}
