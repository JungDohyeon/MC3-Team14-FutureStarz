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
import SwiftUI

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

// N.D
struct Analysis_Post {
    let post_date: String
    let post_id: String
    let post_userID: String
    let account_array: [String]
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
    
    // MARK: - AnalysisView 2 Function
    
    
    //    func analysis2FetchAccount(userID userId: String) async throws -> [(Int, String)] {
    //
    //        //나의 달에 있는 모든 account 저장하는 배열
    //        var analysisAccountArray: [(Int, String)] = [] //해당 달의 수입 지출 Account문서 ID 받아오는 배열
    //
    //        for i in 1...31 {
    //            if i < 10 {
    //                analysisAccountArray.append((i, try await BudgetFirebaseManager.shared.fetchPostData(userID: userId, date: "2023-08-0\(i)")))
    //            } else {
    //                analysisAccountArray.append(contentsOf: try await BudgetFirebaseManager.shared.fetchPostData(userID: userId, date: "2023-08-\(i)"))
    //            }
    //        }
    //        return analysisAccountArray
    //
    //    }
    //
    
    
    func analysis2FetchAccount(userID userId: String) async throws -> [(Int, [String])] {
        
        //나의 달에 있는 모든 account 저장하는 배열
        var analysisAccountArray: [(Int, [String])] = [] //해당 달의 수입 지출 Account문서 ID 받아오는 배열
        var accountArray: [String] = []
        for i in 1...31 {
            if i < 10 {
                accountArray = try await BudgetFirebaseManager.shared.fetchPostData(userID: userId, date: "2023-08-0\(i)")
                if !accountArray.isEmpty {
                    //                    print("testaccountarray: \(accountArray)") //test 출력
                    analysisAccountArray.append((i, accountArray))
                } else {
                    
                }
                
            } else {
                accountArray = try await BudgetFirebaseManager.shared.fetchPostData(userID: userId, date: "2023-08-\(i)")
                if !accountArray.isEmpty {
                    //                    print("testaccountarray: \(accountArray)") //test 출력
                    analysisAccountArray.append((i, accountArray))
                } else {
                    
                }
            }
        }
        
        return analysisAccountArray
    }
    
    
    func analysis2FetchAccountSpend(userID userId: String, analysisAccountArray: [(Int, [String])]) async throws -> [(Int, [String])] {
        var tempArray: [String] = []
        var analysisAccountSpendArray: [(Int, [String])] = []
        let accountCollection = db.collection("account")
        
        for analysisAccountIndex in analysisAccountArray {
            //            print(analysisAccountIndex)
            for accountId in analysisAccountIndex.1 {
                let documentReference = accountCollection.document(accountId)
                let document = try await documentReference.getDocument()
                
                if document.exists, let data = document.data() {
                    let account_type = data["account_type"] as? Int ?? 0
                    let detail_id = data["detail_id"] as? String ?? ""
                    
                    if account_type == 0 {
                        tempArray.append(detail_id)
                    }
                }
            }
            analysisAccountSpendArray.append((analysisAccountIndex.0, tempArray))
            tempArray = []
        }
        return analysisAccountSpendArray
    }
    
    
    
    
    
    
    
    func analysis2FetchSpendData(analysisAccountSpendArray: [(Int, [String])]) async throws -> ([(Int, [ReadSpendData])], [Dictionary<Int, Int>.Element]) {
        var overConsumeSpendArray: [(Int, [ReadSpendData])] = []
        var categoryDic:  [Int: Int] = [:]
//        var sortedCategoryDic:  [Int: Int] = [:]
        var tempSpendArray: [ReadSpendData] = []
        var sortedCategoryArray: [Dictionary<Int, Int>.Element] = []
        let spendCollection = db.collection("spend")
        
        
        for analysisAccountIndex in analysisAccountSpendArray {
            for spendId in analysisAccountIndex.1 {
                
                let documentReference = spendCollection.document(spendId)
                let document = try await documentReference.getDocument()
                
                if document.exists, let data = document.data() {
                    let id = data["spend_id"] as? String ?? ""
                    let bill = data["spend_bill"] as? Int ?? 0
                    let category = data["spend_category"] as? Int ?? 0
                    let content = data["spend_content"] as? String ?? ""
                    let open = data["spend_open"] as? Bool ?? false
                    let overConsume = data["spend_overConsume"] as? Bool ?? false
                    
                    if overConsume == true {
                        tempSpendArray.append(ReadSpendData(id: id, bill: bill, category: category, content: content, open: open, overConsume: overConsume))
                        if let existingValue = categoryDic[category] {
                            categoryDic[category] = existingValue + bill
                        } else {
                            categoryDic[category] = bill
                        }
                        
                    }
                    //                print(id)
                    //                print(bill)
                    //                print(category)
                    //                print(content)
                    //                print(open)
                    //                print(overConsume)
                }
                
            }
            overConsumeSpendArray.append((analysisAccountIndex.0, tempSpendArray))
            tempSpendArray = []
        }
        
//        print("categoryDic : : \(categoryDic)")
//        sortedCategoryDic = Dictionary(uniqueKeysWithValues: categoryDic.sorted { $0.value > $1.value })
        sortedCategoryArray = categoryDic.sorted { $0.value > $1.value }
        
        
        return (overConsumeSpendArray, sortedCategoryArray)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - analysis2FetchPost Fucntion 관리 함수
    func analysis2FetchPost(userID userId: String) async throws -> ([(Int, [ReadSpendData])], [Dictionary<Int, Int>.Element]){
        
       
        
        // MARK: - 해당 달의 Account 수입 + 지출 내역 전체
        // 나의 달에 있는 모든 account 저장하는 배열
        var analysisAccountArray: [(Int, [String])] = [] //해당 달의 수입 지출 Account문서 ID 받아오는 배열
        analysisAccountArray = try await analysis2FetchAccount(userID: userId)
        print("main::analysisAccountArray: \(analysisAccountArray)")
        
        
        // MARK: - Account배열에서 지출(Spend) 필터링
        var analysisAccountSpendArray: [(Int, [String])] = []
        analysisAccountSpendArray = try await analysis2FetchAccountSpend(userID: userId, analysisAccountArray: analysisAccountArray)
        print("main::analysisAccountSpendArray: \(analysisAccountSpendArray)")
        
        
        var overConsumeSpendArray: [(Int, [ReadSpendData])] = []
        var sortedCategoryArray: [Dictionary<Int, Int>.Element] = []
        (overConsumeSpendArray, sortedCategoryArray) = try await analysis2FetchSpendData(analysisAccountSpendArray: analysisAccountSpendArray)
        print("main::overConsumeSpendArray: \(overConsumeSpendArray)")
        
        
        
        return (overConsumeSpendArray, sortedCategoryArray)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - end:// AnalysisView 2 Function
    
    
    
    
    
    
    
    
    
    
    // MARK: - AnalysisView 1 Function
    
    
    func analysisFetchAccount(userID userId: String) async throws -> [String] {
        
        //나의 달에 있는 모든 account 저장하는 배열
        var analysisAccountArray: [String] = [] //해당 달의 수입 지출 Account문서 ID 받아오는 배열
        
        for i in 1...31 {
            if i < 10 {
                analysisAccountArray.append(contentsOf: try await BudgetFirebaseManager.shared.fetchPostData(userID: userId, date: "2023-08-0\(i)"))
            } else {
                analysisAccountArray.append(contentsOf: try await BudgetFirebaseManager.shared.fetchPostData(userID: userId, date: "2023-08-\(i)"))
            }
        }
        return analysisAccountArray
        
    }
    
    
    
    func analysisFetchAccountSpend(userID userId: String, analysisAccountArray: [String]) async throws -> [String] {
        var analysisAccountSpendArray: [String] = []
        let accountCollection = db.collection("account")
        
        for accountId in analysisAccountArray {
            let documentReference = accountCollection.document(accountId)
            let document = try await documentReference.getDocument()
            
            if document.exists, let data = document.data() {
                let account_type = data["account_type"] as? Int ?? 0
                let detail_id = data["detail_id"] as? String ?? ""
                
                if account_type == 0 {
                    analysisAccountSpendArray.append(detail_id)
                }
            }
        }
        return analysisAccountSpendArray
    }
    
    func analysisFetchSpendData(analysisAccountSpendArray: [String]) async throws -> (Int, Int, [ReadSpendData]) {
        var totalOverConsume: Int = 0
        var totalConsume: Int = 0
        var overConsumeSpendArray: [ReadSpendData] = []
        let spendCollection = db.collection("spend")
        
        for spendId in analysisAccountSpendArray {
            let documentReference = spendCollection.document(spendId)
            let document = try await documentReference.getDocument()
            
            if document.exists, let data = document.data() {
                let id = data["spend_id"] as? String ?? ""
                let bill = data["spend_bill"] as? Int ?? 0
                let category = data["spend_category"] as? Int ?? 0
                let content = data["spend_content"] as? String ?? ""
                let open = data["spend_open"] as? Bool ?? false
                let overConsume = data["spend_overConsume"] as? Bool ?? false
                
                if overConsume == true {
                    totalOverConsume += bill
                    overConsumeSpendArray.append(ReadSpendData(id: id, bill: bill, category: category, content: content, open: open, overConsume: overConsume))
                }
                totalConsume += bill
                //                print(id)
                //                print(bill)
                //                print(category)
                //                print(content)
                //                print(open)
                //                print(overConsume)
            }
        }
        
        return (totalConsume, totalOverConsume, overConsumeSpendArray)
    }
    
    //Analysis fetchPost
    func analysisFetchPost(userID userId: String) async throws -> (Int, Int, [ReadSpendData]) {
        var totalConsume: Int = 0
        var totalOverConsume: Int = 0
        // MARK: - 해당 달의 Account 수입 + 지출 내역 전체
        // 나의 달에 있는 모든 account 저장하는 배열
        var analysisAccountArray: [String] = [] //해당 달의 수입 지출 Account문서 ID 받아오는 배열
        analysisAccountArray = try await analysisFetchAccount(userID: userId)
        //        print("main::analysisAccountArray: \(analysisAccountArray)")
        
        // MARK: - Account배열에서 지출(Spend) 필터링
        var analysisAccountSpendArray: [String] = []
        analysisAccountSpendArray = try await analysisFetchAccountSpend(userID: userId, analysisAccountArray: analysisAccountArray)
        //        print("main::analysisAccountSpendArray: \(analysisAccountSpendArray)")
        
        // MARK: - 과소비 골라서 데이터 베열에 넣는 필터링
        var overConsumeSpendArray: [ReadSpendData] = []
        (totalConsume, totalOverConsume, overConsumeSpendArray) = try await analysisFetchSpendData(analysisAccountSpendArray: analysisAccountSpendArray)
        //        print("main::overConsumeSpendArray: \(overConsumeSpendArray)")
        
        return (totalConsume, totalOverConsume, overConsumeSpendArray)
    }
    
    
    // MARK: - end:// AnalysisView 1 Function
    
    
    
    
    // fetchPost
    func fetchPostData(userID userId: String, date: String) async throws -> [String] {
        let firestore = Firestore.firestore()
        let postsCollection = firestore.collection("post")
        
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
            
            let listener = query.addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                var updatedAccountArray: [String] = []
                for document in snapshot.documents {
                    if let accountArrayData = document.data()["account_array"] as? [String] {
                        updatedAccountArray.append(contentsOf: accountArrayData)
                    }
                }
                
                accountArray = updatedAccountArray
                print("Data updated with snapshotListener")
            }
            
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
            .addSnapshotListener { (querySnapshot, error) in
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


