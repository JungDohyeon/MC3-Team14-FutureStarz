//
//  OverpurchasingView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/11.
//

import SwiftUI

struct OverpurchasingView: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 36.0) {
                VStack(alignment: .leading, spacing: 36.0) {
                    // - MARK: - 과소비 합계
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 12.0) {
                            VStack(alignment: .leading, spacing: 8.0){
                                HStack(spacing: 4.0) {
                                    Text("2023년 7월")
                                    Text("과소비")
                                        .foregroundColor(Color("OverPurchasing"))
                                        .modifier(Cap1Bold())
                                    Text("총 금액")
                                }
                                .foregroundColor(Color("Black"))
                                .modifier(Cap1())
                                
                                Text("200,000원")
                                    .modifier(Num1())
                            }
                            
                            Text("총 8회")
                                .foregroundColor(Color("OverPurchasing"))
                                .modifier(Cap1Bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color("OverPurchasingLight"))
                                .cornerRadius(5)
                        }
                        
                        Spacer()
                        // 카테고리 아이콘
                        Circle()
                            .frame(width: 80, height: 80)
                    }
                    .padding(.top, 48.0)
                    
                    // - MARK: - 과소비 TOP 카테고리
                    Text("식비에서 200,000원을 사용하여\n돈을 가장 많이 썼어요")
                        .foregroundColor(Color("Black"))
                        .modifier(H2SemiBold())
                    
                    // - MARK: - 과소비 차트
                    ChartView(values: [900, 500, 300, 400], names: ["식비", "카페", "교통", "건강"], formatter: {value in String(format: "%.0f원", value)}, colors: [Color("Food"), Color("Cafe"), Color("Alcohol"), Color("Etc")])
                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200, alignment: .center)
                }
                .padding(.horizontal, 20)
                
                // - MARK: - 구분선
                DividerView()
                
                // - MARK: - 내역
                VStack(alignment: .leading, spacing: 36.0) {
                    Text("내역")
                        .foregroundColor(Color("Black"))
                    .modifier(H2SemiBold())
                    
                    Text("가계부 뷰에서 만들어주시지 않았을까?")
                        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80)
                        .background(Color("Gray3"))
                }
                .padding(.horizontal, 20.0)
                
                
            }
        }
        .navigationBarTitle("과소비 내역", displayMode: .inline)
    }
}

struct OverpurchasingView_Previews: PreviewProvider {
    static var previews: some View {
        OverpurchasingView()
    }
}
