//
//  AnalysisView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/10.
//


import SwiftUI
import FirebaseAuth

struct AnalysisView: View {
    @State var selectedMonth = Date.now
    private let calendar = Calendar.current
    // MARK: - PROPERTY
    @State private var sumGraphWidth: CGFloat = 0.0
    @State var overConsumeSpendArray: [ReadSpendData] = []
    @State var sortOverConsumeSpendArray: [ReadSpendData] = []
    @State var totalOverConsume: Int = 0
    @State var totalConsume: Int = 0
    @State var isAlbed: Bool = true


    @State var overConsumeSpendDetailArray: [(Int, [ReadSpendData])] = []
    @State var sortedCategoryArray: [Dictionary<Int, Int>.Element] = []


    @State var tempKey: [Int] = []
    @State var tempValue: [Int] = []

    @State var categoryKey: [Int] = []
    @State var categoryValue: [Int] = []

    @State var indexs: Int = 0


    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // - MARK: - 분석 타이틀 / 월 변경

                VStack(alignment: .leading, spacing: 24.0) {

                    // 타이틀
                    Text("분석")
                        .modifier(H1Bold())

                    // 월 변경
                    MoveMonth(size: .Small, selectedMonth: $selectedMonth)
                }
                .onAppear {
                    selectedMonth = Date.now
                    self.selectedMonth = self.calendar.date(byAdding: .month, value: -1, to: self.selectedMonth) ?? self.selectedMonth
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 4)
                .padding(.horizontal, 20)
                //


                ScrollView(){


                    // - MARK: - 과소비 분석

                    VStack(alignment: .leading) {

                        // 과소비 요약
                        // - TODO: - 요약 숫자 폰트 변경
                        VStack(alignment: .leading, spacing: 12.0) {
                            Text("과소비 분석")
                                .modifier(Cap1())
                            VStack(alignment: .leading, spacing: 4.0) {
                                Text("과소비를 \(overConsumeSpendArray.count)번 하지 않았다면")
                                    .modifier(H2SemiBold())
                                Text("\(totalOverConsume)원을 아꼈을텐데")
                                    .modifier(H2SemiBold())
                                    .foregroundColor(Color("Main"))
                            }
                        }
                        .padding(.bottom, 16.0)
                        .padding(.top, 32.0)

                        // 과소비 비율 차트
                        VStack(spacing: 8) {
                            // 목표 예산 진행바
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(maxWidth: .infinity, minHeight: 24, maxHeight: 24)
                                        .cornerRadius(9)
                                        .foregroundColor(Color("Light30"))
                                    Rectangle()
                                        .frame(width: max(sumGraphWidth, 0), height: 24)
                                        .cornerRadius(9)
                                        .foregroundColor(Color("Main"))
                                }
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.0)) {
                                        if totalOverConsume != 0 {
                                            sumGraphWidth = Int(totalOverConsume) > Int(totalConsume ?? 0) ? (geometry.size.width) : CGFloat(Double(totalOverConsume)/Double(totalConsume ?? 0)) * (geometry.size.width)
                                            //                                        }
                                        }
                                    }
                                }
                            }.frame(height: 24)

                            HStack {
                                Text("\(totalOverConsume)원")
                                    .modifier(Cap1())
                                    .foregroundColor(Color("Main"))
                                Spacer()
                                Text("월 총 소비금액 \(totalConsume)원")
                                    .modifier(Cap1())
                                    .foregroundColor(Color("Gray2"))
                            }
                        }.padding(.bottom, 28.0)

                        if sortOverConsumeSpendArray.count > 0 && sortOverConsumeSpendArray.count < 3 {
                            VStack(spacing: 10.0) {
                                ForEach(0..<sortOverConsumeSpendArray.count) { index in
                                    TopContentView(rank: index + 1, content: sortOverConsumeSpendArray[index].content, money: sortOverConsumeSpendArray[index].bill)
                                }
                            }
                            .padding(.bottom, 28.0)

                        } else if sortOverConsumeSpendArray.count != 0 {
                            VStack(spacing: 10.0) {
                                TopContentView(rank: 1, content: sortOverConsumeSpendArray[0].content, money: sortOverConsumeSpendArray[0].bill)
                                TopContentView(rank: 2, content: sortOverConsumeSpendArray[1].content, money: sortOverConsumeSpendArray[1].bill)
                                TopContentView(rank: 3, content: sortOverConsumeSpendArray[2].content, money: sortOverConsumeSpendArray[2].bill)
                            }
                            .padding(.bottom, 28.0)
                        }


                        // 더보기 Button
                        NavigationLink(destination: OverpurchasingView(overConsumeSpendArray: $overConsumeSpendArray, sortOverConsumeSpendArray: $sortOverConsumeSpendArray, totalOverConsume: $totalOverConsume, totalConsume: $totalConsume, overConsumeSpendDetailArray: $overConsumeSpendDetailArray, sortedCategoryArray: $sortedCategoryArray, tempKey: $tempKey, tempValue: $tempValue, categoryKey: $categoryKey, categoryValue: $categoryValue)){
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
                        .disabled(isAlbed)
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
                                Text("식비에서 75,400원을 사용하여")
                                    .modifier(H2SemiBold())
                                Text("돈을 가장 많이 썼어요")
                                    .modifier(H2SemiBold())
                            }
                        }
                        .padding(.vertical, 36.0)

                        ChartView(values: [463500, 316500, 118740, 71300, 32760], names: ["식비", "패션, 미용", "의료, 건강", "주거, 통신", "기타"], colors: [Color("Food"), Color("Fashion"), Color("Health"),Color("Traffic"), Color("Etc")], showDescription: false, indexs: $indexs)
                            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200, alignment: .center)

                        // Top 3 List
                        VStack(spacing: 10.0) {



                            TopContentView(rank: 1, content: "식비", money: 463500)
                            TopContentView(rank: 2, content: "패션, 미용", money: 316500)
                            TopContentView(rank: 3, content: "의료, 건강", money: 118740)
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
            .onAppear {
                Task {
                    do {
                        tempKey = []
                        tempValue = []

                        if let userId = Auth.auth().currentUser?.uid {
                            (totalConsume, totalOverConsume, overConsumeSpendArray) = try await BudgetFirebaseManager.shared.analysisFetchPost(userID: userId)
                            sortOverConsumeSpendArray = overConsumeSpendArray
                            sortOverConsumeSpendArray.sort(by: { $0.bill > $1.bill })


                            (overConsumeSpendDetailArray, sortedCategoryArray) = try await BudgetFirebaseManager.shared.analysis2FetchPost(userID: userId)

                            print("result:: \(overConsumeSpendDetailArray)")
                            print("result:: \(sortedCategoryArray)")

                            for indexArray in sortedCategoryArray {
                                self.tempKey.append(indexArray.key)
                                self.tempValue.append(indexArray.value)


                            }


                            categoryKey = tempKey
                            categoryValue = tempValue

                            print("aa\(categoryKey)")
                            print(categoryValue)



                            isAlbed = false
//                            print("oversort::\(sortOverConsumeSpendArray)")
                        }
                    } catch {
                        print(error)
                    }
                }

            }
            .onChange(of: totalOverConsume) { newValue in
                withAnimation(.easeInOut(duration: 1.0)) {
                    sumGraphWidth = max(0, Int(totalOverConsume) > Int(totalConsume ?? 0) ? (geometry.size.width) : CGFloat(Double(totalOverConsume) / Double(totalConsume ?? 0)) * (geometry.size.width))
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

