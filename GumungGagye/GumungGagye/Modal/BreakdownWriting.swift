//
//  BreakdownWriting.swift
//  GumungGagye
//
//  Created by 손서연 on 2023/07/10.
//

import SwiftUI

// 내역 추가 입력창 focus state
enum AccountField {
    case fixDate
    case addPayment
    case addCategory
    case addContent
}

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
    @State var DividerSelect: Bool = false
    @State var selectedDate = Date()
    @State var number: String
    @State var isCategorySheetVisible: Bool = false
    @State var ExpenseCategory: ExpenseCategoryList? // 선택된 카테고리를 추적
    @State var selectedOption: String = ""
    
    @FocusState var isNumberKeyboardVisible: Bool
    @FocusState private var isFocused: Bool
    @FocusState private var focusedField: AccountField?
    
//    @Binding var selectedButton: SelectedButtonType
    @Binding var text: String
    @Binding var currentDate: Date
    @Binding var tappedExpenseCategory: String
    @Binding var tappedIncomeCategory: String
    @Binding var tappedDate: String
    
    @Binding var selectedType: Int
    
    var item: WritingList
    var icon: ListIcon
    var placeholder: String
    
    init(isDatePickerVisible: Bool, number: State<String>, selectedType: Binding<Int>, text: Binding<String>, currentDate: Binding<Date>, tappedExpenseCategory: Binding<String>, tappedIncomeCategory: Binding<String>, tappedDate: Binding<String>, item: WritingList, icon: ListIcon, placeholder: String) {
        self._isDatePickerVisible = State(initialValue: isDatePickerVisible)
        self._number = number
        self._selectedType = selectedType
        self._text = text
        self._currentDate = currentDate
        self._tappedExpenseCategory = tappedExpenseCategory
        self._tappedIncomeCategory = tappedIncomeCategory
        self._tappedDate = tappedDate
        self.item = item
        self.icon = icon
        self.placeholder = placeholder
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        self._tappedDate = Binding<String>(get: {
            formatter.string(from: currentDate.wrappedValue)
        }, set: { _ in })
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(item.rawValue)
                    .modifier(Body2())
                    .foregroundColor(Color("Gray1"))
                    .frame(width: 52, alignment: .leading)
                    .padding(.trailing, 24)
                
                // MARK: - 날짜 내역
                if item == .date {
                    Button {
                        isDatePickerVisible = true
                        DividerSelect = true
                    } label: {
                        Text(tappedDate)
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
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy년 MM월 dd일"
                                tappedDate = formatter.string(from: selectedDate)
                                isDatePickerVisible = false
                                DividerSelect = false
                            }
                        Color.clear
                            .onTapGesture {
                                isDatePickerVisible = false
                                DividerSelect = false
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
                        
                        TextField("", text: $number, onEditingChanged: { isEditing in
                            if isEditing {
                                DividerSelect = true
                            } else {
                                DividerSelect = false
                            }
                        })
                        .keyboardType(.decimalPad)
                        .focused($isNumberKeyboardVisible)
                        .foregroundColor(Color("Black"))
                        .modifier(Body1Bold())
                    }
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
                        DividerSelect = true
                    } label: {
                        if !(tappedExpenseCategory.isEmpty) {
                            Text(tappedExpenseCategory)
                                .modifier(Body1Bold())
                                .foregroundColor(Color("Black"))
                        } else {
                            Text("\(placeholder)")
                                .modifier(Body1())
                                .foregroundColor(Color("Gray2"))
                        }
                    }
                    .sheet(isPresented: $isCategorySheetVisible) {
                        if selectedType == 0 {
                            ExpenseCategorySheet(tappedExpenseCategory: $tappedExpenseCategory, isCategorySheetVisible: $isCategorySheetVisible, DividerSelect: $DividerSelect)
                                .presentationDetents([.medium])
                                .onChange(of: selectedOption, perform: { newValue in
                                    self.tappedExpenseCategory = newValue
                                    isCategorySheetVisible = false
                                    DividerSelect = false
                                })
                        } else if selectedType == 1 {
                            IncomeCategorySheet(tappedIncomeCategory: $tappedExpenseCategory, isCategorySheetVisible: $isCategorySheetVisible, DividerSelect: $DividerSelect)
                                .presentationDetents([.medium])
                                .onChange(of: selectedOption, perform: { newValue in
                                    self.tappedIncomeCategory = newValue
                                    isCategorySheetVisible = false
                                    DividerSelect = false
                                })
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
                        
                        TextField("", text: $text, onEditingChanged: {
                            isEditing in
                            if isEditing {
                                DividerSelect = true
                            } else {
                                DividerSelect = false
                            }
                        })
                        .keyboardType(.default)
                        .focused($isNumberKeyboardVisible)
                        .foregroundColor(Color("Black"))
                        .modifier(Body1Bold())
                    }
                    .cornerRadius(8)
                }
                
                Spacer()
                // MARK: - 우측 아이콘
                if icon == ListIcon.text {
                    HStack(spacing: 0) {
                        Text(text.count.description)
                        Text("/")
                        Text(text.description)
                    }
                    .modifier(Cap1())
                    .foregroundColor(Color("Gray2"))
                    .padding(.vertical, 23)
                    .padding(.leading, 12)
                } else {
                    Button {
                        if item == .date {
                            isDatePickerVisible = true
                        } else if item == .category {
                            isCategorySheetVisible = true
                        }
                    } label: {
                        Image(systemName: icon.rawValue)
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color("Gray2"))
                    }
                    .padding(.vertical, 16)
                    .padding(.leading, 12)
                }
            }
        }
        .padding(.horizontal, 12)
        
        // MARK: - 구분선
        Divider()
            .frame(height: 1)
            .overlay(DividerSelect ? Color("Main") : Color("Gray4"))
    }
    
    // MARK: - 함수
    func toggleDatePicker() {
        isDatePickerVisible.toggle()
    }
}

//struct BreakdownWriting_Previews: PreviewProvider {
//    static var previews: some View {
//        BreakdownWriting(item: "날짜", text: $text, placeholder: "날짜를 선택하세요")
//    }
//}
