//
//  ExpenseData.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/23.
//

import Foundation

struct ExpenseData: Codable {
    var account_date: Date // Date 타입으로 변경
    var spend_bill: Int
    var spend_category: String // 여전히 String 타입으로 유지
    var spend_content: String
    var spend_overConsume: Bool
    var spend_open: Bool
}

