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
                            .shadow(color: Color("Food"), radius: 2, x: 0, y: 0) //카테고리에 맞는 색으로 변경
                        VStack{
                            Text("식비") // 카테고리 텍스트로 변경
                                .modifier(Cap2())
                                .foregroundColor(Color("Black"))
                            Text(pieSliceData.text)
                                .modifier(Cap1Bold())
                                .foregroundColor(Color("Food")) //카테고리에 맞는 색으로 바꿔야함
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
    var text: String
    var color: Color
}

struct PieSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieSliceView(pieSliceData: PieSliceData(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 120.0), text: "30%", color: Color.black), isShowingTag: true)
    }
}
