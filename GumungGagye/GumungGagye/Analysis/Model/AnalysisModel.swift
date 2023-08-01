//
//  AnalysisModel.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/31.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class AnalysiseManager: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var posts: [Post] = []
    
    func Ana_fetchPosts() {
        db.collection("post").getDocuments { (QuerySnapshot, error) in
            if let error = error {
                print("Error Ana_fetching documents: \(error)")
                return
            }
            
            var posts: [Post] = []
            for document in QuerySnapshot!.documents {
                let data = document.data()
                print(data["post_date"] as? String)
                print(data["post_id"] as? String)
                print(data["post_userID"] as? String)
                print(data["account_array"] as? [String])
            }
            
        }
    }
    
}

struct Post {
    let post_date: String
    let post_id: String
    let post_userID: String
    let account_array: [String]
}


