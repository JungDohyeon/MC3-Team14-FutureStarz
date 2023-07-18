//
//  RootView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI

struct RootView: View {
    @AppStorage("app_setting") var app_setting: Bool = false
    @State var showSignInView: Bool = false
    
    var body: some View {
        ZStack{
            if !showSignInView {
                if !app_setting{
                    NavigationStack {
                        //                    SettingsView(showSignInView: $showSignInView)
                        SelectingName()
                    }
                } else {
                    MainView(showSignInView: $showSignInView)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
