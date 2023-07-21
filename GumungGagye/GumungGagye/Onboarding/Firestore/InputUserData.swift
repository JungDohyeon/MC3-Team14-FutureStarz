//
//  UserData.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/19.
//

import Foundation

final class InputUserData: ObservableObject {
    static let shared = InputUserData()

    var user_id: String?
    var email: String?
    var nickname: String?
    var group_id: String?
    var goal: Int?
    var bankcardpay: Int?
    var bankcardpay_index: Int?
    var profile_image: String?

    private init() { }
}
