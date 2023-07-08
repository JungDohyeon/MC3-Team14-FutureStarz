//
//  AppFont.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/08.
//

import SwiftUI

struct H1Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Bold", size: 24))
    }
}

struct H2SemiBold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-SemiBold", size: 20))
    }
}

struct Body1Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-SemiBold", size: 16))
    }
}

struct Body2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Regular", size: 14))
    }
}

struct Body2Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-SemiBold", size: 14))
    }
}

struct Cap1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Regular", size: 12))
    }
}

struct Cap1Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-SemiBold", size: 12))
    }
}

struct Cap2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Regular", size: 10))
    }
}

struct Cap2Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-SemiBold", size: 10))
    }
}

struct BtnBold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Bold", size: 16))
    }
}

struct Num1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Bold", size: 28))
            .tracking(3)
    }
}

struct Num2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Bold", size: 20))
            .tracking(3)
    }
}

struct Num3: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-SemiBold", size: 16))
            .tracking(3)
    }
}

struct Num3Bold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Bold", size: 16))
            .tracking(3)
    }
}

struct Num4: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Regular", size: 14))
            .tracking(3)
    }
}

struct Num4SemiBold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-SemiBold", size: 14))
            .tracking(3)
    }
}

struct Num5: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard-Regular", size: 12))
            .tracking(3)
    }
}
