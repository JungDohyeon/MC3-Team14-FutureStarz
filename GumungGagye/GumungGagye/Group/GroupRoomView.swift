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
    
    @State private var inputCodeArray: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: CodeField?
    
    @State private var showHasGroupAlert = false
    @State private var showSubmitGroupAlert = false
    @State private var userGroupStatus: AlertType = .otherCase
    @State private var lockStatusModal: Bool = false
    
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
                            }
                            
                            // 그룹에 lock이 걸려있는 경우
                            if groupdata.lock_status {
                                let _ = print("lock lock!")
                                lockStatusModal = true
                            } else {
                                showSubmitGroupAlert = true
                            }
                            
                        } label: {
                            MainColorBtn(inputText: "가입하기")
                        }
                    } else {
                        NavigationLink {
                            Text("랭킹뷰입니다.")
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
                .sheet(isPresented: $lockStatusModal) {
                    VStack {
                        CodeField()
                            .onChange(of: inputCodeArray) { newValue in
                                letterCondition(value: newValue)
                            }
                            .onAppear {
                                print("omapper!!!")
                                focusedField = .code1 
                            }
                        
                        Button {
                            if inputCodeArray.joined() == groupdata.group_pw {
                                lockStatusModal = false
                            } else {
                                print("비밀번호가 일치하지 않습니다.")
                            }
                        } label: {
                            Text("제출")
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
    
    // code input field
    @ViewBuilder
    func CodeField() -> some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { idx in
                VStack(spacing: 8) {
                    TextField("", text: $inputCodeArray[idx])
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .modifier(Num3())
                        .focused($focusedField, equals: activeStateForIndex(index: idx))
                    
                    // 번호가 채워진 칸은 파란 밑줄로 수정
                    Rectangle()
                        .fill(((focusedField == activeStateForIndex(index: idx)) || inputCodeArray[idx].count != 0) ? Color("Main") : Color("Gray3"))
                        .frame(height: 2)
                }
                .frame(width: 48)
            }
        }
    }
    
    // 코드 입력 Validation 확인
    func checkBtnStatus() -> Bool {
        for i in 0..<4 {
            if inputCodeArray[i].isEmpty {
                return false
            }
        }
        
        return true
    }
    
    func letterCondition(value: [String])  {
        // 한 글자 입력되면 다음 칸으로 이동하기.
        for i in 0..<3 {
            if value[i].count == 1 && activeStateForIndex(index: i) == focusedField {
                focusedField = activeStateForIndex(index: i + 1)
            }
        }
        
        // 뒤로가기
        for i in 1...3 {
            if value[i].isEmpty && !value[i - 1].isEmpty {
                focusedField = activeStateForIndex(index: i - 1)
            }
        }
        
        
        // 한 글자 이상 입력되는 경우 마지막 한 글자만 받는다.
        for i in 0..<4 {
            if value[i].count == 2 {
                inputCodeArray[i] = String(value[i].last!)
            }
        }
    }
    
    func activeStateForIndex(index: Int) -> CodeField {
        switch index {
        case 0: return .code1
        case 1: return .code2
        case 2: return .code3
        default: return .code4
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
