//
//  AnalysisView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/10.
//
// - TODO: - 요약 숫자 폰트 변경

import SwiftUI

struct AnalysisView: View {
    var body: some View {
        NavigationView {
            VStack {
                // - MARK: - 분석 타이틀 / 월 변경
                
                VStack(alignment: .leading, spacing: 24.0) {
                    
                    // 타이틀
                    Text("분석")
                        .padding(.top, 24.0)
                        .modifier(H1Bold())
                    
                    // 월 변경
                    HStack(spacing: 12.0) {
                        Button {
                            // 지난 달로
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(Color("Gray1"))
                        
                        Text("7월")
                            .modifier(H2SemiBold())
                        
                        Button {
                            // 다음 달로
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color("Gray1"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 4)
                .padding(.horizontal, 20)
                
                ScrollView(){
                    
                    
                    // - MARK: - 과소비 분석
                    
                    VStack(alignment: .leading) {
                        
                        // 과소비 요약
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text("과소비를 8번 하지 않았다면")
                                .modifier(H2SemiBold())
                            Text("75,500원을 아꼈을텐데")
                                .modifier(H2SemiBold())
                                .foregroundColor(Color("Main"))
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
                            TopContentView(rank: 1, content: "치킨", money: 5000)
                            TopContentView(rank: 1, content: "치킨", money: 5000)
                            TopContentView(rank: 1, content: "치킨", money: 5000)
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
                                .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 58)
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
                        VStack(alignment: .leading) {
                            Text("식비에서 200,000원을 사용하여")
                                .modifier(H2SemiBold())
                            Text("돈을 가장 많이 썼어요")
                                .modifier(H2SemiBold())
                        }
                        .padding(.vertical, 36.0)
                        
                        ChartView(values: [900, 500, 300, 200], names: ["식비", "카페", "교통", "건강"], formatter: {value in String(format: "%.0f원", value)}, colors: [Color("Food"), Color("Cafe"), Color("Alcohol"), Color("Etc")])
                            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200, alignment: .center)
                        
                        // Top 3 List
                        VStack(spacing: 10.0) {
                            TopContentView(rank: 1, content: "치킨", money: 5000)
                            TopContentView(rank: 1, content: "치킨", money: 5000)
                            TopContentView(rank: 1, content: "치킨", money: 5000)
                        }
                        .padding(.bottom, 28.0)
                        .padding(.top, 24)
                        
                        // - TODO: - 카테고리별 소비로 이동
                        // 더보기 Button
                        NavigationLink(destination: Text("카테고리별 소비")){
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
                                .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 58)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
