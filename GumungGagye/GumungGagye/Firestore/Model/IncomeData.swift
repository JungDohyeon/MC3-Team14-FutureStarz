//
//  IncomeData.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/29.
//

import Foundation

struct IncomeData {
    var income_bill: Int = 0
    var income_category: Int = 0
    var income_content: String = ""
    var income_id: String = ""

    init?(data: [String: Any]) {
        guard let incomeBill = data["income_bill"] as? Int,
              let incomeCategory = data["income_category"] as? Int,
              let incomeContent = data["income_content"] as? String,
              let incomeId = data["income_id"] as? String else {
            return nil
        }

        self.income_bill = incomeBill
        self.income_category = incomeCategory
        self.income_content = incomeContent
        self.income_id = incomeId
    }
}
