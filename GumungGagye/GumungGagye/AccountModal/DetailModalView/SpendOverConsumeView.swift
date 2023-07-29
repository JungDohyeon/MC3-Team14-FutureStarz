//
//  SpendOverConsumeView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/29.
//

import SwiftUI

struct SpendOverConsumeView: View {
    // MARK: - PROPERTY
    
    @Binding var spend_overConsume: Bool
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            Button {
                spend_overConsume.toggle()
            } label: {
                HStack {
                    Text("이번 지출 내역을 그룹원에게 공개할게요.")
                        .modifier(Body1())
                        .foregroundColor(Color("Black"))
                    
                    Spacer()
                    
                    Image(systemName: spend_overConsume ? "checkmark.square.fill" : "checkmark.square")
                        .font(.system(size: 24))
                        .foregroundColor(spend_overConsume ? Color("Main") : Color("Gray2"))
                }
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 30)
    }
}

struct SpendOverConsumeView_Previews: PreviewProvider {
    static var previews: some View {
        SpendOverConsumeView(spend_overConsume: .constant(false))
    }
}
