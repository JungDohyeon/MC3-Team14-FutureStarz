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
    @ObservedObject private var firebaseManager = FirebaseController.shared
    @State private var userGroupData: GroupData?
    
    var body: some View {
        // TODO: User가 가입된 그룹이 없다면 groupnotexistview 이동 아니면 groupviewinside
        ZStack {
            Color("background").ignoresSafeArea()
            
            // TODO: User가 가입된 그룹이 없다면 groupnotexistview 이동 아니면 groupviewinside
            if let userGroupData = userGroupData, user.group_id != "" {
                GroupViewInside(groupData: userGroupData)
                let _ = print("Main print user group: \(userGroupData.group_introduce)")
            } else {
                GroupNotExistView()
            }
            
        }
        .onAppear {
           fetchData()
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



