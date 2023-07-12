//
//  SettingView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/12.
//

import SwiftUI

struct SettingView: View {
    @State private var logoutShowing = false
    @State private var cancelShowing = false
    
    var body: some View {
        VStack(spacing: 36.0) {
            VStack(alignment: .leading, spacing: 36.0) {
                Text("설정")
                    .modifier(H1Bold())

                // - MARK: - 정보
                VStack(alignment: .leading, spacing: 20.0) {
                    Text("파도")
                        .modifier(H2SemiBold())
                    HStack {
                        Image(systemName: "apple.logo")
                            .foregroundColor(Color("Gray2"))
                        Text("이메일")
                            .modifier(Body2())
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
                    SettingRowView(label: "목표 지출 금액", value: "300,000원")
                    SettingRowView(label: "내역 확인 앱", value: "토스")
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
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("Gray2"))
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
