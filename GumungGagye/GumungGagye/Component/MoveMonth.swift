//
//  MoveMonth.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/11.
//

import SwiftUI

enum FontSize {
    case Big
    case Small
    case XSmall
}

struct MoveMonth: View {

    var size: FontSize
    private let calendar = Calendar.current
    @State var selectedMonth : Date
    
    var body: some View {

        HStack {
            Button(action: {
                self.selectedMonth = self.calendar.date(byAdding: .month, value: -1, to: self.selectedMonth) ?? self.selectedMonth
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("Gray1"))
            })
            
            fontView(for: size)
            
            if formattedDate(selectedMonth) == formattedDate(Date.now) {
                Button(action: {
                    print("selected Month: \(selectedMonth)")
                    print("today : \(Date.now)")
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("Gray3"))
                })
            } else {
                Button(action: {
                    
                    self.selectedMonth = self.calendar.date(byAdding: .month, value: 1, to: self.selectedMonth) ?? self.selectedMonth
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("Gray1"))
                })
            }
        }

    }
    
    private func formattedDate(_ date: Date) -> String {
        let month = calendar.component(.month, from: date)
        return "\(month)월"
    }
    
    @ViewBuilder
    private func fontView(for size: FontSize) -> some View {
        switch size {
        case .Big:
            Text("\(formattedDate(selectedMonth))")
                .modifier(H1Bold())
        case .Small:
            Text("\(formattedDate(selectedMonth))")
                .modifier(H2SemiBold())
        case .XSmall:
            Text("\(formattedDate(selectedMonth))")
                .modifier(Body1())
        }
    }
}

struct MoveMonth_Previews: PreviewProvider {
    static var previews: some View {
        MoveMonth(size: .Big, selectedMonth: Date.now)
    }
}
