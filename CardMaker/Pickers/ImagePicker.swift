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
    @State var showsPicker = false
    var designDate: Int
    var cardDate: Int
    
    var body: some View {
        Button {showsPicker = true
        } label: {
            Label(title: {Text("Pick one photo")}, icon: {Image(systemName: "photo.fill.on.rectangle.fill")})
        }.buttonStyle(CapsuleOpButtonStyle(bgColor: .selection, fontSize: 18, paddingSize: 15))
        .fullScreenCover(isPresented: $showsPicker) {
            WrappedImagePicker(img: $image, designDate: designDate, cardDate: cardDate)
        }
    }
}

struct WrappedImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    @Binding var img: UIImage
    var designDate: Int
    var cardDate: Int
    
    let picker = UIImagePickerController()
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(
            img: $img, designDate: designDate, cardDate: cardDate
        )
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var img: UIImage
    var designDate: Int
    var cardDate: Int
    
    init(img: Binding<UIImage>, designDate: Int, cardDate: Int) {
        self._img = img
        self.designDate = designDate
        self.cardDate = cardDate
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImg = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as! UIImage)
        img = chosenImg
        try! chosenImg.jpegData(compressionQuality: 1)!.write(to: URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/\(designDate)/\(cardDate).jpg"))
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//struct WrappedImagePicker: UIViewControllerRepresentable {
//    typealias UIViewControllerType = PHPickerViewController
//
//    @Binding var img: UIImage
//    @Binding var isPresented: Bool
//
//    let photoPicker = PHPickerViewController(configuration: {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 1
//        config.filter = .images
//        config.selection = .default
//        config.preferredAssetRepresentationMode = .compatible
//        return config
//    }())
//
//    func makeUIViewController(context: Context) -> UIViewControllerType {
//        photoPicker.delegate = context.coordinator
//        return photoPicker
//    }
//
//    func makeCoordinator() -> ImagePickerCoordinator {
//        ImagePickerCoordinator(self)
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//    }
//}
//
//class ImagePickerCoordinator: NSObject, PHPickerViewControllerDelegate {
//    private let parent: WrappedImagePicker
//
//    init(_ parent: WrappedImagePicker) {
//        self.parent = parent
//    }
//
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        for image in results {
//            if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                image.itemProvider.loadObject(ofClass: UIImage.self) {
//                    (newImage, error) in
//                    if let error = error {
//                        print("err")
//                        //print(error.localizedDescription)
//                    } else {
//                        print("return img")
//                        self.parent.img = newImage as! UIImage
//                    }
//                }
//            } else {
//                print("Loaded Asset is not a Image")
//            }
//        }
//        parent.isPresented = false
//    }
//}
