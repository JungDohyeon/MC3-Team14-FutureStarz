//
//  MainView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/12.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            MainBudgetView()
            .tabItem {
                Label("가계부", systemImage: "list.clipboard.fill")
            }
            AnalysisView()
            .tabItem {
                Label("분석", systemImage: "chart.pie.fill")
            }
                
            GroupNotExistView()
            .tabItem {
                Label("그룹", systemImage: "person")
            }
                
            SettingView()
            .tabItem {
                Label("설정", systemImage: "gear")
            }
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
        MainView()
    }
}
