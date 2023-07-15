//
//  AuthenticationView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices




@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        
        
    }
    
}


struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
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
                .onTapGesture {
                    Task {
                        do {
                            try await viewModel.signInApple()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
                
            Text("회원가입 시, 이용약관 및 개인정보처리방침에 동의한 것으로 간주합니다.")
                .modifier(Cap2())
                .multilineTextAlignment(.center)
                .padding(.bottom, 95)
        } //: VSTACK
        .ignoresSafeArea()
    .padding(.horizontal, 20)
        
     
        
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
