//
//  AnalysisView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/10.
//

import SwiftUI

struct AnalysisView: View {
    @State var selectedMonth = Date.now
    
    var body: some View {
            VStack {
                // - MARK: - 분석 타이틀 / 월 변경
                
                VStack(alignment: .leading, spacing: 24.0) {
                    
                    // 타이틀
                    Text("분석")
                        .modifier(H1Bold())
                    
                    // 월 변경
                    MoveMonth(size: .Small, selectedMonth: $selectedMonth)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 4)
                .padding(.horizontal, 20)
                
                ScrollView(){
                    
                    
                    // - MARK: - 과소비 분석
                    
                    VStack(alignment: .leading) {
                        
                        // 과소비 요약
                        // - TODO: - 요약 숫자 폰트 변경
                        VStack(alignment: .leading, spacing: 12.0) {
                            Text("과소비 분석")
                                .modifier(Cap1())
                            VStack(alignment: .leading, spacing: 4.0) {
                                Text("과소비를 8번 하지 않았다면")
                                    .modifier(H2SemiBold())
                                Text("75,500원을 아꼈을텐데")
                                    .modifier(H2SemiBold())
                                    .foregroundColor(Color("Main"))
                            }
                        }
                        .padding(.bottom, 16.0)
                        .padding(.top, 32.0)
                        
                        // 과소비 비율 차트
                        VStack(spacing: 8) {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(maxWidth: .infinity, minHeight: 24, maxHeight: 24)
                                    .cornerRadius(9)
                                    .foregroundColor(Color("Light30"))
                                Rectangle()
                                    .frame(width: 100, height: 24)
                                    .cornerRadius(9)
                                    .foregroundColor(Color("Main"))
                            }
                            HStack {
                                Text("75,500원")
                                    .modifier(Cap1())
                                    .foregroundColor(Color("Main"))
                                Spacer()
                                Text("월 총 소비금액 00원")
                                    .modifier(Cap1())
                                    .foregroundColor(Color("Gray2"))
                            }
                        }
                        .padding(.bottom, 28.0)
                        
                        // Top 3 리스트
                        VStack(spacing: 10.0) {
                            TopContentView(rank: 1, content: "치킨", money: 32000)
                            TopContentView(rank: 2, content: "아이스크림", money: 17000)
                            TopContentView(rank: 3, content: "아이폰 케이스", money: 13300)
                        }
                        .padding(.bottom, 28.0)
                        
                        // 더보기 Button
                        NavigationLink(destination: OverpurchasingView()){
                            VStack {
                                Rectangle()
                                    .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                                    .foregroundColor(Color("Gray3"))
                                HStack {
                                    Text("더보기")
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(Color("Gray1"))
                                .modifier(Body2())
                                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    
                    // - MARK: - 구분선
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, minHeight: 8, maxHeight: 8)
                        .foregroundColor(Color("Gray4"))
                    
                    
                    // - MARK: - 카테고리 분석
                    
                    VStack(alignment: .leading) {
                        
                        // 카테고리 요약
                        VStack(alignment: .leading, spacing: 12.0) {
                        Text("전체소비 분석")
                            .modifier(Cap1())
                            
                            VStack(alignment: .leading, spacing: 4.0) {
                                Text("식비에서 200,000원을 사용하여")
                                    .modifier(H2SemiBold())
                                Text("돈을 가장 많이 썼어요")
                                    .modifier(H2SemiBold())
                            }
                        }
                        .padding(.vertical, 36.0)
                        
                        ChartView(values: [900, 500, 300, 200], names: ["식비", "카페", "교통", "건강"], colors: [Color("Food"), Color("Cafe"), Color("Alcohol"), Color("Etc")], showDescription: false)
                            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200, alignment: .center)
                        
                        // Top 3 List
                        VStack(spacing: 10.0) {
                            TopContentView(rank: 1, content: "식비", money: 155000)
                            TopContentView(rank: 2, content: "교통비", money: 100300)
                            TopContentView(rank: 3, content: "카페", money: 75000)
                        }
                        .padding(.bottom, 28.0)
                        .padding(.top, 24)
                        
                        // 더보기 Button
                        NavigationLink(destination: CategoryListView()){
                            VStack {
                                Rectangle()
                                    .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                                    .foregroundColor(Color("Gray3"))
                                HStack {
                                    Text("더보기")
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(Color("Gray1"))
                                .modifier(Body2())
                                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .padding(.top, 24.0)
            .foregroundColor(Color("Black"))
            .background(Color("background"))
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
