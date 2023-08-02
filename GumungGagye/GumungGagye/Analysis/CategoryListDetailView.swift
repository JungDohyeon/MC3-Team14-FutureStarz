//
//  CategoryListDetailView.swift
//  SSOAP
//
//  Created by 신상용 on 2023/08/02.
//

import SwiftUI

struct CategoryListDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 24.0) {
            Image("Frame 583")
            
            Spacer()
            
        }
        .padding(.horizontal, 20.0)
        .padding(.top, 48)
        .navigationBarTitle("주거, 통신 내역", displayMode: .inline)
        .navigationBarItems(
            leading: CustomBackButton { // 커스텀 Back Button 추가
                presentationMode.wrappedValue.dismiss()
            }
        )
        
        .navigationBarBackButtonHidden(true)
    }
}

struct CategoryListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListDetailView()
    }
}
