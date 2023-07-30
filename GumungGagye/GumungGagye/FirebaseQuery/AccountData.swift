////
////  AccountData.swift
////  GumungGagye
////
////  Created by 정도현 on 2023/07/19.
////
//
//import Foundation
//import Firebase
//
//// MARK: Account Data
//struct AccountData {
//    var account_id: String = ""
//    var account_date: Date = Date()
//    var account_type: Int = 0
//    var detail_id: String = ""
//    var spend_data: SpendData?
//    var income_data: IncomeData? 
//    var user_id: String = "" 
//
//    init?(data: [String: Any]) {
//        guard let accountId = data["account_id"] as? String,
//              let accountDateTimestamp = data["account_date"] as? Timestamp,
//              let accountType = data["account_type"] as? Int,
//              let detailId = data["detail_id"] as? String else {
//            return nil
//        }
//
//        self.account_id = accountId
//        self.account_date = accountDateTimestamp.dateValue()
//        self.account_type = accountType
//        self.detail_id = detailId
//
//        if accountType == 0,
//           let spendDataDict = data["spend_data"] as? [String: Any],
//           let spendData = SpendData(data: spendDataDict) {
//            self.spend_data = spendData
//        }
//
//        if accountType == 1,
//           let incomeDataDict = data["income_data"] as? [String: Any],
//           let incomeData = IncomeData(data: incomeDataDict) {
//            self.income_data = incomeData
//        }
//        
//        self.user_id = data["user_id"] as? String ?? ""
//    }
//}
