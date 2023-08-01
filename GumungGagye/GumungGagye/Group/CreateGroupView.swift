//
//  CreateGroupView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI
import FirebaseAuth

// Integer만 받도록 하는 클래스. (목표 금액 필드에 사용)
class NumbersOnlyInput: ObservableObject {
    @Published var groupGoalValue = "" {
        didSet {
            let filtered = groupGoalValue.filter { $0.isNumber }
            
            if groupGoalValue != filtered {
                groupGoalValue = filtered
            }
        }
    }
}

struct CreateGroupView: View {
    @ObservedObject var input = NumbersOnlyInput()
    @StateObject private var firebaseManager = FirebaseController.shared
    @StateObject var inputdata = InputUserData.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var inputCodeArray: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: CodeField?
    
    // group data
    @State private var groupName: String = ""
    @State private var groupCaption: String = ""
    @State private var groupMax: String = ""
    @State private var isSecretRoom: Bool = false
    @State private var groupCode: String = ""
    
    // validation variable
    @State private var groupNameValidate: Bool = false
    @State private var groupIntroValidate: Bool = false
    @State private var groupMaxValidate: Bool = false
    @State private var groupGoalValidate: Bool = false
    @State private var isMaxNumPickerPresented: Bool = false
    @State private var createAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("그룹 생성하기")
                    .modifier(H1Bold())
                    .padding(.bottom, 48)
                
                Spacer()
            }
            
            VStack(spacing: 23) {
                // MARK: 그룹 이름
                GetStringGroupInfo(userInput: $groupName, checkStatus: $groupNameValidate, focusedValue: _focusedField, focusType: .groupName, getTitle: "그룹 이름을 입력해주세요", getMaxString: 15)
                    .focused($focusedField, equals: .groupName)
                
                // MARK: 그룹 소개 글
                GetStringGroupInfo(userInput: $groupCaption, checkStatus: $groupIntroValidate, focusedValue: _focusedField, focusType: .groupCaption, getTitle: "그룹 소개를 입력해주세요", getMaxString: 50)
                    .focused($focusedField, equals: .groupCaption)
                
                // MARK: 목표 금액
                GetIntegerGroupInfo(userInput: $input.groupGoalValue, checkStatus: $groupGoalValidate, focusedValue: _focusedField ,getTitle: "목표 금액을 입력해주세요", getMaxString: 9, symbolName: "Pencil", focusType: .groupGoal)
                    .focused($focusedField, equals: .groupGoal)
                
                // MARK: 최대 인원
                HStack(spacing: 23) {
                    Text("최대 인원")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                    Button {
                        isMaxNumPickerPresented = true
                        focusedField = nil
                    } label: {
                        HStack {
                            Text(groupMax.count == 0 ? "최대 인원을 선택해주세요" : groupMax)
                                .modifier(Body1Bold())
                                .foregroundColor(groupMax.isEmpty ? .gray.opacity(0.4) : .black)
                                .onChange(of: groupMax) { newValue in
                                    if newValue.isEmpty {
                                        groupMaxValidate = false
                                    } else {
                                        groupMaxValidate = true
                                    }
                                }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16))
                                .foregroundColor(Color("Gray2"))
                        }
                    }
                }
                .sheet(isPresented: $isMaxNumPickerPresented) {
                    PickerModalView(selectedValue: $groupMax)
                        .presentationDetents([.fraction(0.3)])
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(isMaxNumPickerPresented ? Color("Main") : Color("Gray4"))
                
                // MARK: 비공개 설정
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
                
                // MARK: 방 비밀번호
                if isSecretRoom {
                    HStack {
                        Text("비밀번호")
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                            .frame(width: 100, alignment: .leading)
                        
                        Spacer()
                        
                        CodeFieldView(inputCodeArray: $inputCodeArray)
                    }
                }
            }
            
            Spacer()
            
            // add group Btn
            Button {
                groupCode = inputCodeArray.joined()
                createAlert = true
            } label: {
                GroupCreateBtn(validation: (groupNameValidate && groupIntroValidate &&
                                            groupMaxValidate && groupGoalValidate &&
                                            (CodeFieldView(inputCodeArray: $inputCodeArray).checkBtnStatus() == isSecretRoom)), text: "그룹 생성하기")
            }
            .disabled(!(groupNameValidate && groupIntroValidate && groupMaxValidate && groupGoalValidate &&
                        (CodeFieldView(inputCodeArray: $inputCodeArray).checkBtnStatus() == isSecretRoom)))
            .padding(.bottom, 60)
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 78)
        .onTapGesture { // 키보드밖 화면 터치시 키보드 사라짐
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            focusedField = .groupName
        }
        .alert(isPresented: $createAlert) {
            Alert(
                title: Text("그룹이 생성되었어요"),
                message: Text("그룹 초대하기를 통해 친구를 초대할 수 있어요."),
                dismissButton: .cancel(Text("확인")) {
                    firebaseManager.addGroupData(group_name: groupName, group_introduce: groupCaption, group_goal: Int(input.groupGoalValue) ?? 0, group_cur: 1, group_max: Int(groupMax) ?? 0, lock_status: isSecretRoom, group_pw: groupCode, makeTime: Date())
                }
            )
        }
    }
}


// get String value for group info
struct GetStringGroupInfo: View {
    @Binding var userInput: String
    @Binding var checkStatus: Bool
    @FocusState var focusedValue: CodeField?
    
    var focusType: CodeField
    var getTitle: String
    var getMaxString: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 23) {
                Text(getTitle.prefix(5))
                    .modifier(Body2())
                    .foregroundColor(Color("Gray1"))
                
                TextField(getTitle, text: $userInput, prompt: Text(getTitle).foregroundColor(.gray.opacity(0.4)))
                    .submitLabel(.done) // 제출 버튼
                    .autocapitalization(.none)  // 자동 대문자 off
                    .disableAutocorrection(true)   // 자동 완성 off
                    .modifier(Body1Bold())
                    .foregroundColor(.black)
                    .onChange(of: userInput) { newValue in
                        if newValue.isEmpty {
                            checkStatus = false
                        } else {
                            checkStatus = true
                            userInput = String(newValue.prefix(getMaxString))
                        }
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
                .overlay(focusedValue == focusType ? Color("Main") : Color("Gray4"))
        }
    }
}

// get Integer value for group info
struct GetIntegerGroupInfo: View {
    @State private var dividerSelect: Bool = false
    @State var keyboardIsPresented: Bool = false
    
    @Binding var userInput: String
    @Binding var checkStatus: Bool
    @FocusState var focusedValue: CodeField?
    
    var getTitle: String
    var getMaxString: Int
    var symbolName: String
    var focusType: CodeField
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 23) {
                Text(getTitle.prefix(5))
                    .modifier(Body2())
                    .foregroundColor(Color("Gray1"))
                
                TextField(getTitle, text: $userInput, prompt: Text(getTitle).foregroundColor(.gray.opacity(0.4)))
                    .modifier(Body1Bold())
                    .keyboardType(.numberPad)
                    .foregroundColor(.black)
                    .onChange(of: userInput) { newValue in
                        if newValue.isEmpty {
                            checkStatus = false
                        } else {
                            checkStatus = true
                            userInput = String(newValue.prefix(getMaxString))
                        }
                    }
                
                Spacer()
                
                Image(symbolName)
                    .font(.system(size: 16))
                    .foregroundColor(Color("Gray2"))
                    .onTapGesture {
                        focusedValue = focusType
                    }
            }
            .padding(.bottom, 22)
            
            Divider()
                .frame(height: 1)
                .overlay(focusedValue == focusType ? Color("Main") : Color("Gray4"))
        }
    }
}

// Picker Modal View for 최대인원
struct PickerModalView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedValue: String
    
    let groupMaxArray: [String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedValue, label: Text("")) {
                    Text("최대 인원을 선택해주세요").tag("")
                        .modifier(Body1Bold())
                    ForEach(groupMaxArray, id: \.self) { num in
                        Text(num)
                            .modifier(Num2())
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


// 그룹 생성 버튼
struct GroupCreateBtn: View {
    var validation: Bool
    var text: String
    
    var body: some View {
        Text(text)
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


// 키보드밖 화면 터치시 키보드 사라짐
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
    }
}
