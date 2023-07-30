//
//  MainView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/12.
//

import SwiftUI

enum Tab {
    case main
    case analysis
    case group
    case setting
}

struct MainView: View {
    @StateObject private var firebaseManager = FirebaseController.shared
    @StateObject var user = InputUserData.shared
    
    @Binding var showSignInView: Bool
    @State private var tabSelection: Tab = .main
    @State private var inviteSubmit: Bool = false
    @State private var inviteGroupID: String? = nil
    @State private var inviteGroupStatus: AlertType = .otherCase
    @State private var groupData: GroupData? = nil
    
    var body: some View {
        TabView(selection: $tabSelection) {
            MainBudgetView()
                .tabItem {
                    VStack {
                        Image(tabSelection == .main ? "BudgetIconAbled" : "BudgetIconDisabled")
                        Text("가계부")
                    }
                }
                .tag(Tab.main)
                .onOpenURL { url in
                    tabSelection = .main
                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                        return
                    }
                    
                    print(components)
                    
                    if components.scheme == "ssoap", components.host == "receiver", let groupID = components.queryItems?.first(where: { $0.name == "groupID" })?.value {
                        print("GROUP ID : \(groupID)")
                        inviteGroupID = groupID
                        
                        Task {
                            groupData = try await firebaseManager.fetchGroupData(groupId: groupID)
                            if let groupData = groupData {
                                if groupData.group_cur >= groupData.group_max {
                                    inviteGroupStatus = .groupMax
                                } else if user.group_id != "" {
                                    inviteGroupStatus = .alreadyJoined
                                } else {
                                    inviteGroupStatus = .otherCase
                                }
                            } else {
                                print("Fetch Group Error")
                            }
                        }

                        inviteSubmit = true
                    }
                }
                .alert(isPresented: $inviteSubmit) {
                    inviteGroupAlert(type: inviteGroupStatus, groupData: inviteGroupID!)
                }
            
            AnalysisView()
                .tabItem {
                    VStack {
                        Image(tabSelection == .analysis ? "AnalysisIconAbled" : "AnalysisIconDisabled")
                        Text("분석")
                    }
                }
                .tag(Tab.analysis)
            
            GroupMain()
                .tabItem {
                    VStack {
                        Image(tabSelection == .group ? "GroupIconAbled" : "GroupIconDisabled")
                        Text("그룹")
                    }
                }
                .tag(Tab.group)
            
            SettingView(showSignInView: $showSignInView)
                .tabItem {
                    VStack {
                        Image(tabSelection == .setting ? "SettingIconAbled" : "SettingIconDisabled")
                        Text("설정")
                    }
                }
                .tag(Tab.setting)
        }
        .accentColor(Color("Main"))
        // 항상 탭뷰 배경 보이게
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func inviteGroupAlert(type: AlertType, groupData: String) -> Alert {
        switch type {
        case .alreadyJoined:
            return Alert(
                title: Text("이미 그룹에 가입되어 있어요"),
                message: Text("현재 가입된 그룹을 나간 후에 새로운 그룹을 가입할 수 있어요."),
                dismissButton: .cancel(Text("확인"))
            )
        case .groupMax:
            return Alert(
                title: Text("해당 그룹에 가입할 수 없어요"),
                message: Text("해당 그룹은 인원이\n모두 차서 들어갈 수 없어요."),
                dismissButton: .cancel(Text("확인"))
            )
        case .otherCase:
            return Alert(
                title: Text("그룹에 가입할까요?"),
                message: Text("가입하면 기록한 지출 내역이 그룹 멤버와 공유돼요."),
                primaryButton: .cancel(Text("취소")),
                secondaryButton: .default(Text("가입")) {
                    firebaseManager.incrementGroupCur(groupID: groupData)
                }
            )
        }
    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showSignInView: .constant(true))
    }
}
