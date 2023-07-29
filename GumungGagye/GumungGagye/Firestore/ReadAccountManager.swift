//
//  ReadAccountManager.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/28.
//

import Foundation
import Firebase

struct SpendData {
    var spend_bill: Int = 0
    var spend_category: Int = 0
    var spend_content: String = ""
    var spend_id: String = ""
    var spend_open: Bool = false
    var spend_overConsume: Bool = false
    
    init?(data: [String: Any]) {
        guard let spendBill = data["spend_bill"] as? Int,
              let spendCategory = data["spend_category"] as? Int,
              let spendContent = data["spend_content"] as? String,
              let spendId = data["spend_id"] as? String,
              let spendOpen = data["spend_open"] as? Bool,
              let spendOverConsume = data["spend_overConsume"] as? Bool else {
            return nil
        }

        self.spend_bill = spendBill
        self.spend_category = spendCategory
        self.spend_content = spendContent
        self.spend_id = spendId
        self.spend_open = spendOpen
        self.spend_overConsume = spendOverConsume
    }
}

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

struct AccountData {
    var account_id: String = ""
    var account_date: Date = Date()
    var account_type: Int = 0
    var detail_id: String = ""
    var spend_data: SpendData? = nil
    var income_data: IncomeData? = nil

    init?(data: [String: Any]) {
        guard let accountId = data["account_id"] as? String,
              let accountDateTimestamp = data["account_date"] as? Timestamp,
              let accountType = data["account_type"] as? Int,
              let detailId = data["detail_id"] as? String else {
            return nil
        }

        self.account_id = accountId
        self.account_date = accountDateTimestamp.dateValue()
        self.account_type = accountType
        self.detail_id = detailId

        if accountType == 0,
           let spendDataDict = data["spend_data"] as? [String: Any],
           let spendData = SpendData(data: spendDataDict) {
            self.spend_data = spendData
        }

        if accountType == 1,
           let incomeDataDict = data["income_data"] as? [String: Any],
           let incomeData = IncomeData(data: incomeDataDict) {
            self.income_data = incomeData
        }
    }
}


class ReadAccountManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()

    func fetchAccountData(completion: @escaping ([AccountData]?, Error?) -> Void) {
        db.collection("account")
            .order(by: "account_date", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }

                var accountDataList: [AccountData] = []
                for document in querySnapshot?.documents ?? [] {
                    if let accountDataDict = document.data() as? [String: Any],
                       let accountData = AccountData(data: accountDataDict) {
                        accountDataList.append(accountData)
                    }
                }

                completion(accountDataList, nil)
            }
    }
}



