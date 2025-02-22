//
//  LoginButton.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/19.
//

import SwiftUI

struct LoginButton: View {
    var body: some View {
        HStack {
            Image(systemName: "apple.logo")
                .frame(width: 24)
                .foregroundColor(.white)
            Text("Apple로 계속하기")
                .modifier(BtnBold())
                .foregroundColor(.white)
        }
        .frame(height: 52)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .cornerRadius(12)
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
