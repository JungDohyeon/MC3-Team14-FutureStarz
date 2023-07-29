//
//  GroupRoomView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

struct GroupRoomView: View {
    @StateObject var userData = InputUserData.shared
    @StateObject private var firebaseManager = FirebaseController.shared
    @Environment(\.dismiss) var dismiss
    
    let groupdata: GroupData
    let isNotExist: Bool
    
    @State private var showHasGroupAlert = false
    @State private var showSubmitGroupAlert = false
    @State private var lockStatusModal: Bool = false
    @State private var userGroupStatus: AlertType = .otherCase
    
    
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
                            if userData.group_id != "" {
                                userGroupStatus = .alreadyJoined
                                showSubmitGroupAlert = true
                            } else if groupdata.group_cur >= groupdata.group_max {
                                userGroupStatus = .groupMax
                                showSubmitGroupAlert = true
                            } else {
                                // 그룹에 lock이 걸려있는 경우
                                if groupdata.lock_status {
                                    lockStatusModal = true
                                } else {
                                    showSubmitGroupAlert = true
                                }
                            }
                        } label: {
                            MainColorBtn(inputText: "가입하기")
                        }
                    } else {
                        NavigationLink {
                            GroupInfoView(groupData: groupdata)
                        } label: {
                            HStack(spacing: 3) {
                                Text("랭킹 보기")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(Color("Main"))
                            .modifier(Body2Bold())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .alert(isPresented: $showSubmitGroupAlert) {
                    hasGroupAlert(type: userGroupStatus)
                }
                .sheet(isPresented: $lockStatusModal) {
                    codeInputView(groupdata: groupdata)
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
        case .groupMax:
            return Alert(
                title: Text("해당 그룹에 가입할 수 없어요"),
                message: Text("해당 그룹은 인원이\n모두 차서 들어갈 수 없어요."),
                dismissButton: .cancel(Text("확인"))
            )
        case .otherCase:
            return Alert(
                title: Text("그룹에 가입할까요?"),
                message: Text("가입하면 기록한 지출 내역이 그룹 멤버와 공유돼요."),
                primaryButton: .cancel(Text("취소")),
                secondaryButton: .default(Text("가입")) {
                    firebaseManager.incrementGroupCur(groupID: groupdata.id)
                    
                }
            )
        }
    }
}

// 가입하기 눌렀을 때 알림 종류 판별
enum AlertType {
    case alreadyJoined
    case groupMax
    case otherCase
}

struct codeInputView: View {
    @StateObject var userData = InputUserData.shared
    @StateObject private var firebaseManager = FirebaseController.shared
    @State private var userGroupStatus: AlertType = .otherCase
    @State private var showHasGroupAlert = false
    @State private var showFailGroupText: Bool = false
    @State private var showSubmitGroupAlert = false
    @State private var inputCodeArray: [String] = Array(repeating: "", count: 4)
    
    let groupdata: GroupData
    var body: some View {
        VStack {
            Spacer()
            
            CodeFieldView(inputCodeArray: $inputCodeArray)
                .padding(.bottom, 15)
            
            if showFailGroupText {
                Text("그룹 코드가 일치하지 않습니다.")
                    .modifier(Body2Bold())
                    .foregroundColor(.red)
                    .opacity(showFailGroupText ? 1 : 0)
                    .animation(.easeIn(duration: 2))
            }
            
            Spacer()
            
            Button {
                if inputCodeArray.joined() == groupdata.group_pw {
                    showSubmitGroupAlert = true
                } else {
                    withAnimation {
                        showFailGroupText = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showFailGroupText = false
                        }
                    }
                }
            } label: {
                GroupCreateBtn(validation: CodeFieldView(inputCodeArray: $inputCodeArray).checkBtnStatus(), text: "그룹 가입하기")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .disabled(!CodeFieldView(inputCodeArray: $inputCodeArray).checkBtnStatus())
        }
        .alert(isPresented: $showSubmitGroupAlert) {
            hasGroupAlert(type: userGroupStatus)
        }
    }
    
    private func hasGroupAlert(type: AlertType) -> Alert {
        switch type {
        case .alreadyJoined:
            return Alert(
                title: Text("이미 그룹에 가입되어 있어요"),
                message: Text("현재 가입된 그룹을 나간 후에 새로운 그룹을 가입할 수 있어요."),
                dismissButton: .cancel(Text("확인"))
            )
        case .groupMax:
            return Alert(
                title: Text("해당 그룹에 가입할 수 없어요"),
                message: Text("해당 그룹은 인원이\n모두 차서 들어갈 수 없어요."),
                dismissButton: .cancel(Text("확인"))
            )
        case .otherCase:
            return Alert(
                title: Text("그룹에 가입할까요?"),
                message: Text("가입하면 기록한 지출 내역이 그룹 멤버와 공유돼요."),
                primaryButton: .cancel(Text("취소")),
                secondaryButton: .default(Text("가입")) {
                    firebaseManager.incrementGroupCur(groupID: groupdata.id)
                    
                }
            )
        }
    }
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
