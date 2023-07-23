//
//  AddModalViewModel.swift
//  GumungGagye
//
//  Created by Lee Juwon on 2023/07/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddModalViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var currentDate: Date = Date()
    @Published var number: String = ""
    @Published var tappedExpenseCategory: String = ""
    @Published var tappedIncomeCategory: String = ""
    @Published var tappedDate: String = ""
    @Published var isCheckedExpense = false
    @Published var isCheckedShare = true
    @Published var selectButton: SelectedButtonType = .expense
    
    private var db = Firestore.firestore()

    func addExpenseData(expenseData: ExpenseData) {
        do {
            let documentRef = try db.collection("expense").addDocument(from: expenseData)
            print("ExpenseData added with ID: \(documentRef.documentID)")
        } catch {
            print("Error adding expense data: \(error)")
        }
    }

    func addIncomeData(incomeData: IncomeData) {
        do {
            let documentRef = try db.collection("income").addDocument(from: incomeData)
            print("IncomeData added with ID: \(documentRef.documentID)")
        } catch {
            print("Error adding income data: \(error)")
        }
    }
    
    // 추가: 데이터 초기화
    func clearData() {
        text = ""
        currentDate = Date()
        number = ""
        tappedExpenseCategory = ""
        tappedIncomeCategory = ""
        tappedDate = ""
        isCheckedExpense = false
        isCheckedShare = true
        selectButton = .expense
    }
}
