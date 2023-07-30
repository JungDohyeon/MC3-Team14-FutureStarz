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
    
    // ================================ CREATE ================================
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
    
    // add Account
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
                self.checkAndAddSpendToPost(spendData, documentID)
            }
        }
    }
    
    // Add post
    func checkAndAddSpendToPost(_ spendData: InputSpendData, _ accountDocumentID: String) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
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
                let postDoc = snapshot!.documents.first!
                let postID = postDoc.documentID
                let postUserID = postDoc["post_userID"] as? String ?? "" // Extract the post_userID from the existing post
                
                if postUserID != userID {
                    // 유저 아이디가 다르다면 새로 생성
                    let documentRef = db.collection("post").document()
                    let newPostID = documentRef.documentID
                    
                    documentRef.setData([
                        "post_id": newPostID,
                        "post_date": dateString,
                        "post_userID": userID,
                        "account_array": [accountDocumentID]
                    ]) { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                        } else {
                            print("New POST data added with ID: \(newPostID)")
                        }
                    }
                } else {
                    // Otherwise, update the existing post's account_array
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
                self.checkAndAddIncomeToPost(incomeData, documentID)
            }
        }
    }
    
    func checkAndAddIncomeToPost(_ incomeData: InputIncomeData, _ accountDocumentID: String) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // 해당 날짜에 해당하는 POST가 있는지 확인
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: incomeData.account_date)
        
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
                let postDoc = snapshot!.documents.first!
                let postID = postDoc.documentID
                let postUserID = postDoc["post_userID"] as? String ?? "" // Extract the post_userID from the existing post
                
                if postUserID != userID {
                    // 유저 아이디가 다르다면 새로 생성
                    let documentRef = db.collection("post").document()
                    let newPostID = documentRef.documentID
                    
                    documentRef.setData([
                        "post_id": newPostID,
                        "post_date": dateString,
                        "post_userID": userID,
                        "account_array": [accountDocumentID]
                    ]) { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                        } else {
                            print("New POST data added with ID: \(newPostID)")
                        }
                    }
                } else {
                    // Otherwise, update the existing post's account_array
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
    }
    
    
    // ================================ READ ================================
   
    // fetchPost
    func fetchPostData(userID userId: String, date: String) async throws -> [String] {
        let firestore = Firestore.firestore()
        let postsCollection = firestore.collection("post")
        
        // 해당 날짜 범위 내에서 userId와 date가 일치하는 post 문서를 쿼리합니다.
        let query = postsCollection.whereField("post_userID", isEqualTo: userId)
                                   .whereField("post_date", isEqualTo: date)
        
        do {
            let snapshot = try await query.getDocuments()
            
            var accountArray: [String] = []
            for document in snapshot.documents {
                if let accountArrayData = document.data()["account_array"] as? [String] {
                    accountArray.append(contentsOf: accountArrayData)
                }
            }
            
            // snapshotListener를 추가하여 해당 쿼리 결과에 변경 사항을 실시간으로 감지합니다.
            let listener = query.addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // 쿼리 결과를 업데이트합니다.
                var updatedAccountArray: [String] = []
                for document in snapshot.documents {
                    if let accountArrayData = document.data()["account_array"] as? [String] {
                        updatedAccountArray.append(contentsOf: accountArrayData)
                    }
                }
                
                // 변경된 데이터를 업데이트합니다.
                accountArray = updatedAccountArray
                print("Data updated with snapshotListener")
            }
            
            // 필요한 경우 Listener를 사용하여 나중에 Listener를 해제할 수 있습니다.
            // 예를 들면 뷰가 사라지거나, 더 이상 데이터 감지가 필요하지 않을 때 Listener를 해제합니다.
            // listener.remove()
            
            return accountArray
        } catch {
            throw error
        }
    }



    
    // Fetch Account
    func fetchAccountData(forAccountID accountID: String, completion: @escaping ((ReadSpendData?, ReadIncomeData?)) -> Void) -> ListenerRegistration? {
        let firestore = Firestore.firestore()
        let accountRef = firestore.collection("account").document(accountID)
        
        return accountRef.addSnapshotListener { (documentSnapshot, error) in
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

    
    // Fetch Spend Data
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
    
    // Fetch Income Data
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


