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
//    func snapshot(_ _controller: UIViewController? = nil) -> UIImage {
//        let controller = _controller ?? UIHostingController(rootView: self)
//        let view = controller.view
//
//        let targetSize = controller.view.intrinsicContentSize
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
    func snapshot() -> UIImage {
        let hosting = UIHostingController(rootView: self.ignoresSafeArea())
        let window = UIWindow(frame: CGRect(
            origin: .zero, size: hosting.view.intrinsicContentSize
        ))
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}

extension UIView {
    var renderedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

/* iOS 16+
 func generateSnapshot() {
    Task {
        let renderer = await ImageRenderer(
            content: ())
        if let image = await renderer.uiImage {
            self.snapshot = image
        }
    }
}
*/

struct CardDesign {
    var date: Int
    
    var title: String
    var titleSizeId: Int
    var titleFontName: String
    var titleColorId: Int
    
    var bgColorId: Int
    
    var mood: String
    var feelSelf: Int = 0
    var feelWorld: Int = 0
    
    var imgStyle: Int
    
    var dateStyle: Int
    var dateOpacityId: Int
    var dateColorId: Int
    var datePosition: Int
    
    var showYear: Bool
    var yearBottom: Bool
    
    static let empty = CardDesign(date: 0, title: NSLocalizedString("_TAP_TO_EDIT", comment: ""), titleSizeId: 0, titleFontName: "PingFangSC-Regular", titleColorId: 6, bgColorId: 2, mood: "🫥", imgStyle: 0, dateStyle: 0, dateOpacityId: 2, dateColorId: 2, datePosition: 0, showYear: false, yearBottom: true)
}

class CardData: NSObject {
    private override init() {}
    static let shared = CardData()
    private let dataDir = "\(NSHomeDirectory())/Documents/"
    
    private func listAllDates() -> [Int] {
        let files = try! FileManager.default.contentsOfDirectory(atPath: dataDir)
        return files.map({Int($0) ?? 0}).filter({$0 > 20000000})
    }
    
    public var allDates: [Int] {listAllDates()}
    
    public func saveData(_ work: CardDesign, designDate: Int, output: UIImage) {
        try? FileManager.default.createDirectory(atPath: "\(dataDir)\(designDate)/", withIntermediateDirectories: true)
        let configFile = "\(dataDir)\(designDate)/\(work.date)_cfg"
        let imgFile = "\(dataDir)\(designDate)/\(work.date).jpg"
        
        try? FileManager.default.removeItem(atPath: imgFile)
        _ = FileManager.default.createFile(atPath: imgFile, contents: output.jpegData(compressionQuality: 1)!)
        
        let sourcePath = "\(NSHomeDirectory())/Documents/\(designDate)/\(designDate)_source.jpg"
        try? FileManager.default.removeItem(atPath: sourcePath)
        try? FileManager.default.moveItem(atPath: "\(NSHomeDirectory())/tmp/\(designDate)_\(designDate).jpg", toPath: sourcePath)
        
        var cfgText = work.title.count < 1 ? " " : work.title
        cfgText.append("\ntitleSizeId=\(work.titleSizeId)")
        cfgText.append("\ntitleFont=\(work.titleFontName)")
        cfgText.append("\ntitleColorId=\(work.titleColorId)")
        cfgText.append("\nbgColorId=\(work.bgColorId)")
        cfgText.append("\nmood=\(work.mood)")
        cfgText.append("\nfeelSelf=\(work.feelSelf)")
        cfgText.append("\nfeelWorld=\(work.feelWorld)")
        cfgText.append("\nimgStyle=\(work.imgStyle)")
        cfgText.append("\ndateStyle=\(work.dateStyle)")
        cfgText.append("\ndateOpacityId=\(work.dateOpacityId)")
        cfgText.append("\ndateColorId=\(work.dateColorId)")
        cfgText.append("\ndatePosition=\(work.datePosition)")
        cfgText.append("\nshowYear=\(work.showYear)")
        cfgText.append("\nyearBottom=\(work.yearBottom)")
        try! cfgText.write(toFile: configFile, atomically: true, encoding: .utf8)
    }
    
    public func loadData(_ designDate: Int) -> [CardDesign] {
        if let cfgText = try? String(contentsOfFile: "\(dataDir)\(designDate)/\(designDate)_cfg") {
            let components = cfgText.split(separator: "\n")
            guard components.count > 12 else {return []} // maybe dont need this check®
            var cfgDict: [String:String] = [:]
            components.filter({String($0).firstIndex(of: "=") != nil}).forEach { str in
                let kvp = str.split(separator: "=")
                cfgDict[String(kvp[0])] = String(kvp[1])
            }
            let firstCard = CardDesign(
                date: designDate, title: String(components[0]),
                titleSizeId: Int(cfgDict["titleSizeId"] ?? "0") ?? 0,
                titleFontName: cfgDict["titleFont"] ?? "PingFangSC-Regular",
                titleColorId: Int(cfgDict["titleColorId"] ?? "6") ?? 6,
                bgColorId: Int(cfgDict["bgColorId"] ?? "2") ?? 2,
                mood: cfgDict["mood"] ?? "🫥",
                feelSelf: Int(cfgDict["feelSelf"] ?? "0") ?? 0,
                feelWorld: Int(cfgDict["feelWorld"] ?? "0") ?? 0,
                imgStyle: Int(cfgDict["imgStyle"] ?? "0") ?? 0,
                dateStyle: Int(cfgDict["dateStyle"] ?? "0") ?? 0,
                dateOpacityId: Int(cfgDict["dateOpacityId"] ?? "2") ?? 2,
                dateColorId: Int(cfgDict["dateColorId"] ?? "2") ?? 2,
                datePosition: Int(cfgDict["datePosition"] ?? "0") ?? 0,
                showYear: Bool(cfgDict["showYear"] ?? "false") ?? false,
                yearBottom: Bool(cfgDict["yearBottom"] ?? "true") ?? true)
            return [firstCard]
        } else {
            return []
        }
    }
    
    public func loadPreviews(_ date: Int) -> [UIImage] {
        if let firstImg = UIImage(contentsOfFile: "\(dataDir)\(date)/\(date).jpg") {
            return [firstImg]
        } else {
            return []
        }
    }
}

extension UIApplication {
    static let keyWindow = keyWindowScene?.windows.filter(\.isKeyWindow).first
    static let keyWindowScene = shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
}

extension View {
    func shareSheet(isPresented: Binding<Bool>, items: [Any]) -> some View {
        guard isPresented.wrappedValue else { return self }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let presentedViewController = UIApplication.keyWindow?.rootViewController?.presentedViewController ?? UIApplication.keyWindow?.rootViewController
        activityViewController.completionWithItemsHandler = { _, _, _, _ in isPresented.wrappedValue = false }
        presentedViewController?.present(activityViewController, animated: true)
        return self
    }
}
