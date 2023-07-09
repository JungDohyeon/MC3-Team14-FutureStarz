//
//  CreateGroupView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

struct CreateGroupView: View {
    @ObservedObject var store = GroupListStore()
    @Environment(\.dismiss) var dismiss
    
    // group data
    @State private var groupName: String = ""
    @State private var groupContent: String = ""
    @State private var groupGoal: Int = 0
    @State private var groupMax: Int = 1
    @State private var isSecretRoom: Bool = false
    @State private var groupCode: String = ""
    
    // validation variable
    @State private var groupNameValidate: Bool = false
    @State private var groupIntroValidate: Bool = false
    @State private var groupGoalValidate: Bool = false
    @State private var groupCodeValidate: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("그룹 생성하기")
                    .modifier(H1Bold())
                    .padding(.bottom, 38)
                
                Spacer()
            }
            
            VStack(spacing: 24) {
                CreateGroupInfo(userInput: $groupName, getType: "그룹명", getMaxString: 15)
                    .onChange(of: groupName) { newValue in
                        if newValue.count > 0 {
                            groupNameValidate = true
                        } else if newValue.count == 0 {
                            groupNameValidate = false
                        }
                    }
                
                CreateGroupInfo(userInput: $groupContent, getType: "그룹소개", getMaxString: 60)
                    .onChange(of: groupContent) { newValue in
                        if newValue.count > 0 {
                            groupIntroValidate = true
                        } else if newValue.count == 0 {
                            groupIntroValidate = false
                        }
                    }
                
                HStack {
                    Text("목표 금액")
                        .modifier(Body1Bold())
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(Color("Gray1"))
                    
                    Spacer()
                    
                    TextField("0", value: $groupGoal, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .frame(width: 200)
                        .modifier(Num1())
                    
                    Text("원")
                        .modifier(Body1Bold())
                        .foregroundColor(Color("Gray1"))
                }
                .padding(.vertical, 24)
                
                HStack {
                    Text("최대 인원")
                        .modifier(Body1Bold())
                        .frame(width: 100, alignment: .leading)
                        .foregroundColor(Color("Gray1"))
                    
                    Spacer()
                    
                    Menu {
                        ForEach(1...10, id: \.self) { num in
                            Button(action: {
                                groupMax = num
                            }) {
                                Text("\(num)")
                            }
                        }
                    } label: {
                        HStack {
                            Text(groupMax.description)
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(Color("Gray2"))
                    }
                }
                .padding(.bottom, 24)
                
                HStack {
                    Toggle(isOn: $isSecretRoom) {
                        Text("비공개 그룹 설정")
                            .modifier(Body1Bold())
                            .frame(width: 110, alignment: .leading)
                            .foregroundColor(Color("Gray1"))
                    }
                    .onChange(of: isSecretRoom) { newValue in
                        if !newValue {
                            groupCode = ""
                            groupCodeValidate = false
                        }
                    }
                }
                .padding(.bottom, 24)
                
                if isSecretRoom {
                    HStack {
                        Text("비밀번호")
                            .modifier(Body1Bold())
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(Color("Gray1"))
                        
                        Spacer()
                        
                        TextField("0 0 0 0", text: $groupCode)
                            .multilineTextAlignment(.trailing)
                            .modifier(Num2())
                            .onChange(of: groupCode) { newValue in
                                groupCode = String(newValue.prefix(4))
                                
                                if newValue.count == 4 {
                                    groupCodeValidate = true
                                } else {
                                    groupCodeValidate = false
                                }
                            }
                    }
                }
            }
            
            Spacer()
            
            // add group Btn
            Button {
                store.addData(group_name: groupName, group_introduce: groupContent, group_goal: groupGoal, group_cur: 1, group_max: groupMax, lock_status: isSecretRoom, group_pw: groupCode)
                dismiss()
            } label: {
                GroupCreateBtn(validation: (groupNameValidate && groupIntroValidate && (isSecretRoom == groupCodeValidate)))
            }
            .disabled(!(groupNameValidate && groupIntroValidate && (isSecretRoom == groupCodeValidate)))
            .padding(.bottom, 60)
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 78)
    }
}

// Get create group info (title, content)
struct CreateGroupInfo: View {
    
    @Binding var userInput: String
    var getType: String
    var getMaxString: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(getType)
                    .modifier(Body2())
                    .frame(width: 50, alignment: .leading)
                    .foregroundColor(Color("Gray1"))
                    .padding(.trailing, 20)
                
                Spacer()
                
                
                TextField("\(getType)을 입력해주세요", text: $userInput)
                    .border(.black)
                    .frame(width: 200)
                    .onChange(of: userInput) { newValue in
                        userInput = String(newValue.prefix(getMaxString))
                    }
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text(userInput.count.description)
                    Text("/")
                    Text(getMaxString.description)
                }
                .modifier(Cap1())
                .foregroundColor(Color("Gray2"))
            }
            .padding(.bottom, 21)
            
            Divider()
                .background(Color("Gray3"))
        }
    }
}


struct GroupCreateBtn: View {
    var validation: Bool
    
    var body: some View {
        Text("그룹 생성하기")
            .modifier(BtnBold())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                Rectangle()
                    .foregroundColor(validation ? Color("Main") : Color("Gray2"))
            )
    }
}


struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
            .environmentObject(GroupListStore())
    }
}
