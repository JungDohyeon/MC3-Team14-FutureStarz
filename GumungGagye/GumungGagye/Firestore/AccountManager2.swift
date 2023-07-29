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

//struct SpendData {
//    var spend_id: String = ""
//    var account_type: Int = 0
//    var account_date: Date = Date()
//    var spend_bill: Int = 0
//    var spend_category: Int = 0
//    var spend_content: String = ""
//    var spend_open: Bool = false
//    var spend_overConsume: Bool = false
//}
//
//struct IncomeData {
//    var income_id: String = ""
//    var account_type: Int = 1
//    var account_date: Date = Date()
//    var income_bill: Int = 0
//    var income_category: Int = 0
//    var income_content: String = ""
//}



struct SpendData {
    var account_type: Int = 0
    var account_date: Date = Date()
    var spend_bill: Int = 0
    var spend_category: Int = 0
    var spend_content: String = ""
    var spend_open: Bool = false
    var spend_overConsume: Bool = false
}

struct IncomeData {
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
    
    let db = Firestore.firestore()
    static let shared = AccountManager2()
    private init() { }
    
    
    func createNewSpendAccount(spendData: SpendData) async throws {
        var accountData: [String: Any] = [
            "account_date": spendData.account_date,
//            "user_id": Auth.auth().currentUser?.uid ?? "",
            "account_type": spendData.account_type,
        ]
        
        if let users = Auth.auth().currentUser?.uid {
            var user_ref = db.collection("users").document(users)
            accountData["user_id"] = user_ref
        }
        
        var  spendData: [String: Any] = [
            "spend_bill": spendData.spend_bill,
            "spend_category": spendData.spend_category,
            "spend_content": spendData.spend_content,
            "spend_open": spendData.spend_open,
            "spend_overConsume": spendData.spend_overConsume,
        ]
        
        var account_document_ref = try await db.collection("account").addDocument(data: accountData)
        
        try await db.collection("account").document(account_document_ref.documentID).updateData(["account_id": account_document_ref.documentID])
        
        var account_detail_document_ref = try await db.collection("spend").addDocument(data: spendData)
        
        try await db.collection("spend").document(account_detail_document_ref.documentID).updateData(["spend_id": account_detail_document_ref.documentID])
        
        try await db.collection("account").document(account_document_ref.documentID).updateData(["detail_id": account_detail_document_ref.documentID])
    }
    
    func createNewIncomeAccount(incomeData: IncomeData) async throws {
        var accountData: [String: Any] = [
            "account_data": incomeData.account_date,
//            "user_id": Auth.auth().currentUser?.uid ?? "",
            "account_type": incomeData.account_type,
        ]

        if let users = Auth.auth().currentUser?.uid {
            var user_ref = db.collection("users").document(users)
            accountData["user_id"] = user_ref
        }


        var incomeData: [String: Any] = [
            "income_bill": incomeData.income_bill,
            "income_category": incomeData.income_category,
            "income_content": incomeData.income_content,
        ]

        var account_document_ref = try await db.collection("account").addDocument(data: accountData)

        try await db.collection("account").document(account_document_ref.documentID).updateData(["account_id": account_document_ref.documentID])

        var account_detail_document_ref = try await db.collection("income").addDocument(data: incomeData)

        try await db.collection("income").document(account_detail_document_ref.documentID).updateData(["income_id": account_detail_document_ref.documentID])

        try await db.collection("account").document(account_document_ref.documentID).updateData(["detail_id": account_detail_document_ref.documentID])

    }
    
    
//    // 지출 내역 정보 가져오기
//        func fetchSpendData(spend_id: String) async throws -> SpendData? {
//            let db = Firestore.firestore()
//            let spendDataCollection = db.collection("spend")
//
//            let documentReference = spendDataCollection.document(spend_id)
//
//            do {
//                let document = try await documentReference.getDocument()
//                if document.exists, let data = document.data() {
//                    let spend_id = document.documentID
//                    let account_type = data["account_type"] as? Int ?? 0
//                    let account_date = data["account_date"] as? Timestamp ?? Timestamp()
//                    let spend_bill = data["spend_bill"] as? Int ?? 0
//                    let spend_category = data["spend_category"] as? Int ?? 0
//                    let spend_content = data["spend_content"] as? String ?? ""
//                    let spend_open = data["spend_open"] as? Bool ?? false
//                    let spend_overConsume = data["spend_overConsume"] as? Bool ?? false
//
//                    return SpendData(spend_id: spend_id, account_type: account_type, account_date: account_date.dateValue(), spend_bill: spend_bill, spend_category: spend_category, spend_content: spend_content, spend_open: spend_open, spend_overConsume: spend_overConsume)
//                } else {
//                    return nil
//                }
//            } catch {
//                throw error
//            }
//        }
//
//        // 수입 내용 정보 가져오기
//        func fetchIncomeData(income_id: String) async throws -> IncomeData? {
//            let db = Firestore.firestore()
//            let incomeDataCollection = db.collection("income")
//
//            let documentReference = incomeDataCollection.document(income_id)
//
//            do {
//                let document = try await documentReference.getDocument()
//                if document.exists, let data = document.data() {
//                    let income_id = document.documentID
//                    let account_type = data["account_type"] as? Int ?? 0
//                    let account_date = data["account_date"] as? Timestamp ?? Timestamp()
//                    let income_bill = data["income_bill"] as? Int ?? 0
//                    let income_category = data["income_category"] as? Int ?? 0
//                    let income_content = data["income_content"] as? String ?? ""
//
//                    return IncomeData(income_id: income_id, account_type: account_type, account_date: account_date.dateValue(), income_bill: income_bill, income_category: income_category, income_content: income_content)
//                } else {
//                    return nil
//                }
//            } catch {
//                throw error
//            }
//        }
//
  
    
    

}


