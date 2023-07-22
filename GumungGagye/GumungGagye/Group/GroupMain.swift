//
//  GroupMain.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/09.
//

import SwiftUI

// Group Main View
struct GroupMain: View {
    
    var body: some View {
        // TODO: User가 가입된 그룹이 없다면 groupnotexistview 이동 아니면 groupviewinside
        ZStack {
            Color("background").ignoresSafeArea()
            
            // user가 그룹을 보유하고 있다면 GroupView 내부를 보여준다.
            // TODO: 해당 그룹 아이디를 찾아 해당 그룹 정보를 띄어준다
             
        }
    }
}

struct GroupMain_Previews: PreviewProvider {
    static var previews: some View {
        GroupMain()
    }
}
