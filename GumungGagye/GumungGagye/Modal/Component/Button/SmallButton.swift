//
//  SmallButton.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

struct SmallButton: View {
    var text: String
    
    var body: some View {
        Button {
            
        } label: {
            Text(text)
                .modifier(Cap1())
                .foregroundColor(Color("Main"))
                .padding(.vertical, 7)
                .padding(.horizontal, 12)
        }
        .background(Color("Light30"))
        .cornerRadius(5)

    }
}

struct SmallButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallButton(text: "은행열기")
    }
}
