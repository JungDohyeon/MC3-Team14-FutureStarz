////
////  UserData.swift
////  GumungGagye
////
////  Created by 정도현 on 2023/07/19.
////
//
//import Foundation
//
//// MARK: User Data
//class UserData: Identifiable {
//    var id: String
//    var email: String
//    var nickname: String
//    var group_id: String?
//    var goal: Int?
//    var bankCardpay: Int?
//    var bankCardpay_index: Int?
//
//    init(data: [String: Any]) {
//        self.id = data["user_id"] as? String ?? ""
//        self.nickname = data["nickname"] as? String ?? ""
//        self.email = data["email"] as? String ?? ""
//        self.goal = data["goal"] as? Int ?? nil
//        self.group_id = data["group_id"] as? String ?? nil
//        self.bankCardpay = data["bankcardpay"] as? Int ?? nil
//        self.bankCardpay_index = data["bankcardpay_index"] as? Int ?? nil
//    }
//}
