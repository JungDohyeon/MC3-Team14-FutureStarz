//
//  SeletingBudget.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI


struct SelectingBudget: View {
    @State var logic: Bool = false
    @AppStorage("budget") var user_budget: String = ""
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    @State private var isActive: Bool = false
    @State private var budget: String = ""
    @State var isAbled: Bool = false
    @Environment(\.presentationMode) var presentationMode
    let inputdata = InputUserData.shared
    var body: some View {
        VStack(spacing: 0) {
            VStack( spacing: 0) {
                HStack {
                    CustomBackButton { presentationMode.wrappedValue.dismiss() }
                    Spacer()
                    Text("건너뛰기")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                }
                .padding(.top, 66)
                .padding(.bottom, 60)
                
                HStack {
                    Text("한 달 지출 목표 금액이\n얼마인가요?")
                        .modifier(H1Bold())
                    Spacer()
                }
                .padding(.bottom, 36)
                
                
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
                    if isAbled {
                        Text("원")
                            .modifier(H2SemiBold())
                            .padding(.bottom, 14)
                            .foregroundColor(Color("Gray1"))
                    }
                }
                Divider()
                    .frame(height: 1)
                
                Spacer()
                
                
                Button(action: {
                    user_budget = budget
                    logic = true
                    inputdata.goal = Int(budget)
                    
                }, label: {
                    OnboardingNextButton(isAbled: $isAbled)
                        
                })
                .navigationDestination(isPresented: $logic, destination: {
                    // 목적지
                    PreStart()
                        
                })
                .disabled(!isAbled)
                .padding(.bottom, 25)
                
                
                
                
//                NavigationLink(destination: PreStart()) {
//                    OnboardingNextButton(isAbled: $isAbled)
//                }
//                .disabled(!isAbled)
////                .padding(.bottom, keyboardResponder.currentHeight > 0 ? 250 : 59)
//                .padding(.bottom, 25)
            }
        }
        .edgesIgnoringSafeArea([.top])
        .padding(.horizontal, 20)
//        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
}

struct SelectingBudget_Previews: PreviewProvider {
    static var previews: some View {
        SelectingBudget()
    }
}
