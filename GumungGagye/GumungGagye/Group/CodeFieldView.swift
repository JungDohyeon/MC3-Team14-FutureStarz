//
//  CodeFieldView.swift
//  GumungGagye
//
//  Created by 정도현 on 2023/07/29.
//

import SwiftUI

// code 입력창 focus state
enum CodeField {
    case groupName
    case groupCaption
    case groupGoal
    case groupMax
    case code1
    case code2
    case code3
    case code4
}

struct CodeFieldView: View {
    @Binding var inputCodeArray: [String]   // 코드 배열
    @FocusState private var codeFocusedField: CodeField?  // 코드 커서

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<inputCodeArray.count, id: \.self) { idx in
                VStack(spacing: 8) {
                    TextField("", text: $inputCodeArray[idx])
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .modifier(Num3())
                        .focused($codeFocusedField, equals: activeStateForIndex(index: idx))

                    // 번호가 채워진 칸은 파란 밑줄로 수정
                    Rectangle()
                        .fill(((codeFocusedField == activeStateForIndex(index: idx)) || inputCodeArray[idx].count != 0) ? Color("Main") : Color("Gray3"))
                        .frame(height: 2)
                }
                .frame(width: 48)
            }
        }
        .onChange(of: inputCodeArray) { newValue in
            letterCondition(value: newValue)
        }
        .onAppear {
            for i in 0..<4 {
                if inputCodeArray[i].isEmpty {
                    codeFocusedField = activeStateForIndex(index: i)
                    break
                } else {
                    codeFocusedField = .code4
                }
            }
        }
    }
    
    // 코드 입력 Validation 확인
    func checkBtnStatus() -> Bool {
        for i in 0..<4 {
            if inputCodeArray[i].isEmpty {
                return false
            }
        }
        return true
    }
    
    func letterCondition(value: [String]) {
        // 한 글자 입력되면 다음 칸으로 이동하기.
        for i in 0..<3 {
            if value[i].count == 1 && activeStateForIndex(index: i) == codeFocusedField {
                codeFocusedField = activeStateForIndex(index: i + 1)
            }
        }
        
        // 뒤로가기
        for i in 1...3 {
            if value[i].isEmpty && !value[i - 1].isEmpty {
                codeFocusedField = activeStateForIndex(index: i - 1)
            }
        }
        
        
        // 한 글자 이상 입력되는 경우 마지막 한 글자만 받는다.
        for i in 0..<4 {
            if value[i].count == 2 {
                inputCodeArray[i] = String(value[i].last!)
            }
        }
    }
    
    func activeStateForIndex(index: Int) -> CodeField {
        switch index {
        case 0: return .code1
        case 1: return .code2
        case 2: return .code3
        default: return .code4
        }
    }
}
