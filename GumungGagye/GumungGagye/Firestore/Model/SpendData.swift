////
////  SpendData.swift
////  GumungGagye
////
////  Created by Lee Juwon on 2023/07/29.
////
//
//import Foundation
//
//struct SpendData {
//    var spend_bill: Int = 0
//    var spend_category: Int = 0
//    var spend_content: String = ""
//    var spend_id: String = ""
//    var spend_open: Bool = false
//    var spend_overConsume: Bool = false
//    
//    init?(data: [String: Any]) {
//        guard let spendBill = data["spend_bill"] as? Int,
//              let spendCategory = data["spend_category"] as? Int,
//              let spendContent = data["spend_content"] as? String,
//              let spendId = data["spend_id"] as? String,
//              let spendOpen = data["spend_open"] as? Bool,
//              let spendOverConsume = data["spend_overConsume"] as? Bool else {
//            return nil
//        }
//
//        self.spend_bill = spendBill
//        self.spend_category = spendCategory
//        self.spend_content = spendContent
//        self.spend_id = spendId
//        self.spend_open = spendOpen
//        self.spend_overConsume = spendOverConsume
//    }
//    
//    func asDictionary() -> [String: Any] {
//        return [
//            "spend_bill": self.spend_bill,
//            "spend_category": self.spend_category,
//            "spend_content": self.spend_content,
//            "spend_id": self.spend_id,
//            "spend_open": self.spend_open,
//            "spend_overConsume": self.spend_overConsume
//        ]
//    }
//}
//
