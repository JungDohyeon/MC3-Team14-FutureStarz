//
//  CategoryIcon.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

enum IconSize: CGFloat {
    case small = 48 // Category/IconSmall
    case large = 80 // Category/IconBig
}

struct CategoryIcon: View {
    
    let size: IconSize
    let color: Color
    
    var body: some View {
        Circle()
            .foregroundColor(color)
            .frame(width: size.rawValue, height: size.rawValue)
    }
}

struct CategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
        CategoryIcon(size: .small, color: Color("Food"))
    }
}

