//
//  ReadAccountManager.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/28.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ReadAccountManager {
    
    let db = Firestore.firestore()
    static let shared = ReadAccountManager()
    private init() { }
    
    func fetchAccountData(account_id: String, completion: @escaping (AccountData?) -> Void) {
        // accounts 컬렉션에서 해당 account_id에 해당하는 문서를 조회
        db.collection("account").document(account_id).getDocument {(snapshot, error) in
            if let error = error {
                print("Error fetching account data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = snapshot?.data(),
               var accountData = AccountData(data: data) {
                
                // account_type이 0일 때는 spend_id에 해당하는 SpendData도 함께 불러오기
                if accountData.account_type == 0, let spend_id = accountData.spend_data?.spend_id {
                    self.fetchSpendData(spend_id: spend_id) { (spendData) in
                        // SpendData가 불러와지면 accountData에 할당
                        accountData.spend_data = spendData
                        completion(accountData)
                    }
                }
                // account_type이 1일 때는 income_id에 해당하는 IncomeData도 함께 불러오기
                else if accountData.account_type == 1, let income_id = accountData.income_data?.income_id {
                    self.fetchIncomeData(income_id: income_id) { (incomeData) in
                        // IncomeData가 불러와지면 accountData에 할당
                        accountData.income_data = incomeData
                        completion(accountData)
                    }
                } else {
                    // account_type이 0 또는 1이 아닌 경우, 그냥 accountData를 반환
                    completion(accountData)
                }
            } else {
                // 데이터가 없거나 AccountData 초기화 실패 시 nil 반환
                completion(nil)
            }
        }
    }

    // SpendData를 불러오는 함수
    func fetchSpendData(spend_id: String, completion: @escaping (SpendData?) -> Void) {

        // spend_data 컬렉션에서 해당 spend_id에 해당하는 문서를 조회
        db.collection("spend_data").document(spend_id).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching spend data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = snapshot?.data(),
               let spendData = SpendData(data: data) {
                // SpendData를 성공적으로 불러오면 해당 데이터를 반환
                completion(spendData)
            } else {
                // 데이터가 없거나 SpendData 초기화 실패 시 nil 반환
                completion(nil)
            }
        }
    }

    // IncomeData를 불러오는 함수
    func fetchIncomeData(income_id: String, completion: @escaping (IncomeData?) -> Void) {
        
        // income_data 컬렉션에서 해당 income_id에 해당하는 문서를 조회
        db.collection("income_data").document(income_id).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching income data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = snapshot?.data(),
               let incomeData = IncomeData(data: data) {
                // IncomeData를 성공적으로 불러오면 해당 데이터를 반환
                completion(incomeData)
            } else {
                // 데이터가 없거나 IncomeData 초기화 실패 시 nil 반환
                completion(nil)
            }
        }
    }

}
