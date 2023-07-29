//
//  Breakdown.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

struct Breakdown: View {
    
    @Binding var accountBill: Int
    @Binding var accountContent: String
    @Binding var accountCategory: Int
    @Binding var spendOverconsume: Bool
    @Binding var spendOpen: Bool
    
    var body: some View {
        HStack {
//            CategoryIcon(size: .small, category: "Food")
            VStack(alignment: .leading, spacing: 2) {
//                Text("\(payment)")
//                    .modifier(Num3Bold())
//                Text("\(content)")
//                    .modifier(Cap2())
            }
            Spacer()
            HStack {
                OverPurchaseTag(isOverPurchase: true)
                OpenTag(spendOpen: true)
            }
        }
    }
}
//
//struct Breakdown_Previews: PreviewProvider {
//    static var previews: some View {
//        Breakdown(payment: 1000000, content: "MC3 회식")
//    }
//}
