//
//  GroupData.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import Foundation
import Firebase

struct GroupData: Identifiable {
    var id: String
    var group_name: String  // 그룹 이름
    var group_introduce: String // 그룹 설명
    var group_goal: Int // 그룹 목표 금액
    var group_cur: Int  // 현재 인원
    var group_max: Int  // 최대 인원
    var lock_status: Bool   // 비공개 여부
    var group_pw: String   // 비공개 비번
    var timeStamp: Date = Date()
}


class GroupListStore: ObservableObject {
    @Published var groupList = [GroupData]()
    
    func addData(group_name: String, group_introduce: String, group_goal: Int, group_cur: Int, group_max: Int, lock_status: Bool, group_pw: String, makeTime: Date) {
        let db = Firestore.firestore()
        
        db.collection("groupRoom").addDocument(data: ["group_name" : group_name, "introduce": group_introduce, "group_goal": group_goal, "group_cur": group_cur, "group_max": group_max, "lock_status": lock_status, "group_pw": group_pw, "timeStamp": makeTime]) { error in
            if error == nil {
                // if no error
                //                self.fetchData()
            }
            else {
                // handle Error
            }
        }
    }
    
    
    // fetchData from Firestore Cloud
    func fetchData() {
        let db = Firestore.firestore()
        
        db.collection("groupRoom").order(by: "timeStamp", descending: true).getDocuments { snapshot, error in
            
            // check error
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    // update list property in main Thread
                    DispatchQueue.main.async {
                        self.groupList = snapshot.documents.map { document in
                            return GroupData(id: document.documentID, group_name: document["group_name"] as? String ?? "", group_introduce: document["introduce"] as? String ?? "", group_goal: document["group_goal"] as? Int ?? 0, group_cur: document["group_cur"] as? Int ?? 0, group_max: document["group_max"] as? Int ?? 0, lock_status: document["lock_status"] as? Bool ?? false, group_pw: document["group_pw"] as? String ?? "")
                        }
                    }
                }
            } else {
                // handle the error
            }
        }
    }
    
    // delete group
    func deleteData(deleteGroup: GroupData) {
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
    
//    Update Group Func
//    func updateData(updateGroup: GroupData) {
//        let db = Firestore.firestore()
//
//        db.collection("groupRoom").document(updateGroup.id).setData([""])
//    }
}
