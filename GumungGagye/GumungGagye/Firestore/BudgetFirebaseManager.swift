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

struct InputPost {
    var account_id: String
    var post_userID: String
}

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
    var detailId: String?
    var userId: String
}


final class BudgetFirebaseManager: ObservableObject {
    
    let db = Firestore.firestore()
    static let shared = BudgetFirebaseManager()
    private init() { }
   
    // Spend
    func saveSpendToFirebase(_ spendData: InputSpendData) {
        let db = Firestore.firestore()
        
        // Spend 데이터 Firestore에 저장
        let documentRef = db.collection("spend").document()
        let documentID = documentRef.documentID // Assign the generated spend_id to the spendData object
        
        documentRef.setData([
            "spend_id": documentID,
            "spend_bill": spendData.spend_bill,
            "spend_category": spendData.spend_category,
            "spend_content": spendData.spend_content,
            "spend_open": spendData.spend_open,
            "spend_overConsume": spendData.spend_overConsume
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Spend data added with ID: \(documentID)")
                self.addSpendToUserAccount(spendData, documentID)
            }
        }
    }


    func addSpendToUserAccount(_ spendData: InputSpendData, _ spendDocumentID: String) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // account 데이터 Firestore에 저장
        let documentRef = db.collection("account").document()
        let documentID = documentRef.documentID
        
        documentRef.setData([
            "account_id": documentID,
            "user_id": userID,
            "detail_id": spendDocumentID,
            "account_date": spendData.account_date,
            "account_type": spendData.account_type
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Account data added with ID: \(documentID)")
                self.checkAndAddSpendToPost(spendData, documentID, userID)
            }
        }
    }

    func checkAndAddSpendToPost(_ spendData: InputSpendData, _ accountDocumentID: String, _ userID: String) {
        let db = Firestore.firestore()

        // 해당 날짜에 해당하는 POST가 있는지 확인
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: spendData.account_date)

        db.collection("post").whereField("post_date", isEqualTo: dateString).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }

            // 해당 날짜에 해당하는 POST가 없을 경우 새로운 POST를 생성
            if snapshot!.isEmpty {
                let documentRef = db.collection("post").document()
                let postID = documentRef.documentID

                documentRef.setData([
                    "post_id": postID,
                    "post_date": dateString,
                    "post_userID": userID,
                    "account_array": [accountDocumentID]
                ]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("POST data added with ID: \(postID)")
                    }
                }
            } else {
                // 해당 날짜에 해당하는 POST가 이미 존재할 경우 해당 POST의 account_array에 account_id를 추가
                let postDoc = snapshot!.documents.first!
                let postID = postDoc.documentID

                db.collection("post").document(postID).updateData([
                    "account_array": FieldValue.arrayUnion([accountDocumentID])
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Spend id added to existing post for date: \(dateString)")
                    }
                }
            }
        }
    }

    

    // Income
    func saveIncomeToFirebase(_ incomeData: InputIncomeData) {
        let db = Firestore.firestore()
        
        // Spend 데이터 Firestore에 저장
        let documentRef = db.collection("income").document()
        let documentID = documentRef.documentID // Assign the generated spend_id to the spendData object
        
        documentRef.setData([
            "income_id": documentID,
            "income_category": incomeData.income_category,
            "income_content": incomeData.income_content,
            "income_bill": incomeData.income_bill
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Spend data added with ID: \(documentID)")
                self.addIncomeToUserAccount(incomeData, documentID)
            }
        }
    }


    func addIncomeToUserAccount(_ incomeData: InputIncomeData, _ incomeDocumentID: String) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // account 데이터 Firestore에 저장
        let documentRef = db.collection("account").document()
        let documentID = documentRef.documentID
        
        documentRef.setData([
            "account_id": documentID,
            "user_id": userID,
            "detail_id": incomeDocumentID,
            "account_date": incomeData.account_date,
            "account_type": incomeData.account_type
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Account data added with ID: \(documentID)")
                self.checkAndAddSpendToPost(incomeData, documentID, userID)
            }
        }
    }

    func checkAndAddSpendToPost(_ spendData: InputIncomeData, _ accountDocumentID: String, _ userID: String) {
        let db = Firestore.firestore()

        // 해당 날짜에 해당하는 POST가 있는지 확인
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: spendData.account_date)

        db.collection("post").whereField("post_date", isEqualTo: dateString).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }

            // 해당 날짜에 해당하는 POST가 없을 경우 새로운 POST를 생성
            if snapshot!.isEmpty {
                let documentRef = db.collection("post").document()
                let postID = documentRef.documentID

                documentRef.setData([
                    "post_id": postID,
                    "post_date": dateString,
                    "post_userID": userID,
                    "account_array": [accountDocumentID]
                ]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("POST data added with ID: \(postID)")
                    }
                }
            } else {
                // 해당 날짜에 해당하는 POST가 이미 존재할 경우 해당 POST의 account_array에 account_id를 추가
                let postDoc = snapshot!.documents.first!
                let postID = postDoc.documentID

                db.collection("post").document(postID).updateData([
                    "account_array": FieldValue.arrayUnion([accountDocumentID])
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Spend id added to existing post for date: \(dateString)")
                    }
                }
            }
        }
    }
    
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

