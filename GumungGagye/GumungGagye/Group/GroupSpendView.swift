//
//  GroupSpendView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/10.
//

import SwiftUI

// 그룹 지출 내역 뷰
struct GroupSpendView: View {
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 92)
                    .padding(.top, 24)
                    .padding(.bottom, 36)
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 40) {
                        ForEach(1..<5) { _ in
                            GroupUserSpendView()
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
        }
    }
}



struct GroupSpendView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSpendView()
    }
}
