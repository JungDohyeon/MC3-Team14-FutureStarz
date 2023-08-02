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

    @State private var formattedAmount = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
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
                    TextField("", text: $formattedAmount) {
                        Text("금액을 입력해주세요")
                    }
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("Gray1"))
                    .padding(.bottom, 14)
                    .padding(.leading, 8)
                    .onChange(of: formattedAmount) { newValue in
                        // 숫자만 남도록 처리하고, 세 자리마다 쉼표를 추가
                        formattedAmount = formatNumber(newValue.filter("0123456789".contains))
                        input.groupGoalValue = formattedAmount // 포맷팅된 값을 바인딩된 변수에 저장
                        isAbled = !formattedAmount.isEmpty // formattedAmount가 비어있는지 여부에 따라 다음 버튼 활성화
                    }
                    .modifier(Num2())
                    .multilineTextAlignment(.trailing) // 오른쪽 정렬 추가

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
                    inputdata.goal = Int(input.groupGoalValue.filter("0123456789".contains))
                }, label: {
                    OnboardingNextButton(isAbled: $isAbled, buttonText: "다음")
                })
                .navigationDestination(isPresented: $logic, destination: {
                    // 목적지
                    SelectingUserImage()
                })
                .disabled(!isAbled)
                .padding(.bottom, 25)
            }
        }
        .edgesIgnoringSafeArea([.top])
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden(true)
    }

    private func formatNumber(_ numberString: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "," // 쉼표 추가
        numberFormatter.usesGroupingSeparator = true // 그룹 구분자 사용

        guard let number = Double(numberString.filter("0123456789".contains)) else {
            return ""
        }
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

struct SelectingBudget_Previews: PreviewProvider {
    static var previews: some View {
        SelectingBudget()
    }
}
