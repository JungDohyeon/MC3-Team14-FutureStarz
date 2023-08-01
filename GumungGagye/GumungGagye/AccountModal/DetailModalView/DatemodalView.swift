//
//  DatemodalView.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/25.
//

import SwiftUI

struct DatemodalView: View {
    // MARK: - PROPERTY
    @State var isDatePickerVisible: Bool = false
    @Binding var account_date: Date?
    @State var selectDate: Date = Date()
    @State var temData: Date = Date()
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("날짜")
                        .modifier(Body2())
                        .foregroundColor(Color("Gray1"))
                        .padding(.trailing, 50)
                    HStack(spacing: 0) {
                        if account_date == nil {
                            Text("날짜를 선택하세요")
                                .modifier(Body1())
                                .foregroundColor(Color("Gray2"))
                        } else {
                            
                            Text(dateToString(date:account_date!))
                                .modifier(Body1Bold())
                            
                        }
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color("Gray2"))
                            .fontWeight(.bold)
                            .padding(.trailing, 11)
                        
                        
                    } //: HSTACK
                    .padding(.vertical, 22)
                    .onTapGesture {
                        isDatePickerVisible = true
                    }
                    
                    
                    
                    .sheet(isPresented: $isDatePickerVisible) {
                        VStack(spacing: 0) {
                            DatePicker("", selection: $selectDate, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .labelsHidden()
                                .accentColor(Color("Main"))
                                .presentationDetents([.fraction(0.6)])
                                .onChange(of: selectDate) { newValue in
                                    temData = newValue
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 15)
                            
                            
                            Button {
                                isDatePickerVisible = false
                                account_date = temData
                            } label: {
                                GroupCreateBtn(validation: true, text: "선택하기")
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                }
                
            }
            .padding(.leading, 11)
            Divider()
                .frame(height: 1)
                .overlay(Color("Gray4"))
        }
        .padding(.horizontal, 20)
    }
}

extension DatemodalView {
    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEEEE요일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}

//struct DatemodalView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatemodalView(isDatePickerVisible: false, account_date: .constant(Date()))
//            .previewLayout(.sizeThatFits)
//    }
//}
