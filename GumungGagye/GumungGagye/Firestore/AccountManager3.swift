//
//  AccountManager3.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/30.
//
//
//  AccountManager3.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/30.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

struct ReadSpendData {
    var id: String
    var bill: Int
    var category: Int
    var content: String
    var open: Bool
    var overConsume: Bool
}

struct ReadIncomeData {
    var id: String
    var bill: Int
    var category: Int
    var content: String
}

struct ReadAccountData {
    var id: String
    var accountDate: Timestamp
    var accountType: Int
    var detailId: String? // Make detailId optional
    var userId: String
}

final class AccountManager3 {
    let db = Firestore.firestore()
    static let shared = AccountManager3()
    private init() { }
    
    
    func fetchAccountData(forAccountID accountID: String, completion: @escaping ((ReadSpendData?, ReadIncomeData?)) -> Void) {
        db.collection("account").document(accountID)
            .getDocument { (documentSnapshot, error) in
                guard let documentData = documentSnapshot?.data() else {
                    completion((nil, nil))
                    return
                }
                
                let accountData = ReadAccountData(
                    id: documentSnapshot!.documentID,
                    accountDate: documentData["account_date"] as? Timestamp ?? Timestamp(),
                    accountType: documentData["account_type"] as? Int ?? 0,
                    detailId: documentData["detail_id"] as? String,
                    userId: documentData["user_id"] as? String ?? ""
                )
                
                if let detailID = accountData.detailId {
                    // income
                    if accountData.accountType == 1 {
                        self.fetchIncomeData(forDetailID: detailID) { incomeData in
                            completion((nil, incomeData))
                        }
                    }
                    // spend
                    else {
                        self.fetchSpendData(forDetailID: detailID) { spendData in
                            completion((spendData, nil))
                        }
                    }
                } else {
                    completion((nil, nil))
                }
            }
    }
    
    private func fetchSpendData(forDetailID detailID: String, completion: @escaping (ReadSpendData?) -> Void) {
        db.collection("spend").whereField("spend_id", isEqualTo: detailID).limit(to: 1)
            .getDocuments { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents, let data = documents.first?.data() else {
                    completion(nil)
                    return
                }
                
                let spendData = ReadSpendData(
                    id: documents.first!.documentID,
                    bill: data["spend_bill"] as? Int ?? 0,
                    category: data["spend_category"] as? Int ?? 0,
                    content: data["spend_content"] as? String ?? "",
                    open: data["spend_open"] as? Bool ?? false,
                    overConsume: data["spend_overConsume"] as? Bool ?? false
                )
                
                completion(spendData)
            }
    }
    
    private func fetchIncomeData(forDetailID detailID: String, completion: @escaping (ReadIncomeData?) -> Void) {
        db.collection("income").whereField("income_id", isEqualTo: detailID).limit(to: 1)
            .getDocuments { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents, let data = documents.first?.data() else {
                    completion(nil)
                    return
                }
                
                let incomeData = ReadIncomeData(
                    id: documents.first!.documentID,
                    bill: data["income_bill"] as? Int ?? 0,
                    category: data["income_category"] as? Int ?? 0,
                    content: data["income_content"] as? String ?? ""
                )
                completion(incomeData)
            }
    }
}
