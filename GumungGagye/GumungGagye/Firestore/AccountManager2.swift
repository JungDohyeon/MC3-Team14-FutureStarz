//
//  AccountManager.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

struct InputSpendData {
    var account_type: Int = 0
    var account_date: Date = Date()
    var spend_bill: Int = 0
    var spend_category: Int = 0
    var spend_content: String = ""
    var spend_open: Bool = false
    var spend_overConsume: Bool = false
}

struct InputIncomeData {
    var account_type: Int = 1
    var account_date: Date = Date()
    var income_bill: Int = 0
    var income_category: Int = 0
    var income_content: String = ""
}



final class AccountManager2: ObservableObject{
    
//    var account_type: Int = 0
//    var spend_bill = 123340
//    var spend_category = 2
//    var spend_content = "리나 점심"
//    var spend_open = true
//    var spend_overConsume = true
//    var income_bill = 62100000
//    var income_category = 2
//    var income_content = "리나 용돈"
//
    let db = Firestore.firestore()
    static let shared = AccountManager2()
    private init() { }
    
    
    func createNewSpendAccount(inputSpendData: InputSpendData) async throws {
        var accountData: [String: Any] = [
            "account_date": inputSpendData.account_date,
//            "user_id": Auth.auth().currentUser?.uid ?? "",
            "account_type": inputSpendData.account_type,
        ]

        if let users = Auth.auth().currentUser?.uid {
            var user_ref = db.collection("users").document(users)
            accountData["user_id"] = user_ref
        }

        var  spendData: [String: Any] = [
            "spend_bill": inputSpendData.spend_bill,
            "spend_category": inputSpendData.spend_category,
            "spend_content": inputSpendData.spend_content,
            "spend_open": inputSpendData.spend_open,
            "spend_overConsume": inputSpendData.spend_overConsume,
        ]

        var account_document_ref = try await db.collection("account").addDocument(data: accountData)

        try await db.collection("account").document(account_document_ref.documentID).updateData(["account_id": account_document_ref.documentID])

        var account_detail_document_ref = try await db.collection("spend").addDocument(data: spendData)

        try await db.collection("spend").document(account_detail_document_ref.documentID).updateData(["spend_id": account_detail_document_ref.documentID])

        try await db.collection("account").document(account_document_ref.documentID).updateData(["detail_id": account_detail_document_ref.documentID])
    }

    func createNewIncomeAccount(inputIncomeData: InputIncomeData) async throws {
        var accountData: [String: Any] = [
            "account_data": inputIncomeData.account_date,
//            "user_id": Auth.auth().currentUser?.uid ?? "",
            "account_type": inputIncomeData.account_type,
        ]

        if let users = Auth.auth().currentUser?.uid {
            var user_ref = db.collection("users").document(users)
            accountData["user_id"] = user_ref
        }


        var incomeData: [String: Any] = [
            "income_bill": inputIncomeData.income_bill,
            "income_category": inputIncomeData.income_category,
            "income_content": inputIncomeData.income_content,
        ]

        var account_document_ref = try await db.collection("account").addDocument(data: accountData)

        try await db.collection("account").document(account_document_ref.documentID).updateData(["account_id": account_document_ref.documentID])

        var account_detail_document_ref = try await db.collection("income").addDocument(data: incomeData)

        try await db.collection("income").document(account_detail_document_ref.documentID).updateData(["income_id": account_detail_document_ref.documentID])

        try await db.collection("account").document(account_document_ref.documentID).updateData(["detail_id": account_detail_document_ref.documentID])

    }
    
    
  
    

}


