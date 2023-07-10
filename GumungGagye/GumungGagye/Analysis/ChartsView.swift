//
//  ChartsView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/10.
//

import SwiftUI

public struct ChartView: View {
    public let values: [Double]
    public let names: [String]
    public let formatter: (Double) -> String

    public var colors: [Color]
    public var backgroundColor: Color

    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat

    @State private var activeIndex: Int = -1

    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []

        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }

    public init(values:[Double], names: [String], formatter: @escaping (Double) -> String, colors: [Color] = [Color("Food"), Color("Cafe"), Color("Alcohol"), Color("Etc")], backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0), widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.50){
        self.values = values
        self.names = names
        self.formatter = formatter

        self.colors = colors
        self.backgroundColor = backgroundColor
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    ForEach(0..<self.values.count){ i in
                        PieSliceView(pieSliceData: self.slices[i], isShowingTag: self.activeIndex == i ? true : false)
                            .scaleEffect(self.activeIndex == i ? 1.03 : 1)
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
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                    
                    // 차트 내부 텍스트
                    VStack {
                        Text(self.activeIndex == -1 ? "총" : names[self.activeIndex])
                            .modifier(Body2())
                            .foregroundColor(Color.gray)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                            .modifier(Body1Bold())
                    }

                }
//                PieChartRows(colors: self.colors, names: self.names, values: self.values.map { self.formatter($0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
            }
            .foregroundColor(Color.black)
        }
    }
}

struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]

    var body: some View {
        VStack{
            ForEach(0..<self.values.count){ i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(self.colors[i])
                        .frame(width: 20, height: 20)
                    Text(self.names[i])
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                        Text(self.percents[i])
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(values: [900, 500, 300, 400], names: ["식비", "카페", "교통", "건강"], formatter: {value in String(format: "%.0f원", value)})
    }
}


