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
    @Binding var spendOverconsume: Bool
    @Binding var spendOpen: Bool
    
    @Binding var size: IconSize
    @Binding var accountType: Int
    @Binding var categoryIndex: Int

    @ObservedObject var categoryInfo = CategoryInfo.shared

    
    var body: some View {
        HStack {
            CategoryIcon(size: $size, accountType: $accountType, categoryIndex: $categoryIndex)
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
