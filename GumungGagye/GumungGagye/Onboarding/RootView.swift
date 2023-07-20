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
            
            
            Task {
                do {
                    let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                    if authUser != nil {
                        let deleteapp = try await UserManager.shared.getUser(userId: authUser!.uid)
                        app_setting = deleteapp
                    }
                    self.showSignInView = authUser == nil
                } catch {
                    
                }
                
                //                UserManager.shared.ge
            }
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
