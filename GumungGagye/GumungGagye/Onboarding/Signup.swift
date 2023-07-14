//
//  Signup.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct Signup: View {
    // MARK: - PROPERTY
    
//    @State private var showSignInView: Bool = false
    
    // MARK: - BODY
    var body: some View {
        
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 0){
                        Text("App Name과 함께\n과소비를 줄여볼까요?")
                            .modifier(H1Bold())
                            .padding(.top, 146)
                            .padding(.bottom, 24)
                        Text("로그인하고 사람들과 소비내역을 공유해봐요!")
                            .modifier(Body1())
                    }
                    Spacer()
                }
                Spacer()
                
                Image("AppleSign")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 24)
                    
                Text("회원가입 시, 이용약관 및 개인정보처리방침에 동의한 것으로 간주합니다.")
                    .modifier(Cap2())
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 95)
            } //: VSTACK
            .ignoresSafeArea()
        .padding(.horizontal, 20)
        
    }
    
}



struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
    }
}
