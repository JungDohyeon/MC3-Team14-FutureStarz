//
//  BreakdownWriting.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

enum WritingList: String {
    case date = "날짜"
    case money = "금액"
    case category = "카테고리"
    case content = "내용"
}

enum ListIcon: String {
    case chevronRight = "chevron.right"
    case pencil = "pencil"
    case text = "0/50"
}

struct BreakdownWriting: View {
    @State private var isDatePickerVisible: Bool = false
    @State var selectedDate = Date()
    @State var number: String
    @State var isCategorySheetVisible: Bool = false
    @State var selectedExpenseCategory: ExpenseCategoryList?
    @State var tappedExpenseCategory: String = ""
    
    @FocusState var isNumberKeyboardVisible: Bool
    
    @Binding var text: String
    @Binding var currentDate: Date
    
    var item: WritingList
    var icon: ListIcon
    var placeholder: String
    
    init(isDatePickerVisible: Bool, number: State<String>, text: Binding<String>, currentDate: Binding<Date>, item: WritingList, icon: ListIcon, placeholder: String) {
        self._isDatePickerVisible = State(initialValue: isDatePickerVisible)
        self._number = number
        self._text = text
        self._currentDate = currentDate
        self.item = item
        self.icon = icon
        self.placeholder = placeholder
    }
    
    //    init(isDatePickerVisible: Bool = false, text: Binding<String>, currentDate: Binding<Date>, item: WritingList, icon: ListIcon, placeholder: String) {
    //        self._isDatePickerVisible = State(initialValue: isDatePickerVisible)
    //        self._text = text
    //        self._currentDate = currentDate
    //        self.item = item
    //        self.icon = icon
    //        self.placeholder = placeholder
    //    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(item.rawValue)
                    .modifier(Body2())
                    .foregroundColor(Color("Gray1"))
                
                // MARK: - 날짜 내역
                if item == .date {
                    Button {
                        isDatePickerVisible = true
                    } label: {
                        Text(extraDate())
                            .foregroundColor(Color("Black"))
                            .modifier(Body1Bold())
                    }
                    .sheet(isPresented: $isDatePickerVisible) {
                        DatePicker("", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .presentationDetents([.medium])
                            .onChange(of: selectedDate) { newValue in
                                currentDate = newValue
                                isDatePickerVisible = false
                            }
                    }
                }
                // MARK: - 금액 내역
                else if item == .money {
                    ZStack(alignment: .leading) {
                        if number.isEmpty {
                            Text("\(placeholder)")
                                .foregroundColor(Color("Gray2"))
                                .modifier(Body1())
                        }
                        
                        TextField("", text: $number)
                            .keyboardType(.decimalPad)
                            .focused($isNumberKeyboardVisible)
                            .foregroundColor(Color("Black"))
                            .modifier(Body1Bold())
                    }
                    .background(Color("Gray5"))
                    .cornerRadius(8)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            if !number.isEmpty {
                                Button("완료") {
                                    isNumberKeyboardVisible = false
                                }
                            }
                        }
                    }
                }
                // MARK: - 카테고리 내역
                else if item == .category {
                    Button {
                        isCategorySheetVisible = true
                    } label: {
                        if let selectedCategory = selectedExpenseCategory {
                            Text(selectedCategory.rawValue)
                                .modifier(Body1Bold())
                                .foregroundColor(Color("Black"))
                        } else {
                            Text("\(placeholder)")
                                .modifier(Body1())
                                .foregroundColor(Color("Gray2"))
                                .sheet(isPresented: $isCategorySheetVisible) {
                                    ExpenseCategorySheet(tappedExpenseCategory: $tappedExpenseCategory, isCategorySheetVisible: $isCategorySheetVisible)
                                        .presentationDetents([.medium])
                                }
                                .onChange(of: tappedExpenseCategory) { newValue in
                                    self.tappedExpenseCategory = newValue
                                    isCategorySheetVisible = false
                                }
                        }
                    }
                }
                // MARK: - 내용 내역
                else if item == .content {
                    ZStack(alignment: .leading) {
                        if text.isEmpty {
                            Text("\(placeholder)")
                                .foregroundColor(Color("Gray2"))
                                .modifier(Body1())
                        }
                        
                        TextField("", text: $text)
                            .keyboardType(.default)
                            .focused($isNumberKeyboardVisible)
                            .foregroundColor(Color("Black"))
                            .modifier(Body1Bold())
                    }
                    .background(Color("Gray5"))
                    .cornerRadius(8)
                    
                    //                    Button {
                    //
                    //                    } label: {
                    //                        Image(systemName: icon.rawValue)
                    //                            .frame(width: 16, height: 16)
                    //                            .foregroundColor(Color("Gray2"))
                    //                    }
                }
                
                Spacer()
                // MARK: - 우측 아이콘
                Button {
                    
                } label: {
                    Image(systemName: icon.rawValue)
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("Gray2"))
                }
            }
            .padding(.vertical, 23)
            .padding(.leading, 12)
        }
        .overlay(
            VStack {
                Spacer()
                Capsule()
                    .foregroundColor(Color("Gray4"))
                    .frame(height: 1)
            }
        )
    }
    
    // MARK: - 함수
    func toggleDatePicker() {
        isDatePickerVisible.toggle()
    }
    
    func extraDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        return formatter.string(from: selectedDate)
    }
    
    
    //    // 현재 날짜
    //    func extraDate() -> [String] {
    //
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "YYYY MMMM DDDD"
    //
    //        let date = formatter.string(from: currentDate)
    //
    //        return date.components(separatedBy: " ")
    //    }
}

//struct BreakdownWriting_Previews: PreviewProvider {
//    static var previews: some View {
//        BreakdownWriting(item: "날짜", text: $text, placeholder: "날짜를 선택하세요")
//    }
//}
