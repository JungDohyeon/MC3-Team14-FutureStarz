//
//  PreStart.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/15.
//

import SwiftUI

struct PreStart: View {
    
    @AppStorage("app_setting") var app_setting: Bool = false
    let inputdata = InputUserData.shared
    
    func insertFirestore() async throws {
        try await UserManager.shared.createNewUser()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("반가워요!\n회원가입이 완료되었어요")
                    .modifier(H1Bold())
                Spacer()
            }
            .padding(.top, 146)
            Spacer()
            
//            Image(uiImage: inputdata.profile_image!)
//                .resizable()
//                .scaledToFit()
            
            OnboardingNextButton(isAbled: .constant(true))
                .onTapGesture {
                    Task {
                        do {
                            try await insertFirestore()
                            app_setting = true
                        }catch {
                            print(error)
                            
                        }
                    }
                    
                    
                }
            
//            NavigationLink(destination: LoginComplete()) {
////                OnboardingNextButton(isAbled: .constant(true))
//                app_setting = true
//            }
            .padding(.bottom, 71)
        }
        .padding(.horizontal, 20)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

struct PreStart_Previews: PreviewProvider {
    static var previews: some View {
        PreStart()
    }
}
