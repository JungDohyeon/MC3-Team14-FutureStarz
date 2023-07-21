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
            Text("dd")
                .foregroundColor(.white)
        }
        .frame(height: 52)
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
