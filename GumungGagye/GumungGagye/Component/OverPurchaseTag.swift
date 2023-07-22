//
//  OverPurchaseTag.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/18.
//

import SwiftUI

struct OverPurchaseTag: View {
    var isOverPurchase: Bool
    
    var body: some View {
        if isOverPurchase {
            Text("과소비")
                .modifier(Cap2())
                .foregroundColor(Color("OverPurchasing"))
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(
                    Rectangle()
                        .foregroundColor(Color("OverPurchasingLight"))
                        .cornerRadius(7)
                )
        } else {
            EmptyView()
        }
        
    }
}


struct OverPurchaseTag_Previews: PreviewProvider {
    static var previews: some View {
        OverPurchaseTag(isOverPurchase: true)
    }
}
