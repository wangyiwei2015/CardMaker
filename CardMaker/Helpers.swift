//
//  Helpers.swift
//  CardMaker
//
//  Created by wyw on 2022/6/22.
//

import SwiftUI

//extension View {
//    func snapshot(origin: CGPoint = .zero, size: CGSize = .zero) -> UIImage {
//        let controller = UIHostingController(rootView: self.environmentObject(AppState()))
//        let view = controller.view
//
//        let targetSize = size == .zero ? controller.view.intrinsicContentSize : size
//        view?.backgroundColor = UIColor.clear
//        view?.bounds = CGRect(origin: origin, size: targetSize)
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}

extension View {
    func snapshot(_ _controller: UIViewController? = nil) -> UIImage {
        let controller = _controller ?? UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

let dataDir = "\(NSHomeDirectory())/Documents/"
