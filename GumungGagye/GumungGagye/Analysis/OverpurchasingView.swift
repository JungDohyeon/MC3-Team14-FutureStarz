//
//  OverpurchasingView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/11.
//

import SwiftUI
import FirebaseAuth

struct OverpurchasingView: View {
    // MARK: - PROPERTY
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var overConsumeSpendArray: [ReadSpendData]
    @Binding var sortOverConsumeSpendArray: [ReadSpendData]
    @Binding var totalOverConsume: Int
    @Binding var totalConsume: Int
    
    
    @Binding var overConsumeSpendDetailArray: [(Int, [ReadSpendData])]
    @Binding var sortedCategoryArray: [Dictionary<Int, Int>.Element]
    
    
    @Binding var tempKey: [Int]
    @Binding var tempValue: [Int]
    
    @Binding var categoryKey: [Int]
    @Binding var categoryValue: [Int]
    
    @State var indexs: Int = 0
    
    // MARK: - BODY
    var body: some View {
        ScrollView{
            VStack(spacing: 36.0) {
                VStack(alignment: .leading, spacing: 36.0) {
                    // - MARK: - 과소비 합계
//                    VStack {
//                        ZStack {
//                            HStack {
//                                CustomBackButton { presentationMode.wrappedValue.dismiss() }
//                                Spacer()
//                            }
//                            HStack {
//                                Text("과소비 내역")
//                                    .modifier(Body1Bold())
//                            }
//                        }
//                    }
//                    .padding(.top, 20)
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 12.0) {
                            VStack(alignment: .leading, spacing: 8.0){
                                HStack(spacing: 3.0) {
                                    Text("2023년 7월")
                                    Text("과소비")
                                        .foregroundColor(Color("OverPurchasing"))
                                        .modifier(Cap1Bold())
                                    Text("총 금액")
                                }
                                .foregroundColor(Color("Black"))
                                .modifier(Cap1())
                                
                                Text("355,540원")
                                    .modifier(Num1())
                            }
                            
                            Text("총 15회")
                                .foregroundColor(Color("OverPurchasing"))
                                .modifier(Cap1Bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color("OverPurchasingLight"))
                                .cornerRadius(5)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 70.0)
                    
                    // [203540, 53331, 42664, 24887, 31998]
                    // - MARK: - 과소비 차트
                    ChartView(values: [173540, 53331, 42664, 35998, 22887], names: ["패션, 미용", "술, 유흥", "교통, 차량", "마트, 잡화", "기타"], colors: [Color("Fashion"), Color("Alcohol"), Color("Vehicle"), Color("Store"), Color("Etc")], showDescription: true, indexs: $indexs)
                        .frame(maxWidth: .infinity, minHeight: 292, maxHeight: 292, alignment: .center)
                }
                .padding(.top, 48.0)
                .padding(.horizontal, 20)
                
                switch indexs {
                case 0:
                    Image("FashionDateBreakdown")
                case 1:
                    Image("AlcoholDateBreakdown")
                case 2:
                    Image("VehicleDateBreakdown")
                case 3:
                    Image("StoreDateBreakdown")
                    
                default:
                    Text("Etc")
                }
            }
            .padding(.bottom, 20.0)
        }
        .foregroundColor(Color("Black"))
        .background(Color("background"))
        .ignoresSafeArea()
        .navigationBarTitle("과소비 내역", displayMode: .inline)
        .onAppear {
            print("dd: \(categoryKey)")
        }
//        .navigationBarTitle("카테고리별 소비", displayMode: .inline)
        .navigationBarItems(
            leading: CustomBackButton { // 커스텀 Back Button 추가
                presentationMode.wrappedValue.dismiss()
            }
        )
        
        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            Task {
//                do {
//                    if let userId = Auth.auth().currentUser?.uid {
//                        (overConsumeSpendDetailArray, sortedCategoryArray) = try await BudgetFirebaseManager.shared.analysis2FetchPost(userID: userId)
//
//                        print("result:: \(overConsumeSpendDetailArray)")
//                        print("result:: \(sortedCategoryArray)")
//
//                        for indexArray in sortedCategoryArray {
//                            self.tempKey.append(indexArray.key)
//                            self.tempValue.append(indexArray.value)
//
//
//                        }
//                        categoryKey = tempKey
//                        categoryValue = tempValue
//
//                        print(categoryKey)
//                        print(categoryValue)
//
//
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
    }
}

//struct OverpurchasingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverpurchasingView(overConsumeSpendArray: .constant([]), sortOverConsumeSpendArray: .constant([]), totalOverConsume: .constant(10000), totalConsume: .constant(1000000))
//    }
//}
