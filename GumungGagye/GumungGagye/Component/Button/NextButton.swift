//
//  NextButton.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/11.
//

import SwiftUI

struct Nextbutton: View {
    var title: String
    var isAbled: Bool
    var action: () -> Void
    
    init(
        title: String,
        isAbled: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isAbled = isAbled
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                Text(title)
                    .modifier(BtnBold())
                
                Spacer()
            }
            .frame(height: 52)
            .background(isAbled ? Color("Main") : Color("Gray3"))
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(!isAbled)
    }
}

struct Nextbutton_Previews: PreviewProvider {
    static var previews: some View {
        Nextbutton(title: "다음", isAbled: true) {
            print("")
        }
    }
}
