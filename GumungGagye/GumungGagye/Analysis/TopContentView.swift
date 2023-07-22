//
//  TopContentView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/10.
//

import SwiftUI

struct TopContentView: View {
    
    public let rank: Int
    public let content: String
    public let money: Int
    
    var body: some View {
        
        HStack {
            HStack(spacing: 2) {
                Text("TOP")
                Text("\(rank)")
            }
            .modifier(Body2())
            .frame(width: 60.0, alignment: .leading)
            .foregroundColor(Color("Gray1"))
            
            Text(content)
                .modifier(Body1Bold())
            
            Spacer()
            
            Text("\(money)원")
            .modifier(Num3())
        }
    }
}

struct TopContentView_Previews: PreviewProvider {
    static var previews: some View {
        TopContentView(rank: 1, content: "치킨", money: 5000)
    }
}
