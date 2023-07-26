//
//  Breakdown.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

struct Breakdown: View {
    
    public let payment: Int
    
    var body: some View {
        HStack {
            CategoryIcon(size: .small, category: "Food")
            VStack(alignment: .leading, spacing: 2) {
                Text("\(payment)")
                    .modifier(Num3Bold())
                Text("내용")
                    .modifier(Cap2())
            }
            Spacer()
            HStack {
                OverPurchaseTag(isOverPurchase: true)
                SecretTag(isSecret: true)
                
            }
        }
    }
}

struct Breakdown_Previews: PreviewProvider {
    static var previews: some View {
        Breakdown(payment: 1000000)
    }
}
