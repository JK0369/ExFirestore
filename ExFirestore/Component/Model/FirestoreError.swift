//
//  FirestoreError.swift
//  ExFirestore
//
//  Created by 김종권 on 2021/11/20.
//

import Foundation

enum FirestoreError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}
