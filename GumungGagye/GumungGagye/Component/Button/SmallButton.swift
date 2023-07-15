//
//  SmallButton.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

struct SmallButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .modifier(Cap1Bold())
                .foregroundColor(Color("Main"))
                .padding(.vertical, 7)
                .padding(.horizontal, 12)
        }
        .background(Color("Light"))
        .cornerRadius(5)

    }
}

struct SmallButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallButton(text: "은행열기"){
            print("")
        }
    }
}
