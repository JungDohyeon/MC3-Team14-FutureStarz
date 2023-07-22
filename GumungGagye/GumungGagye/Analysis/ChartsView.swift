//
//  ChartsView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/10.
//

import SwiftUI

public struct ChartView: View {
    public let values: [Int]
    public let names: [String]
    public let colors: [Color]
    
    public let showDescription : Bool
    
    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = 0
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = Double(value) * 360 / Double(sum)
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees),categoryText: names[i] ,percentText: String(format: "%.0f%%", Double(value) * 100 / Double(sum)), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    public init(values:[Int], names: [String], colors: [Color], showDescription: Bool, widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.50){
        self.values = values
        self.names = names
        self.colors = colors
        self.showDescription = showDescription
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        VStack(spacing: 60.0) {
            GeometryReader { geometry in
                ZStack{
                    // 차트 조각 모음
                    ForEach(0..<self.values.count){ i in
                        PieSliceView(pieSliceData: self.slices[i], isShowingTag: self.activeIndex == i ? true : false)
                            .scaleEffect(self.activeIndex == i ? 1.1 : 1)
                            .animation(.spring())
                            .onTapGesture {
                                if(self.activeIndex != i){
                                    self.activeIndex = i
                                }
                                else{
                                    self.activeIndex = -1
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 180)
                    // 차트 내부 공간
                    Circle()
                        .fill(Color("background"))
                        .frame(width: 80, height: 80)
                }
                .foregroundColor(Color.black)
            }

            
            // 선택된 항목 얼마인지 보여주는 text (showDescription = true일 경우)
            if showDescription == true {
                HStack {
                    Text(self.activeIndex == -1 ? "총" : names[self.activeIndex])
                        .foregroundColor(Color("Black"))
                        .modifier(Body1Bold())
                    Spacer()
                    Text(self.activeIndex == -1 ? "\(values.reduce(0, +))원" : "\(values[self.activeIndex])원")
                        .foregroundColor(Color("Black"))
                        .modifier(Body1Bold())
                }
                .frame(maxWidth: .infinity, minHeight: 46, maxHeight: 46)
                .padding(.horizontal, 16.0)
                .background(Color("Gray4"))
                .cornerRadius(12)
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(values: [90000, 50000, 30000, 4000], names: ["식비", "카페", "교통", "건강"], colors: [Color("Food"), Color("Cafe"), Color("Alcohol"), Color("Etc")], showDescription: false)
    }
}


