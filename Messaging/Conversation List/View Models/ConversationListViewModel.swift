//
//  ConversationListViewModel.swift
//  Messaging
//
//  Created by Vivian Phung on 4/17/23.
//

import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ConversationListViewModel: ObservableObject {
    @Published var conversations = [ConversationModel]()
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    @Published var showNewConversationView: Bool = false
    @Published var showConversationView: Bool = false
    @Published var showProfileView: Bool = false

    @Published var showConversationId: String?

    func fetchConversations(username: String) {
        listener = db.collection("conversations")
            .whereField("participants", arrayContains: username)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching conversations: \(error)")
                } else {
                    self.conversations = querySnapshot?.documents.compactMap { document -> ConversationModel? in
                        do {
                            return try document.data(as: ConversationModel.self)
                        } catch {
                            print("Error decoding conversation: \(error)")
                            return nil
                        }
                    } ?? []
                }
            }
    }

    func startConversation(with frenUserId: String, and currentUsername: String) {
        let convo = conversations.filter { convo in
            convo.participants.contains { username in
                username == frenUserId
            }
        }.first

        if let frenConvo = convo {
            self.showConversationId = frenConvo.id
            self.showConversationView = true
        } else {
            createNewConversation(with: frenUserId, and: currentUsername)
        }
    }

    func createNewConversation(with frenUserId: String, and currentUsername: String) {
        let newConversation = ConversationModel(participants: [currentUsername, frenUserId], name: frenUserId, lastMessage: "")
        do {
            let newConvoDocReference = try db.collection("conversations")
                .addDocument(from: newConversation)
            newConvoDocReference.getDocument(as: ConversationModel.self) { result in
                switch result {
                case .success(let success):
                    self.showConversationId = success.id
                    self.showConversationView = true
                case .failure(let failure):
                    print("error failed to create new conversation: \(failure.localizedDescription)")
                }
            }
        } catch {
            print("error starting new conversation: \(error.localizedDescription)")
        }
    }

    deinit {
        listener?.remove()
    }
}
