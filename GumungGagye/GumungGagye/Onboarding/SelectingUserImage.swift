//
//  SelectingUserImage.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/21.
//

import SwiftUI

struct SelectingUserImage: View {
    @State var logic: Bool = false
    @State var isAbled: Bool = false
    let inputdata = InputUserData.shared
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
       
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        CustomBackButton { presentationMode.wrappedValue.dismiss() }
                        Spacer()
                        Text("건너뛰기")
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                    }
                    .padding(.top, 66)
                    .padding(.bottom, 60)
                    
                   Spacer()
                    
                    
                    Button(action: {
                      
                        inputdata.profile_image
                        logic = true
                        
                    }, label: {
                        OnboardingNextButton(isAbled: $isAbled)
                        
                    })
                    .navigationDestination(isPresented: $logic, destination: {
                        // 목적지
                        SelectingBudget()
                        
                    })
                    .disabled(!isAbled)
                    .padding(.bottom, 25)
                    
                    //                .padding(.bottom, keyboardResponder.currentHeight > 0 ? 250 : 59)
                    
                    .animation(.easeInOut)
                    
                }
                
                
            }
            
            .edgesIgnoringSafeArea([.top])
            .padding(.horizontal, 20)
            
        }
        
    
}

struct SelectingUserImage_Previews: PreviewProvider {
    
    
    static var previews: some View {
        SelectingUserImage(isAbled: true)
    }
}





