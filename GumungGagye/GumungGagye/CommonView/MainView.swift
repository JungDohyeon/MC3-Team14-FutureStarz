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
    
    @Binding var showSignInView: Bool
    @State private var tabSelection: Tab = .main
    
    var body: some View {
        TabView{
            MainBudgetView()
                .tabItem {
                    Label("가계부", systemImage: "list.clipboard.fill")
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
                        
                    }
                }
            
            AnalysisView()
                .tabItem {
                    Label("분석", systemImage: "chart.pie.fill")
                }
                .tag(Tab.analysis)
            
            GroupMain()
                .tabItem {
                    Label("그룹", systemImage: "person")
                }
                .tag(Tab.group)
            
            SettingView(showSignInView: $showSignInView)
                .tabItem {
                    Label("설정", systemImage: "gear")
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
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showSignInView: .constant(true))
    }
}
