//
//  SelectingBudgetView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

struct SelectingBudgetView: View {
    @State var budget: String
    //    @Binding var isAbled: Bool
    @State var isAbled: Bool = false
    @State var logic: Bool = false
    @Binding var budgetSetting: Bool
    let inputdata = InputUserData.shared
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack( spacing: 0) {
                HStack {
                    Text("한 달 지출 목표 금액이\n얼마인가요?")
                        .modifier(H1Bold())
                    Spacer()
                }
                .padding(.bottom, 36)
                .padding(.top, 50)
                
                
                HStack {
                    TextField(text: $budget) {
                        Text("금액을 입력해주세요")
                    }.onChange(of: budget) { newValue in
                        isAbled = !newValue.isEmpty
                        //                        print(keyboardResponder.currentHeight)
                    }
                    //키보드 숫자로!!!
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .modifier(H2SemiBold())
                    .padding(.bottom, 14)
                    
                    Text("원")
                        .modifier(H2SemiBold())
                        .padding(.bottom, 14)
                        .foregroundColor(Color("Gray1"))
                    
                }
                Divider()
                    .frame(height: 1)
                
                Spacer()
                
                
                Button(action: {
                    
                    logic = true
                    inputdata.goal = Int(budget)
                    
                    Task{
                        if let userss = Auth.auth().currentUser {
                            try await Firestore.firestore().collection("users").document(userss.uid).updateData(["goal": inputdata.goal])
                        }
                    }
                    
                    budgetSetting = false
                    
                    
                    
                }, label: {
                    OnboardingNextButton(isAbled: $isAbled, buttonText: "저장하기")
                    
                })
                .disabled(!isAbled)
                .padding(.bottom, 25)
                
            }
            .padding(.horizontal, 20)
        }
    }
}

struct SelectingBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectingBudgetView(budget: "10000", budgetSetting: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
