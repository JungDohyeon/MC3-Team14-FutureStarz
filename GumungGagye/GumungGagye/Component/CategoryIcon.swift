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
    
    @Binding var size: IconSize
    @Binding var accountType: Int
    @Binding var categoryIndex: Int

    @ObservedObject var categoryInfo = CategoryInfo.shared
    
    var body: some View {
        if let categoryName = categoryInfo.category_info[accountType][categoryIndex]?[1] {
            Image("\(categoryName)_\(size.rawValue)")
        }
    }
}

struct CategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
        CategoryIcon(size: .constant(.small), accountType: .constant(0), categoryIndex: .constant(1))
                .previewLayout(.sizeThatFits)
                .padding()
//            CategoryIcon(size: .large, accountType: 1, categoryIndex: 2)
//                .previewLayout(.sizeThatFits)
//                .padding()
//        }
    }
}

