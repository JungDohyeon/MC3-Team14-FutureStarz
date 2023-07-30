//
//  SelectingUserImage.swift
//  GumungGagye
//
//  Created by 신상용 on 2023/07/21.
//

import SwiftUI

struct SelectingUserImage: View {
    @State var shouldShowImagePicker = false
    @State var image: UIImage? = nil
    @State var logic: Bool = false
    @State var isAbled: Bool = false
    let inputdata = InputUserData.shared
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    CustomBackButton { presentationMode.wrappedValue.dismiss() }
                    Spacer()
                    NavigationLink {
                        SelectingBank()
                    } label: {
                        Text("건너뛰기")
                            .modifier(Body2())
                            .foregroundColor(Color("Gray1"))
                    }
                }
                .padding(.top, 66)
                .padding(.bottom, 60)
                
                
                HStack {
                    Text("프로필 사진을 입력해주세요")
                        .modifier(H1Bold())
                    Spacer()
                }
                .padding(.bottom, 36)
                
                
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 144, height: 144)
                                .overlay {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                    }else {
                                        Image("SeletingPictureIcon")
                                            .resizable()
                                            .frame(width: 144, height: 144)
                                            .shadow(color: Color(red: 0.31, green: 0.32, blue: 0.63).opacity(0.2), radius: 5, x: 0, y: 2)
                                    }
                                }
                            
                            Image("SelectingAlbum")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .offset(x: 50, y: 50)
                            
                        }
                        
                        /*
                        ZStack {
                            
                            Circle()
                                .foregroundColor(Color("Gray2"))
                                .frame(width: 144, height: 144)
                                .overlay {
                                    if let image = self.image {
                                        //
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                    } else {
//                                        Image(systemName: "person.fill")
                                        image("SeletingPictureIcon")
                                            .font(.system(size: 68))
                                            .foregroundColor(Color(.white))
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                }
                            
                            
                            Circle()
                                .frame(width: 52, height: 52)
                                .foregroundColor(Color("Gray2"))
                                .overlay {
                                    Image(systemName: "photo.circle.fill")
                                                                    .symbolRenderingMode(.palette)
                                                                    .foregroundStyle(Color("Gray2"), .white, .white)
                                                                    .font(.system(size: 50))
                                }
                                .offset(x: 50, y: 50)
                            
                           
                            
                        }
                        */
                     
                    }
                }
                
                
                Spacer()
                
                
                Button(action: {
                    
                    inputdata.profile_image = image
                    logic = true
                    persistImageToStorage()
                }, label: {
                    OnboardingNextButton(isAbled: $isAbled, buttonText: "다음")
                    
                })
                .navigationDestination(isPresented: $logic, destination: {
                    // 목적지
                    SelectingBank()
                    
                })
                .disabled(!isAbled)
                .padding(.bottom, 25)
                
                
                
                .animation(.easeInOut)
                
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea([.top])
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image, isAbled: $isAbled)
        }
//        .onAppear {
//            image = nil
//        }
    }
    private func persistImageToStorage()  {
        
        //        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return  }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
//        guard let imageData = inputdata.profile_image?.jpegData(compressionQuality: 0.5) else { return }
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata:nil) { metadata, err in
            if let err = err {
                print(err)
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print(err)
                    return
                }
                self.inputdata.profile_image_url = url?.absoluteString
                print(ref)
                print(url?.absoluteString)
                
            }
        }
    }
    
    
    
}

struct SelectingUserImage_Previews: PreviewProvider {
    
    
    static var previews: some View {
        SelectingUserImage(isAbled: true)
    }
}





