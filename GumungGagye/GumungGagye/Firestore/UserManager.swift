//
//  UserManager.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/19.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage


class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    
    static let shared = FirebaseManager()
    
    override init() {
        
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
    
}

struct DBUser {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
}

final class UserManager {
    let inputdata = InputUserData.shared
    static let shared = UserManager()
    private init() { }
    
    func InsertGroupId(groupId: String) async throws {
        if let userss = Auth.auth().currentUser {
            try await Firestore.firestore().collection("users").document(userss.uid).updateData(["group_id": groupId])
        }
        
       inputdata.group_id = groupId
    }
    
    func createNewUser() async throws {
        let userData: [String:Any] = [
            "user_id": inputdata.user_id,
            "email": inputdata.email,
            "nickname": inputdata.nickname,
            "group_id": "",
            "goal": inputdata.goal,
            "bankcardpay": inputdata.bankcardpay,
            "bankcardpay_index": inputdata.bankcardpay_index,
            "profile_image_url": inputdata.profile_image_url,
            "bankcardpay_info": inputdata.bankcardpay_info
        ]
        
        if let userss = Auth.auth().currentUser {
            try await Firestore.firestore().collection("users").document(userss.uid).setData(userData, merge: false)
        }
    }
    
    func getUser(userId: String) async throws -> Bool {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            return false
        }
        return true
    }
}
