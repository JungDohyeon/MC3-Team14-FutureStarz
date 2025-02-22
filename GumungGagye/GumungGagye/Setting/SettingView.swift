//
//  SettingView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage


struct SettingView: View {
    @AppStorage("app_setting") var app_setting: Bool = false
    @State private var logoutShowing = false
    @State private var cancelShowing = false
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State var budgetSetting: Bool = false
    @State var bankCardPaySetting: Bool = false
    
    @StateObject var inputdata = InputUserData.shared
    
    var body: some View {
        VStack(spacing: 36.0) {
            VStack(alignment: .leading, spacing: 36.0) {
                Text("설정")
                    .modifier(H1Bold())
                
                // - MARK: - 정보
                HStack(spacing: 0) {
                    Circle()
                        .foregroundColor(Color("Gray2"))
                        .frame(width: 74, height: 74)
                        .overlay {
                            if let image = inputdata.profile_image {
                                //
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                            } else {
                                Image("SeletingPictureIcon")
                                    .resizable()
                                    .frame(width: 74, height: 74)
                                    .shadow(color: Color(red: 0.31, green: 0.32, blue: 0.63).opacity(0.2), radius: 5, x: 0, y: 2)
                                
                            }
                        }
                        .padding(.trailing, 18)
                    
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(inputdata.nickname ?? "")
                            .modifier(H2SemiBold())
                            .padding(.bottom, 8)
                        HStack(alignment: .center, spacing: 4.0) {
                            Image(systemName: "apple.logo")
                                .foregroundColor(Color("Gray2"))
                                .font(.system(size: 16))
                            Text(inputdata.email ?? "")
                                .modifier(Body2())
                        }
                    }
                }
            }
            .foregroundColor(Color("Black"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            DividerView()
            
            VStack(spacing: 36.0) {
                // - MARK: - 설정 변경
                
                VStack(spacing: 0.0) {
                    SettingRowView2(label: "목표 지출 금액", value: "\(inputdata.goal ?? 0)원", budgetSetting: $budgetSetting, bankCardPaySetting: $bankCardPaySetting, selectSetting: 1)
                    SettingRowView2(label: "내역 확인 앱", value: "\(inputdata.bankcardpay_info[0] ?? "선택안함")", budgetSetting: $budgetSetting, bankCardPaySetting: $bankCardPaySetting, selectSetting: 2)
                    SettingRowView(label: "푸시 알림", value: "toggle")
                }
                
                Divider()
                    .background(Color("Gray4"))
                
                // - MARK: - 로그아웃 & 탈퇴
                
                VStack(spacing: 0.0) {
                    Button {
                        logoutShowing = true
                        
                    } label: {
                        SettingRowView(label: "로그아웃", value: "")
                    }
                    .alert(isPresented: $logoutShowing) {
                        let firstButton = Alert.Button.default(Text("로그아웃")) {
                            // 로그아웃 기능
                            Task {
                                do {
                                    try viewModel.signOut()
                                    showSignInView = true
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        let secondButton = Alert.Button.cancel(Text("취소")) {
                            print("secondary button pressed")
                        }
                        return Alert(title: Text("로그아웃 하시겠어요?"),
                                     primaryButton: firstButton, secondaryButton: secondButton)
                    }
                    Button {
                        cancelShowing = true
                    } label: {
                        SettingRowView(label: "앱 탈퇴", value: "")
                    }
                    .alert(isPresented: $cancelShowing) {
                        let firstButton = Alert.Button.default(Text("탈퇴")) {
                            // 로그아웃 탈퇴기능
                            Task {
                                do {
                                    try await viewModel.deleteAccount()
                                    app_setting = false
                                    showSignInView = true
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        let secondButton = Alert.Button.cancel(Text("취소")) {
                            print("secondary button pressed")
                        }
                        return Alert(title: Text("앱을 탈퇴하시겠어요?"),
                                     message: Text("앱을 탈퇴하면 모든 정보가 삭제되며 복구가 불가능해요"),
                                     primaryButton: firstButton, secondaryButton: secondButton)
                        
                    }
                }
                
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 24.0)
        .foregroundColor(Color("Black"))
        .background(Color("background"))
        .sheet(isPresented: $budgetSetting) {
            SelectingBudgetView(budget: "\(inputdata.goal ?? 0)", budgetSetting: $budgetSetting)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $bankCardPaySetting) {
            SelectingBankView(selectBankCardPay: inputdata.bankcardpay ?? 0, selectBankCardPayIndex: inputdata.bankcardpay_index ?? 0, bankCardPaySetting: $bankCardPaySetting)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            print("\(inputdata.goal)")
        }
       
    }
}

struct SettingRowView: View {
    var label: String
    var value: String
    
    @State private var pushToggle = true
    
    var body: some View {
        HStack {
            Text("\(label)")
                .modifier(Body1())
                .foregroundColor(Color("Black"))
            Spacer()
            
            if(self.value == "toggle"){
                Toggle("", isOn: $pushToggle)
                    .toggleStyle(SwitchToggleStyle(tint: Color("Main")))
                if pushToggle {
                    // 푸시 알림 On 기능
                } else {
                    // 푸시 알림 Off 기능
                }
            }
            else{
                HStack(spacing: 8.0) {
                    Text("\(value)")
                        .modifier(Num3())
                        .foregroundColor(Color("Black"))
                    Image("Chevron.right.light.gray2")
                        .foregroundColor(Color("Gray2"))
                        .font(.system(size: 16))
                }
            }
        }
        .background(Color("background"))
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
    }
}

struct SettingRowView2: View {
    var label: String
    var value: String
    
    @State private var pushToggle = true
    @Binding var budgetSetting: Bool
    @Binding var bankCardPaySetting: Bool
    @State var selectSetting: Int
    var body: some View {
        HStack {
            Text("\(label)")
                .modifier(Body1())
            Spacer()
            
            HStack(spacing: 8.0) {
                Text("\(value)")
                    .modifier(Num3())
                Image(systemName: "chevron.right")
            }
            .onTapGesture {
                if selectSetting == 1 {
                    budgetSetting = true
                    print("budget")
                } else if selectSetting == 2 {
                    bankCardPaySetting = true
                    print("bank")
                }
            }
        }
        .background(Color("background"))
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showSignInView: .constant(true))
    }
}
