//
//  SecretTag.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/18.
//

import SwiftUI

struct SecretTag: View {
    var isSecret: Bool
    
    var body: some View {
        if isSecret {
            Text("비공개")
                .modifier(Cap2())
                .foregroundColor(Color("Gray1"))
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(
                    Rectangle()
                        .foregroundColor(Color("Gray3"))
                        .cornerRadius(7)
                )
        } else {
            EmptyView()
        }
        
    }
}

struct SecretTag_Previews: PreviewProvider {
    static var previews: some View {
        SecretTag(isSecret: true)
    }
}
