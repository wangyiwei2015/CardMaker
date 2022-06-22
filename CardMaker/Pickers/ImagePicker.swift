//
//  ImagePicker.swift
//  CardMaker
//
//  Created by wyw on 2022/6/23.
//

import SwiftUI
import Photos

struct ImagePicker: View {
    
    @Binding var image: UIImage
    
    var body: some View {
        Button {
            //
        } label: {
            Label(title: {Text("Pick one photo")}, icon: {Image(systemName: "photo.fill.on.rectangle.fill")})
        }.buttonStyle(CapsuleOpButtonStyle(bgColor: .selection, fontSize: 18, paddingSize: 15))
    }
}

struct WrappedImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    let picker = UIImagePickerController()
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(image: .constant(UIImage()))
    }
}
