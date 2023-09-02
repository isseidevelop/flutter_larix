import Flutter
import UIKit
import AVFoundation

public class SwiftFlutterLarixPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = FlutterLarixNativeViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "br.com.devmagic.flutter_larix/nativeview")
   
    let channel = FlutterMethodChannel(name: "br.com.devmagic.flutter_larix/nativeview_controller", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLarixPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

   public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("chegou aqui pelo menos")
       switch call.method {
            case "initCamera":
                result("teste deu bom")
                break
            case "startStream":
                result("true")
                break
            case "stopStream":
                break
             case "flipCamera":
                // result(data)
                break
            case "stopAudioCapture":
                // result(dataAudioStop)
                break
            case "startAudioCapture":
                // result(dataAudioStart)
                break
            case "stopVideoCapture":
                result("true")
                break
            case "startVideoCapture":
                result("true")
                break
            case "setDisplayRotation":
                result("true")
                break
            case "toggleTorch":
                // result(mStreamerGL.isTorchOn() ? "true" : "false");
                break
            case "getPermissions":
                
                result(getPermissions())
                break
            case "requestPermissions":
                let semaphore = DispatchSemaphore(value: 0)
                var permissions = getPermissions()
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    permissions["hasCameraPermission"] = granted
                    semaphore.signal()
                })
                semaphore.wait()
                result(permissions)
                break
            case "getCameraInfo":
                var cameraInfo: [String : Any] = [
                    "minimumFocusDistance": 1.0,
                    "isTorchSupported": true,
                    "maxZoom": 1.0,
                    "isZoomSupported": true,
                    "maxExposure": 1,
                    "minExposure": 1,
                    "lensFacing": 1,
                    "cameraId": "0"
                ]
                var list = [cameraInfo]
                result(list)
                break
            case "disposeCamera":
                break
            default:
                result("not Implemented")
        }
    }

    func getPermissions() -> Dictionary<String, Bool> {
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        var permissions: [String: Bool] = ["hasAudioPermission": audioStatus,
                                           "hasCameraPermission": cameraStatus]
        return permissions
    }

}
