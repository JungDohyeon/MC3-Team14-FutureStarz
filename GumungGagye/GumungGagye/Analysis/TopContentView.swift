//
//  TopContentView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/10.
//

import SwiftUI

struct TopContentView: View {
    var body: some View {
        HStack {
            Text("TOP1")
                .modifier(Body2())
                .frame(width: 60.0, alignment: .leading)
                .foregroundColor(Color("Gray1"))
            Text("내용")
                .modifier(Body1Bold())
            Spacer()
            Text("500,000원")
                .modifier(Num3())
        }
    }
}

struct TopContentView_Previews: PreviewProvider {
    static var previews: some View {
        TopContentView()
    }
}
