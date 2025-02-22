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
    var accountType: Int  // 0
    var categoryIndex: Int // 4

    @ObservedObject var categoryInfo = CategoryInfo.shared
    
    var body: some View {
        if let categoryName = categoryInfo.category_info[accountType][categoryIndex] {
            let imageName = categoryName[1]
            Image("\(imageName)_\(size.rawValue)")
        }
    }
}

struct CategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
        CategoryIcon(size: .constant(.small), accountType: 0, categoryIndex: 1)
                .previewLayout(.sizeThatFits)
                .padding()
//            CategoryIcon(size: .large, accountType: 1, categoryIndex: 2)
//                .previewLayout(.sizeThatFits)
//                .padding()
//        }
    }
}

