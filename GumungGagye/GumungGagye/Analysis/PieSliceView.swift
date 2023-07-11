//
//  PieSliceView.swift
//  GumungGagye
//
//  Created by jeongyun on 2023/07/11.
//

import SwiftUI

struct PieSliceView: View {
    var pieSliceData: PieSliceData

    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }
    
    var isShowingTag: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                // 파이 부분
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    path.move(
                        to: CGPoint(
                            x: width * 0.5,
                            y: height * 0.5
                        )
                    )

                    path.addArc(center: CGPoint(x: width * 0.5, y: height * 0.5), radius: 80, startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle, endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle, clockwise: false)
                }
                .fill(pieSliceData.color)
                
                
                // 카테고리 태그
                if(isShowingTag){
                    ZStack {
                        Circle()
                            .frame(width: 52, height: 52)
                            .shadow(color: pieSliceData.color, radius: 2, x: 0, y: 0)
                        VStack{
                            Text(pieSliceData.categoryText)
                                .modifier(Cap2())
                                .foregroundColor(Color("Black"))
                            Text(pieSliceData.percentText)
                                .modifier(Cap1Bold())
                                .foregroundColor(pieSliceData.color)
                        }
                    }
                    .position(
                        x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.9 * cos(self.midRadians)),
                        y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.9 * sin(self.midRadians))
                    )
                    .foregroundColor(Color.white)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var categoryText: String
    var percentText: String
    var color: Color
}

struct PieSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieSliceView(pieSliceData: PieSliceData(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 120.0),categoryText: "식비", percentText: "30%", color: Color.black), isShowingTag: true)
    }
}
