//
//  CategoryIcon.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

enum IconSize: String {
    case small = "S" // Category/IconSmall
    case large = "L" // Category/IconBig
}

struct CategoryIcon: View {
    
    let size: IconSize
    let category: String
    
    var body: some View {
        Image("\(category)_\(size.rawValue)")
    }
}

struct CategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
        CategoryIcon(size: .small, category: "Food")
    }
}

