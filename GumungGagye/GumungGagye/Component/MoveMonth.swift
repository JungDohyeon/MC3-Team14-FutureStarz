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
    @Binding var selectedMonth: Date
    
    var body: some View {

        HStack {
            Button(action: {
                self.selectedMonth = self.calendar.date(byAdding: .month, value: -1, to: self.selectedMonth) ?? self.selectedMonth
            }, label: {
                switch size {
                case .Big:
                    Image("Chevron.left.thick.gray")
                default:
                    Image("Chevron.left.midi.gray")
                }
            })
            
            fontView(for: size)
            
            if formattedDate(selectedMonth) == formattedDate(Date.now) {
                Button(action: {
                    print("selected Month: \(selectedMonth)")
                    print("today : \(Date.now)")
                }, label: {
                    switch size {
                    case .Big:
                        Image("Chevron.right.thick.gray3")
                    default:
                        Image("Chevron.right.midi.gray3")
                    }
                })
            } else {
                Button(action: {
                    self.selectedMonth = self.calendar.date(byAdding: .month, value: 1, to: self.selectedMonth) ?? self.selectedMonth
                }, label: {
                    switch size {
                    case .Big:
                        Image("Chevron.right.thick.gray")
                    default:
                        Image("Chevron.right.midi.gray")
                    }
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

