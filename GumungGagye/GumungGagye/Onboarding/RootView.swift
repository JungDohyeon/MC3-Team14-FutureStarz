//
//  RootView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


struct RootView: View {
    @AppStorage("app_setting") var app_setting: Bool = false
    @State var showSignInView: Bool = false
    let inputdata = InputUserData.shared
    
    
    
    var body: some View {
        ZStack{
            if !showSignInView {
                if !app_setting{
                    NavigationStack {
                        // SettingsView(showSignInView: $showSignInView)
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

                        try await getUser(userId: authUser!.uid)
                        
                        if let image_url = inputdata.profile_image_url {
                            inputdata.profile_image = try await fetchImage(url: URL(string: image_url)!)
                        }
                        
//                        inputdata.profile_image = try await fetchImage(url: URL(string: inputdata.profile_image_url!)!)
                        app_setting = deleteapp
                    }
                    self.showSignInView = authUser == nil
                } catch {
                    
                }
            }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
    }
    
    
    func fetchImage(url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statusCode) else { throw NSError(domain: "fetch error", code: 1004) }
        guard let image = UIImage(data: data) else {return UIImage(systemName: "person.fill")!}
        
        return image
    }
    
    func getUser(userId: String) async throws {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        inputdata.profile_image_url = data["profile_image_url"] as? String
        inputdata.bankcardpay = data["bankcardpay"] as? Int
        inputdata.bankcardpay_index = data["bankcardpay_index"] as? Int
        inputdata.email = data["email"] as? String
        inputdata.goal = data["goal"] as? Int
        inputdata.group_id = data["group_id"] as? String
        inputdata.nickname = data["nickname"] as? String
        inputdata.bankcardpay_info = (data["bankcardpay_info"] as? [String])!
    }
    
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
