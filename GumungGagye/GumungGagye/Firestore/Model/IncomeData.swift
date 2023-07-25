//
//  IncomeData.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct IncomeData: Codable {
    var userID: DocumentReference
    var account_date: Date // Date 타입으로 변경
    var income_bill: Int
    var income_category: String // 여전히 String 타입으로 유지
    var income_content: String
}
