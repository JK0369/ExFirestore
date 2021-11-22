//
//  MyFirestore.swift
//  ExFirestore
//
//  Created by 김종권 on 2021/11/20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class MyFirestore {
    
    private var documentListener: ListenerRegistration?
    
    func save(_ message: Message, completion: ((Error?) -> Void)? = nil) {
        let collectionPath = "channels/\(message.id)/thread"
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        guard let dictionary = message.asDictionary else {
            print("decode error")
            return
        }
        collectionListener.addDocument(data: dictionary) { error in
            completion?(error)
        }
    }

    func subscribe(id: String, completion: @escaping (Result<[Message], FirestoreError>) -> Void) {
        let collectionPath = "channels/\(id)/thread"
        removeListener()
        let collectionListener = Firestore.firestore().collection(collectionPath)
        
        documentListener = collectionListener
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    completion(.failure(FirestoreError.firestoreError(error)))
                    return
                }
                
                var messages = [Message]()
                snapshot.documentChanges.forEach { change in
                    switch change.type {
                    case .added, .modified:
                        do {
                            if let message = try change.document.data(as: Message.self) {
                                messages.append(message)
                            }
                        } catch {
                            completion(.failure(.decodedError(error)))
                        }
                    default: break
                    }
                }
                completion(.success(messages))
            }
    }
    
    func removeListener() {
        documentListener?.remove()
    }
}
