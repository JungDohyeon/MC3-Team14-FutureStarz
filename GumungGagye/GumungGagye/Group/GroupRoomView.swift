//
//  GroupRoomView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

struct GroupRoomView: View {
    @StateObject var userData = InputUserData.shared
    @ObservedObject private var firebaseManager = FirebaseController.shared
    
    let groupdata: GroupData
    let isNotExist: Bool
    
    @State private var showHasGroupAlert = false
    @State private var showSubmitGroupAlert = false
    @State private var userGroupStatus: AlertType = .otherCase
    
    func updateGroupFirestore(groupId: String) async throws {
        try await UserManager.shared.InsertGroupId(groupId: groupId)
    }
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            // MARK: 그룹 명
            VStack(spacing: 0) {
                HStack(spacing: 5){
                    if groupdata.lock_status {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Main"))
                    }
                    
                    Text(groupdata.group_name)
                        .modifier(Body1Bold())
                        .foregroundColor(Color("Black"))
                    
                    Spacer()
                }
                .padding(.bottom, 8)
                
                
                // MARK: 그룹 소개 글
                
                HStack {
                    Text(groupdata.group_introduce)
                        .modifier(Body2())
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color("Gray1"))
                    
                    Spacer()
                }
                .padding(.bottom, 16)
                
                // MARK: 그룹 목표 금액, 최대 인원
                
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "wonsign.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Gray2"))
                        
                        HStack(spacing: 0) {
                            Text("\(groupdata.group_goal)")
                            Text("원")
                        }
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    }
                    .padding(.trailing, 20)
                    
                    HStack(spacing: 0) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Gray2"))
                            .padding(.trailing, 7)
                        
                        Group {
                            Text(groupdata.group_cur.description)
                            Text("/")
                            Text(groupdata.group_max.description)
                            Text("명")
                        }
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    }
                    
                    Spacer()
                    
                    // MARK: 가입 버튼
                    // 가입된 그룹이 없을 경우 가입 버튼 생성 (그룹 정보 보여주기 뷰 때문)
                    if isNotExist {
                        Button {
                            showSubmitGroupAlert = true
                            
                            if userData.group_id != "" {
                                userGroupStatus = .alreadyJoined
                            }
                            
                        } label: {
                            MainColorBtn(inputText: "가입하기")
                        }
                    }
                }
                .alert(isPresented: $showSubmitGroupAlert) {
                    hasGroupAlert(type: userGroupStatus)
                }
                
                if isNotExist {
                    Spacer()
                    
                    Divider()
                        .background(Color("Gray3"))
                }
            }
        }
        .frame(height: 117)
    }
    
    private func hasGroupAlert(type: AlertType) -> Alert {
        switch type {
        case .alreadyJoined:
            return Alert(
                title: Text("이미 그룹에 가입되어 있어요"),
                message: Text("현재 가입된 그룹을 나간 후에 새로운 그룹을 가입할 수 있어요."),
                dismissButton: .cancel(Text("확인"))
            )
        case .otherCase:
            return Alert(
                title: Text("그룹에 가입할까요?"),
                message: Text("가입하면 기록한 지출 내역이 그룹 멤버와 공유돼요."),
                primaryButton: .cancel(Text("취소")),
                secondaryButton: .default(Text("가입")) {
                    print("User: \(userData.nickname) Joined \(groupdata.group_name)")
                    firebaseManager.incrementGroupCur(groupID: groupdata.id)
                }
            )
        }
    }
}

// 가입하기 눌렀을 때 알림 종류 판별
enum AlertType {
    case alreadyJoined
    case otherCase
}


struct MainColorBtn: View {
    var inputText: String
    
    var body: some View {
        Text(inputText)
            .modifier(Body2Bold())
            .foregroundColor(Color("Main"))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Rectangle()
                    .foregroundColor(Color("Light"))
                    .cornerRadius(12)
            )
    }
}


struct GroupRoomView_Previews: PreviewProvider {
    static var previews: some View {
        GroupRoomView(groupdata: GroupData(id: "1", group_name: "test", group_introduce: "test", group_goal: 100000, group_cur: 7, group_max: 10, lock_status: true, group_pw: "1234", timeStamp: Date()), isNotExist: true)
    }
}
