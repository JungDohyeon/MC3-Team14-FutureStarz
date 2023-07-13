//
//  Breakdown.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

struct Breakdown: View {
    var body: some View {
        HStack {
            CategoryIcon(size: .small, color: Color("Food")) // Color 데이터로 바꾸기
            Text("내용")
                .modifier(Body1())
            Spacer()
            Text("-10,000원")
                .modifier(Num3Bold())
        }
    }
}

struct Breakdown_Previews: PreviewProvider {
    static var previews: some View {
        Breakdown()
    }
}
