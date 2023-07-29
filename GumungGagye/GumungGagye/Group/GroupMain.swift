//
//  GroupMain.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

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
            fetchData()
            print("onappear user.group_id: \(user.group_id)")
        }
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
