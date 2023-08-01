//
//  OnboardingNextButton.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI

struct OnboardingNextButton: View {
    @Binding var isAbled: Bool
    @State var buttonText: String
    var body: some View {
        
            HStack {
                Spacer()
                Text(buttonText)
                    .modifier(BtnBold())
                
                Spacer()
            }
            .frame(height: 52)
            .background(isAbled ? Color("Main") : Color("Gray3"))
            .foregroundColor(.white)
            .cornerRadius(12)
        
    }
}

struct OnboardingNextButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingNextButton(isAbled: .constant(true), buttonText: "다음")
    }
}
