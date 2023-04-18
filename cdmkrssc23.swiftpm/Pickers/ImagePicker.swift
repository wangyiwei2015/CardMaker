//  ImagePicker.swift

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
        }.buttonStyle(CapsuleOpButtonStyle(bgColor: .primary, fontSize: 18, paddingSize: 15))
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
        try! chosenImg.jpegData(compressionQuality: 1)!.write(to: URL(fileURLWithPath: "\(NSHomeDirectory())/tmp/\(designDate)_\(cardDate).jpg"), options: .atomic)
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
