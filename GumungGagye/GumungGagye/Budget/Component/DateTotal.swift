//
//  DateTotal.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

struct DateTotal: View {
    var body: some View {
        
        HStack {
            Text("4일 화요일")
                .modifier(Body2())// '일', '요일' 고정
            Spacer()
            Text("+20,000원") // +,'원' 고정, 숫자만 바꿀 것
                .foregroundColor(Color("Main"))
                .modifier(Num4())
            Text("-10,000원")
                .modifier(Num4())// -,'원' 고정, 숫자만 바꿀 것
        }
    }
}

struct DateTotal_Previews: PreviewProvider {
    static var previews: some View {
        DateTotal()
    }
}
