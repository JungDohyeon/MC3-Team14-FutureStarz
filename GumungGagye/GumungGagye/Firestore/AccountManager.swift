//
//  AccountManager.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/23.
//

//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//struct Account: Identifiable, Codable {
//    @DocumentID var id: String?
//    var userID: DocumentReference // userID를 DocumentReference 타입으로 변경
//    var accountID: String
//    var type: Int
//    var date: Date
//}
//
//struct Spend: Identifiable, Codable {
//    @DocumentID var id: String?
//    var userID: DocumentReference
//    var bill: Int
//    var category: Int
//    var content: String
//    var overConsume: Bool
//    var open: Bool
//}
//
//struct Income: Identifiable, Codable {
//    @DocumentID var id: String?
//    var userID: DocumentReference
//    var bill: Int
//    var category: Int
//    var content: String
//}
//
//struct Post: Identifiable, Codable {
//    @DocumentID var id: String?
//    var userID: DocumentReference 
//    var date: Date
//}
//
//final class AccountManager {
//    var db = Firestore.firestore()
//
//
//    func addAccount(account: Account, spend: Spend? = nil, income: Income? = nil) async throws {
//        do {
//            var newAccount = account
//            newAccount.userID = db.collection("users").document(account.userID.documentID)
//            let documentRef = try await db.collection("account").addDocument(from: account)
//            print("Account added with ID: \(documentRef.documentID)")
//            
//            // Spend 데이터가 제공되면 spend 컬렉션에 추가
//            if let spendData = spend {
//                var newSpend = spendData
//                newSpend.userID = account.userID
//                try await db.collection("spend").addDocument(from: newSpend)
//                print("Spend added for Account with ID: \(documentRef.documentID)")
//            }
//                    
//            // Income 데이터가 제공되면 income 컬렉션에 추가
//            if let incomeData = income {
//                var newIncome = incomeData
//                newIncome.userID = account.userID
//                try await db.collection("income").addDocument(from: newIncome)
//                print("Income added for Account with ID: \(documentRef.documentID)")
//            }
//            
//        } catch {
//            print("Error adding account: \(error)")
//        }
//    }
//
//    func updateAccount(account: Account) async throws {
//        do {
//            guard let accountId = account.id else { return }
//            try await db.collection("account").document(accountId).setData(from: account)
//            print("Account updated with ID: \(accountId)")
//        } catch {
//            print("Error updating account: \(error)")
//        }
//    }
//
////    func deleteAccount(account: Account) async throws {
////        if let accountId = account.id {
////            try await db.collection("account").document(accountId).delete
////            print("Account deleted successfully.")
////            
////        }
////    }
//
//    func createPost(post: Post) async throws {
//        do {
//            var newPost = post
//            newPost.userID = db.collection("users").document(post.userID.documentID)
//            let documentRef = try await db.collection("post").addDocument(from: post)
//            print("Post created with ID: \(documentRef.documentID)")
//        } catch {
//            print("Error creating post: \(error)")
//        }
//    }
//    
//    func addExpenseData(expenseData: ExpenseData) async throws {
//        do {
//            var newExpenseData = expenseData
//            newExpenseData.userID = db.collection("users").document(expenseData.userID.documentID)
//            try await db.collection("spend").addDocument(from: newExpenseData)
//            print("Expense data added successfully.")
//        } catch {
//            print("Error adding expense data: \(error)")
//            throw error
//        }
//    }
//    
//    func addIncomeData(incomeData: IncomeData) async throws {
//        do {
//            var newIncomeData = incomeData
//            newIncomeData.userID = db.collection("users").document(incomeData.userID.documentID)
//            try await db.collection("income").addDocument(from: newIncomeData)
//            print("Income data added successfully.")
//        } catch {
//            print("Error adding income data: \(error)")
//            throw error
//        }
//    }
//
//}
