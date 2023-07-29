//
//  AccountData.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/19.
//

import Foundation
import Firebase

// MARK: Account Data
struct AccountData: Identifiable {
    var id: String
    var account_date: Date
    var account_id: String
    var account_type: Int
    var account_userID: DocumentReference
}
