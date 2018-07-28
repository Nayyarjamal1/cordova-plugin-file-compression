import Foundation
import AVFoundation

let TAG: String = "SACHIN"

@objc(CompressFile) class CompressFile : CDVPlugin {

    func compressImage(_ command: CDVInvokedUrlCommand) {

        let compressionSize = command.arguments[0] as? int ?? 80

        let filePath = command.arguments[0] as? String ?? ""
        let folderPath = command.arguments[1] as? String ?? "MyFolder/Image"
        let compressionSizeFloat: CGFloat = compressionSize/100;
        
        print(TAG, "compressImage")
        print(TAG, filePath)
        print(TAG, folderPath)
        print(TAG, compressionSizeFloat)

        self.compressing(dirPath : filePath, percnet : compressionSizeFloat, command: command);
    }

    func compressing(dirPath: String, percnet: CGFloat, command: CDVInvokedUrlCommand) {
            
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Image2.png")
            let oldImage = UIImage(contentsOfFile: imageURL.path)
            let newImage = oldImage?.resized(withPercentage: percnet)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = "image.jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if let data = UIImageJPEGRepresentation(newImage!, 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
                
                do {
                    try data.write(to: fileURL) {
                        print("file saved")
                        let returnPath = self.getDirectoryPath()
                        let foo = ["path": returnPath] as [AnyHashable : Any]

                        var pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: foo)
                        self.command.send(pluginResult, callbackId: command.callbackId)

                    } catch {
                        print("error saving file:", error)
                        
                        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error Saving File")
                        self.command.send(pluginResult, callbackId: command.callbackId)
                    }
                }

            }
    }    

    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width  percentage, height: size.height  percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}
