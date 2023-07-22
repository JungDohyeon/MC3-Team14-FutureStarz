//
//  SeletingName.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/14.
//

import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    
    var keyboardWillShowNotification: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    }
    
    var keyboardWillHideNotification: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    }
    
    init() {
        keyboardWillShowNotification
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .assign(to: &$currentHeight)
        
        keyboardWillHideNotification
            .map { _ in CGFloat.zero }
            .assign(to: &$currentHeight)
        print(currentHeight)
    }
}



struct SelectingName: View {
    // MARK: - PROPERTY
    @AppStorage("app_name") var app_name: String = ""
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    @State private var name: String = ""
    @State var isAbled: Bool = false
    @State var logic: Bool = false
    
    let inputdata = InputUserData.shared
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("어떤 이름으로 불러드릴까요?")
                        .modifier(H1Bold())
                        .padding(.top, 146)
                        .padding(.bottom, 36)
                    
                    Spacer()
                }
                
                TextField(text: $name) {
                    Text("이름을 입력해주세요")
                }.onChange(of: name) { newValue in
                    isAbled = !newValue.isEmpty
                    print(keyboardResponder.currentHeight)
                }
                
                .modifier(H2SemiBold())
                .padding(.bottom, 14)
                
                Divider()
                    .frame(height: 1)
                
                Spacer()
                
//                NavigationLink(destination: SelectingBank()) {
//
//                    OnboardingNextButton(isAbled: $isAbled)
//
//
//                }
//                .disabled(!isAbled)
                
                Button(action: {
                    app_name = name
                    inputdata.nickname = name
                    logic = true
                    
                }, label: {
                    OnboardingNextButton(isAbled: $isAbled)
                        
                })
                .navigationDestination(isPresented: $logic, destination: {
                    // 목적지
                    SelectingBudget()
                        
                })
                .disabled(!isAbled)
                .padding(.bottom, 25)
                
//                .padding(.bottom, keyboardResponder.currentHeight > 0 ? 250 : 59)
                
                .animation(.easeInOut)
                
            }
            
            
        }
//        .ignoresSafeArea()
        
        .edgesIgnoringSafeArea([.top])
        .padding(.horizontal, 20)
        
    }
}

struct SelectingName_Previews: PreviewProvider {
    static var previews: some View {
        SelectingName(isAbled: true)
    }
}
