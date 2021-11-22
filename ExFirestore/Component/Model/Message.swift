//
//  Message.swift
//  ExFirestore
//
//  Created by 김종권 on 2021/11/20.
//

import UIKit

struct Message: Codable {
    let id: String
    let content: String
    let sentDate: Date
    
    init(id: String, content: String) {
        self.id = id
        self.content = content
        self.sentDate = Date()
    }
    
    // MARK: - Date 형을 firestore에 입력하면 Unix Time Stamp형으로 변환하는 작업
    
    private enum CodingKeys: String, CodingKey {
        case id
        case content
        case sentDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        content = try values.decode(String.self, forKey: .content)
        
        let dataDouble = try values.decode(Double.self, forKey: .sentDate)
        sentDate = Date(timeIntervalSince1970: dataDouble)
    }
}

extension Message: Comparable {
    // 같은값이 있는지 비교할때 사용
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

    // sort 함수에서 사용
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
