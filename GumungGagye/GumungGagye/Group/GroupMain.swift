//
//  GroupMain.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

// Group Main View
struct GroupMain: View {
    @StateObject var user = InputUserData.shared
    @StateObject private var firebaseManager = FirebaseController.shared
    @State private var userGroupData: GroupData?
    
    var body: some View {
        // TODO: User가 가입된 그룹이 없다면 groupnotexistview 이동 아니면 groupviewinside
        ZStack {
            Color("background").ignoresSafeArea()
            
            if user.group_id == "" || user.group_id == nil {
                GroupNotExistView()
            } else {
                if let userGroupData = userGroupData {
                    GroupViewInside(groupData: userGroupData)
                }
            }
        }
        .onAppear {
            if let userID = user.user_id {
                Task {
                    try await getUser(userId: userID)
                }
                
                fetchData()
            }
        }
        .onChange(of: user.group_id) { newValue in
            if let userID = user.user_id {
                Task {
                    try await getUser(userId: userID)
                }
                fetchData()
            }
            fetchData()
        }
    }
    
    private func getUser(userId: String) async throws {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        user.profile_image_url = data["profile_image_url"] as? String
        user.bankcardpay = data["bankcardpay"] as? Int
        user.bankcardpay_index = data["bankcardpay_index"] as? Int
        user.email = data["email"] as? String
        user.goal = data["goal"] as? Int
        user.group_id = data["group_id"] as? String
        user.nickname = data["nickname"] as? String
        user.bankcardpay_info = (data["bankcardpay_info"] as? [String])!
    }
    
    private func fetchData() {
        Task {
            do {
                if let userGroupID = user.group_id, !userGroupID.isEmpty {
                    let groupData = try await firebaseManager.fetchGroupData(groupId: userGroupID)
                    
                    if let groupData = groupData {
                        userGroupData = groupData
                        print(groupData.id)
                    } else {
                        userGroupData = nil
                    }
                    
                } else {
                    print("유저가 그룹에 속해있지 않습니다.")
                    userGroupData = nil
                }
            } catch {
                userGroupData = nil
                print("Error fetching group data: \(error)")
            }
        }
    }
}
