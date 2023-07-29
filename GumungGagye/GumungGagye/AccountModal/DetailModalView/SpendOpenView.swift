//
//  SpendOpenView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/29.
//

import SwiftUI

struct SpendOpenView: View {
    // MARK: - PROPERTY
    
    @Binding var spend_open: Bool
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            Button {
                spend_open.toggle()
            } label: {
                HStack {
                    Text("이번에 과소비를 했어요.")
                        .modifier(Body1())
                        .foregroundColor(Color("Black"))
                    
                    Spacer()
                    
                    Image(systemName: spend_open ? "checkmark.square.fill" : "checkmark.square")
                        .font(.system(size: 24))
                        .foregroundColor(spend_open ? Color("Main") : Color("Gray2"))
                }
            }
            .padding(.top, 18)
            .padding(.horizontal, 30)
        }
    }
}

struct SpendOpenView_Previews: PreviewProvider {
    static var previews: some View {
        SpendOpenView(spend_open: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}