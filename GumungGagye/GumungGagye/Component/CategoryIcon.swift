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
    let accountType: Int
    let categoryIndex: Int
   
    
    @ObservedObject var categoryInfo = CategoryInfo.shared
    
    var body: some View {
        if let categoryName = categoryInfo.category_info[accountType][categoryIndex]?[1] {
            Image("\(categoryName)_\(size.rawValue)")
        } else {
            // 이미지가 없을 때의 대체 처리 (기본 이미지 등)
            Image("default_image") // 기본 이미지 파일명을 적어주세요.
        }
    }
}

struct CategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
            CategoryIcon(size: .small, accountType: 0, categoryIndex: 1)
                .previewLayout(.sizeThatFits)
                .padding()
//            CategoryIcon(size: .large, accountType: 1, categoryIndex: 2)
//                .previewLayout(.sizeThatFits)
//                .padding()
//        }
    }
}

