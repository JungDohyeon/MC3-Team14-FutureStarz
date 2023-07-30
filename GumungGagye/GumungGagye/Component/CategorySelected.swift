//
//  CategorySelected.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/30.
//

import SwiftUI

struct CategorySelected: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12) // Use RoundedRectangle instead of Rectangle
            .foregroundColor(Color("Light"))
            .frame(width: 72, height: 90)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("Main"), lineWidth: 2) // Add stroke to the RoundedRectangle
            )
    }
}

struct CategorySelected_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelected()
    }
}
