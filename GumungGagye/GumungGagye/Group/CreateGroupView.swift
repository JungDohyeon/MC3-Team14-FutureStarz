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
    
    @State private var inputCodeArray: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: CodeField?
    
    // group data
    @State private var groupName: String = ""
    @State private var groupContent: String = ""
    @State private var groupGoalString: String = ""
    @State private var groupMax: Int = 0
    @State private var isSecretRoom: Bool = false
    @State private var groupCode: String = ""
    
    // validation variable
    @State private var groupNameValidate: Bool = false
    @State private var groupIntroValidate: Bool = false
    @State private var groupMaxValidate: Bool = false
    @State private var groupGoalValidate: Bool = false
    @State private var isMaxNumPickerPresented: Bool = false
    @State private var DividerSelect: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("그룹 생성하기")
                    .modifier(H1Bold())
                    .padding(.bottom, 48)
                
                Spacer()
            }
            
            VStack(spacing: 23) {
                CreateGroupInfo(userInput: $groupName, getType: "그룹 이름", getMaxString: 15)
                    .onChange(of: groupName) { newValue in
                        if newValue.count > 0 {
                            groupNameValidate = true
                        } else if newValue.count == 0 {
                            groupNameValidate = false
                        }
                    }
                
                CreateGroupInfo(userInput: $groupContent, getType: "그룹 소개", getMaxString: 50)
                    .onChange(of: groupContent) { newValue in
                        if newValue.count > 0 {
                            groupIntroValidate = true
                        } else if newValue.count == 0 {
                            groupIntroValidate = false
                        }
                    }
                
                HStack(spacing: 23) {
                    Text("목표 금액")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    
                    
                    TextField("목표 금액을 입력해주세요", text: $groupGoalString, onEditingChanged: { isEditing in
                        DividerSelect = isEditing
                    }
                    )
                    .modifier(Body1Bold())
                    .keyboardType(.numberPad)
                    .onChange(of: groupGoalString) { newValue in
                        if newValue.count > 0 {
                            groupGoalValidate = true
                        } else if newValue.count == 0 {
                            groupGoalValidate = false
                            
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 16))
                        .foregroundColor(Color("Gray2"))
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(DividerSelect ? Color("Main") : Color("Gray4"))
                
                HStack(spacing: 23) {
                    Text("최대 인원")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    
                    HStack {
                        Text(groupMax == 0 ? "최대 인원을 선택해주세요" : groupMax.description)
                            .modifier(Body1Bold())
                            .foregroundColor(groupMax == 0 ? Color("Gray2") : .black)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Gray2"))
                    }
                    .onTapGesture {
                        isMaxNumPickerPresented = true
                    }
                    .onChange(of: groupMax) { newValue in
                        if newValue != 0 {
                            groupMaxValidate = true
                        }
                    }
                }
                .sheet(isPresented: $isMaxNumPickerPresented) {
                    PickerModalView(selectedValue: $groupMax)
                        .presentationDetents([.fraction(0.3)])
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color("Gray4"))
                
                HStack {
                    Toggle(isOn: $isSecretRoom) {
                        Text("비공개 그룹 설정")
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                            .frame(width: 110, alignment: .leading)
                    }
                    .tint(Color("Main"))
                }
                .padding(.bottom, 24)
                
                if isSecretRoom {
                    HStack {
                        Text("비밀번호")
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                            .frame(width: 100, alignment: .leading)
                        
                        Spacer()
                        
                        CodeField()
                            .onChange(of: inputCodeArray) { newValue in
                                letterCondition(value: newValue)
                            }
                            .onAppear {
                                focusedField = .f1
                            }
                    }
                }
            }
            
            Spacer()
            
            // add group Btn
            Button {
                groupCode = inputCodeArray.joined()
                let _ = print(isSecretRoom)
                store.addData(group_name: groupName, group_introduce: groupContent, group_goal: Int(groupGoalString) ?? 0, group_cur: 1, group_max: groupMax, lock_status: isSecretRoom, group_pw: groupCode, makeTime: Date())
                dismiss()
            } label: {
                GroupCreateBtn(validation: (groupNameValidate && groupIntroValidate &&
                                            groupMaxValidate && groupGoalValidate && (isSecretRoom == !checkBtnStatus())))
            }
            .disabled(!(groupNameValidate && groupIntroValidate && groupMaxValidate && groupGoalValidate && (isSecretRoom == !checkBtnStatus())))
            .padding(.bottom, 60)
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 78)
        .onTapGesture { // 키보드밖 화면 터치시 키보드 사라짐
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
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
                    
                    Rectangle()
                        .fill(focusedField == activeStateForIndex(index: idx) ? Color("Main") : Color("Gray3"))
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
                return true
            }
        }
        return false
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
        case 0: return .f1
        case 1: return .f2
        case 2: return .f3
        default: return .f4
        }
    }
}

// code 입력창 focus state
enum CodeField {
    case f1
    case f2
    case f3
    case f4
}

// 키보드밖 화면 터치시 키보드 사라짐
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// Get create group info (title, content)
struct CreateGroupInfo: View {
    @State private var DividerSelect: Bool = false
    
    @Binding var userInput: String
    var getType: String
    var getMaxString: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 23) {
                Text(getType)
                    .modifier(Body2())
                    .foregroundColor(Color("Gray1"))
                
                TextField("\(getType)을 입력해주세요", text: $userInput, onEditingChanged: { isEditing in
                    if isEditing {
                        DividerSelect = true
                    } else {
                        DividerSelect = false
                    }
                })
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .modifier(Body1Bold())
                .foregroundColor(userInput.count == 0 ? Color("Gray2") : Color.black)
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
            .padding(.bottom, 22)
            
            Divider()
                .frame(height: 1)
                .overlay(DividerSelect ? Color("Main") : Color("Gray4"))
        }
    }
}

struct PickerModalView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedValue: Int
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedValue, label: Text("Test")) {
                    ForEach(2...10, id: \.self) { num in
                        Text(num.description)
                    }
                }
                .labelsHidden()
                .pickerStyle(.wheel)
            }
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }, label: {
                Text("완료")
            }) )
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
            .padding(.vertical, 16.5)
            .background(
                Rectangle()
                    .foregroundColor(validation ? Color("Main") : Color("Gray3"))
                    .cornerRadius(12)
            )
    }
}


struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
            .environmentObject(GroupListStore())
    }
}
