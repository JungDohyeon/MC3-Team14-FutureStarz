//
//  GroupViewInside.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI

struct GroupViewInside: View {
    @State private var isGroupInfo: Bool = false
    var options = ["그룹 초대하기", "그룹 나가기", "그룹 둘러보기"]
    
    var body: some View {
        ZStack{
            Color("background").ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 22) {
                    Button {
                        isGroupInfo = false
                    } label: {
                        Text("지출 내역")
                            .foregroundColor(isGroupInfo ? Color("Gray2") : Color("Black"))
                    }
                    
                    Button {
                        isGroupInfo = true
                    } label: {
                        Text("그룹 정보")
                            .foregroundColor(isGroupInfo ? Color("Black") : Color("Gray2"))
                    }
                    
                    Spacer()
                    
                    Menu {
                        ForEach(options, id: \.self) { option in
                            Button {
                                
                            } label: {
                                Text(option)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                    }
                }
                .modifier(H1Bold())
                .padding(.top, 78)
                .padding(.bottom, 24)
                
                if !isGroupInfo {
                    GroupSpendView()
                    Spacer()
                } else {
                    VStack {
                        GroupInfoView()
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}


struct GroupViewInside_Previews: PreviewProvider {
    static var previews: some View {
        GroupViewInside()
    }
}
