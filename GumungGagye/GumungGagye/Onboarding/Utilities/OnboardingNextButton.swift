//
//  OnboardingNextButton.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI

struct OnboardingNextButton: View {
    @Binding var isAbled: Bool
    
    var body: some View {
        
            HStack {
                Spacer()
                Text("다음")
                    .modifier(BtnBold())
                
                Spacer()
            }
            .frame(height: 48)
            .background(isAbled ? Color("Main") : Color("Gray3"))
            .foregroundColor(.white)
            .cornerRadius(12)
        
    }
}

struct OnboardingNextButton_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingNextButton(isAbled: .constant(true))
    }
}
