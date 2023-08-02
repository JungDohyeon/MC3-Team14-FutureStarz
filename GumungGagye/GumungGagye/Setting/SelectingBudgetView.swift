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
    @ObservedObject var input = NumbersOnlyInput()
    @State var budget: String
    //    @Binding var isAbled: Bool
    @State var isAbled: Bool = false
    @State var logic: Bool = false
    @Binding var budgetSetting: Bool
    let inputdata = InputUserData.shared
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("한 달 지출 목표 금액이\n얼마인가요?")
                    .modifier(H1Bold())
                    .padding(.bottom, 12)
                
                Text("생활 고정비를 포함해서 적어주세요.")
                    .modifier(Body1())
                    .foregroundColor(Color("Gray1"))
                    .padding(.bottom, 36)
                
                
                HStack {
                    TextField(text: $input.groupGoalValue) {
                        Text("금액을 입력해주세요")
                    }.onChange(of: input.groupGoalValue) { newValue in
                        
                        isAbled = !newValue.isEmpty
                        input.groupGoalValue = String(newValue.prefix(9))
                        
//                        inputdata.goal = Int(input.groupGoalValue)
                        //                        print(keyboardResponder.currentHeight)
                    }
                    //키보드 숫자로!!!
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("Gray1"))
                    .modifier(Num2())
                    .padding(.bottom, 14)
                    .padding(.leading, 8)
                    
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
                    inputdata.goal = Int(input.groupGoalValue)
                    print("input \(inputdata.goal)")
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
                .padding(.bottom, 30)
                
            }
            .padding(.horizontal, 20)

        }
        .background(Color("background"))
    }
}

struct SelectingBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        SelectingBudgetView(budget: "10000", budgetSetting: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}


