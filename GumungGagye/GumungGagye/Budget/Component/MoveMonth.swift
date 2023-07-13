//
//  MoveMonth.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

enum FontSize {
    case Big
    case Small
    case XSmall
}

struct MoveMonth: View {

    var month: String
    var size: FontSize

    var body: some View {

        HStack {
            Button(action: {

            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("Gray1"))
            })
            fontView(for: size)
            Button(action: {

            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("Gray1"))
            })
        }

    }
    
    @ViewBuilder
    private func fontView(for size: FontSize) -> some View {
        switch size {
        case .Big:
            Text(month)
                .modifier(H1Bold())
        case .Small:
            Text(month)
                .modifier(H2SemiBold())
        case .XSmall:
            Text(month)
                .modifier(Body1())
        }
    }
}

struct MoveMonth_Previews: PreviewProvider {
    static var previews: some View {
        MoveMonth(month: "7월", size: .Big)
    }
}
