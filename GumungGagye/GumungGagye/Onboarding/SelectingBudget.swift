//
//  SeletingBudget.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI


struct SelectingBudget: View {
    @State var logic: Bool = false
    @ObservedObject var input = NumbersOnlyInput()
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    @State var budget: String = ""
    @State var isAbled: Bool = false
    @Environment(\.presentationMode) var presentationMode
    let inputdata = InputUserData.shared
    var body: some View {
        VStack(spacing: 0) {
            VStack( spacing: 0) {
                HStack {
                    CustomBackButton { presentationMode.wrappedValue.dismiss() }
                    Spacer()
                    
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
                    TextField(text: $input.groupGoalValue) {
                        Text("금액을 입력해주세요")
                    }.onChange(of: input.groupGoalValue) { newValue in
                        isAbled = !newValue.isEmpty
//                        print(keyboardResponder.currentHeight)
                        input.groupGoalValue = String(newValue.prefix(9))
                    }
                    //키보드 숫자로!!!
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("Gray1"))
                    .modifier(Num2())
                    .padding(.bottom, 14)
                    .padding(.leading, 8)
                    
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
                    logic = true
                    inputdata.goal = Int(input.groupGoalValue)
                    
                }, label: {
                    OnboardingNextButton(isAbled: $isAbled, buttonText: "다음")
                        
                })
                .navigationDestination(isPresented: $logic, destination: {
                    // 목적지
                    SelectingUserImage()
                        
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
