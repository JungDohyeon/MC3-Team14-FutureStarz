//
//  ReadAccountManager.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/28.
//

import Foundation
import Firebase

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



