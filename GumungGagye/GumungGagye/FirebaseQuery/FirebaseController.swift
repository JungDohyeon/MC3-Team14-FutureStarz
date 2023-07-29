//
//  GroupData.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import Foundation
import Firebase

class FirebaseController: ObservableObject {
    static let shared = FirebaseController()    // SingleTon
    @Published var groupList = [GroupData]()
    let inputdata = InputUserData.shared
    
    func updateGroupFirestore(groupId: String) async throws {
        try await UserManager.shared.InsertGroupId(groupId: groupId)
    }
    
    private init() { }
    
    // MARK: Add Group Room Data
    func addGroupData(group_name: String, group_introduce: String, group_goal: Int, group_cur: Int, group_max: Int, lock_status: Bool, group_pw: String, makeTime: Date) {
        let db = Firestore.firestore()
        
        var groupData: [String: Any] = [
            "group_name": group_name,
            "introduce": group_introduce,
            "group_goal": group_goal,
            "group_cur": group_cur,
            "group_max": group_max,
            "lock_status": lock_status,
            "group_pw": group_pw,
            "timeStamp": makeTime,
            "group_id": ""
        ]
        
        var newDocumentRef: DocumentReference? = nil
        newDocumentRef = db.collection("groupRoom").addDocument(data: groupData) { error in
            if let error = error {
                // handle Error
                print("Error adding document: \(error)")
            } else {
                // Document added successfully, and the auto-generated ID is stored in newDocumentRef.
                let group_id = newDocumentRef?.documentID.description
                
                if let group_id = group_id {
                    newDocumentRef?.updateData(["group_id" : String(group_id)])
                    self.inputdata.group_id = group_id   // 그룹 생성한 유저의 정보 업데이트
                    Task {
                        do {
                            try await self.updateGroupFirestore(groupId: group_id)
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    print("error occur ")
                }
                
                // Now you can use the group_id as needed.
                // For example, if you want to update the document with this ID, you can do something like this:
                // db.collection("groupRoom").document(group_id).updateData(["fieldToUpdate": newValue])
            }
        }
        
        if let users = Auth.auth().currentUser {
            // 그룹 내부에 userID 추가
            newDocumentRef?.updateData(["userId_array" : FieldValue.arrayUnion([users.uid])])
        }
    }
    
    
    // MARK: fetchData from Firestore Cloud
    func fetchAllGroupData() {
        let db = Firestore.firestore()
        
        // addSnapshotListner를 통해 실시간으로 데이터의 변경 사항 수신
        db.collection("groupRoom").order(by: "timeStamp", descending: true).addSnapshotListener { snapshot, error in
            
            // check error
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    // update list property in main Thread
                    DispatchQueue.main.async {
                        self.groupList = snapshot.documents.map { document in
                            return GroupData(id: document.documentID, group_name: document["group_name"] as? String ?? "", group_introduce: document["introduce"] as? String ?? "", group_goal: document["group_goal"] as? Int ?? 0, group_cur: document["group_cur"] as? Int ?? 0, group_max: document["group_max"] as? Int ?? 0, lock_status: document["lock_status"] as? Bool ?? false, group_pw: document["group_pw"] as? String ?? "", timeStamp: Date())
                        }
                    }
                }
            } else {
                // handle the error
            }
        }
    }
    
    
    //    // MARK: fetch User Data Test
    //    func callUserData() {
    //        let db = Firestore.firestore()
    //
    //        db.collection("account").getDocuments { document, error in
    //            if error == nil {
    //                if let document = document {
    //                    self.accountList = document.documents.map { document in
    //                        let documentRef: DocumentReference = document["account_userID"] as! DocumentReference   // documentRef -> 해당 reference가 가리키는 위치 데이터.
    //                        /*
    //                         documentRef.documentID -> documentRef가 가리키는 문서의 ID 값. (user의 ID 값)
    //                         documentRef.path -> 가리키는 문서의 경로
    //
    //                         */
    //                        print("start Document: \(document.data())")
    //
    //                        documentRef.getDocument { userSnapshot, userError in
    //                            if let userSnapshot = userSnapshot, userSnapshot.exists {
    //                                if let userData = userSnapshot.data() {
    //                                    print("userData from Account Reference: \n \(userData)")
    //                                }
    //                            }
    //                        }
    //
    //
    //                        return AccountData(id: "", account_date: Date(), account_id: "", account_type: 0, account_userID: document["account_userID"] as! DocumentReference)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    // 현재 로그인 중인 유저 반환.
    //    static func fetchUserInfo(completion: @escaping (UserData?) -> Void) {
    //        if let currentUser = Auth.auth().currentUser {
    //            let uid = currentUser.uid
    //            let db = Firestore.firestore()
    //            let userRef = db.collection("user").document(uid)
    //
    //            userRef.getDocument { document, error in
    //                if let document = document, document.exists {
    //                    let data = document.data()
    //                    let user = UserData(data: data!)
    //                    completion(user)
    //                } else {
    //                    completion(nil)
    //                }
    //            }
    //        } else {
    //            completion(nil)
    //        }
    //    }
    
    // MARK: delete group
    func deleteGroupData(deleteGroup: GroupData) {
        let db = Firestore.firestore()
        
        db.collection("groupRoom").document(deleteGroup.id).delete { error in
            if error == nil {
                // check for errors
                DispatchQueue.main.async {
                    self.groupList.removeAll { group in
                        return group.id == deleteGroup.id
                    }
                }
            }
        }
    }
    
    // Update Group Func (인원 유입)
    func incrementGroupCur(groupID: String) {
        let db = Firestore.firestore()
        // 해당 그룹의 Document 참조
        
        let groupRef = db.collection("groupRoom").document(groupID)
        
        // 해당 그룹의 현재 groupCur 값을 가져오기
        groupRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // 현재 groupCur 값이 있으면 1 증가시키고 업데이트
                DispatchQueue.main.async {
                    if var groupData = document.data(),
                       let currentGroupCur = groupData["group_cur"] as? Int {
                        let maxGroup = groupData["group_max"] as? Int
                        if  currentGroupCur >= maxGroup! {
                            print("정원 초과")
                            return
                        } else {
                            self.inputdata.group_id = groupID
                            Task {
                                do {
                                    try await self.updateGroupFirestore(groupId: groupID)
                                } catch {
                                    print(error)
                                }
                            }
                            
                            
                            groupData["group_cur"] = currentGroupCur + 1
                        }
                        
                        groupRef.setData(groupData) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        
                        if let users = Auth.auth().currentUser {
                            // 그룹 내부에 userID 추가
                            groupRef.updateData(["userId_array" : FieldValue.arrayUnion([users.uid])])
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // 그룹 데이터 가져오기
    func fetchGroupData(groupId: String) async throws -> GroupData? {
        let db = Firestore.firestore()
        let groupRoomCollection = db.collection("groupRoom")
        
        let documentReference = groupRoomCollection.document(groupId)
        
        do {
            let document = try await documentReference.getDocument()
            if document.exists, let data = document.data() {
                // Parse the Firestore data and create the GroupData instance
                let id = document.documentID
                let group_name = data["group_name"] as? String ?? ""
                let group_introduce = data["introduce"] as? String ?? ""
                let group_goal = data["group_goal"] as? Int ?? 0
                let group_cur = data["group_cur"] as? Int ?? 0
                let group_max = data["group_max"] as? Int ?? 0
                let lock_status = data["lock_status"] as? Bool ?? false
                let group_pw = data["group_pw"] as? String ?? ""
                let timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
                
                return GroupData(id: id,
                                 group_name: group_name,
                                 group_introduce: group_introduce,
                                 group_goal: group_goal,
                                 group_cur: group_cur,
                                 group_max: group_max,
                                 lock_status: lock_status,
                                 group_pw: group_pw,
                                 timeStamp: timeStamp.dateValue())
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    
    // Update Group Func (인원 감소)
    func decrementGroupCur(groupID: String) {
        let db = Firestore.firestore()
        // 해당 그룹의 Document 참조
        
        let groupRef = db.collection("groupRoom").document(groupID)
        
        // 해당 그룹의 현재 groupCur 값을 가져오기
        groupRef.getDocument { (document, error) in
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    // 현재 groupCur 값이 있으면 1 감소
                    if var groupData = document.data(),
                       let currentGroupCur = groupData["group_cur"] as? Int {
                        Task {
                            do {
                                try await self.updateGroupFirestore(groupId: "")
                            } catch {
                                print(error)
                            }
                        }
                        
                        groupData["group_cur"] = currentGroupCur - 1
                        
                        groupRef.setData(groupData) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        
                        if let users = Auth.auth().currentUser {
                            // 그룹 내부에 userID 제거
                            groupRef.updateData(["userId_array" : FieldValue.arrayRemove([users.uid])]){ error in
                                if let error = error {
                                    print("Error decrement dupdating document: \(error)")
                                } else {
                                    print("Document decrement updated successfully.")
                                }
                            }
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // 그룹 안에 있는 유저 정보 가져오기.
    func fetchDataGroupUser(groupID: String, completion: @escaping ([UserData]?) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection("groupRoom").document(groupID)
        
        documentRef.addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("error occur")
                completion(nil)
                return
            }
            
            if document.exists {
                if let data = document.data(),
                   let arrayData = data["userId_array"] as? [String] {
                    guard !arrayData.isEmpty else {
                        print("'userId_array' is empty.")
                        completion(nil)
                        return
                    }
                    self.fetchUsersData(userIDs: arrayData, completion: completion)
                } else {
                    completion(nil)
                }
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    func fetchUsersData(userIDs: [String], completion: @escaping ([UserData]?) -> Void) {
        let db = Firestore.firestore()
        let usersCollectionRef = db.collection("users")
        
        usersCollectionRef.whereField("user_id", in: userIDs).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                completion(nil)
                return
            }
            
            var users: [UserData] = []
            
            for document in querySnapshot!.documents {
                let data = document.data()
                let user = UserData(data: data)
                users.append(user)
            }
            
            completion(users)
        }
    }
    
}
