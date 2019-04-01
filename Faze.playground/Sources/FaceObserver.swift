import Foundation
import AVFoundation
import UIKit
import Vision

class FaceObserver : NSObject {
    private var captureSession : AVCaptureSession!
    private var device : AVCaptureDevice?
    private var videoOutput : AVCaptureVideoDataOutput!
    private var onFaceObserved : (VNRequest, Error?) -> ()
    
    init(onCameraAccepted: @escaping () -> (), onCameraDenied:  @escaping () -> (), onFaceObserved: @escaping (VNRequest, Error?) -> ()) {
        self.onFaceObserved = onFaceObserved
        super.init()
        setupFaceObserver(onAccepted: onCameraAccepted, onDenied: onCameraDenied)
    }
    
    func startObservation() {
        self.captureSession.startRunning()
    }
    
    func stopObservation() {
        self.captureSession.stopRunning()
    }
    
    func setupFaceObserver(onAccepted: @escaping ()->(), onDenied: @escaping ()->()) {
        self.captureSession = AVCaptureSession()
        self.videoOutput = AVCaptureVideoDataOutput()
        self.device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted { onAccepted() }
                else { onDenied() }
            })
        }
        else { onAccepted() }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: self.device!) as AVCaptureDeviceInput
            self.captureSession.addInput(videoInput)
        } catch let error as NSError {
            print(error)
        }
        
        self.videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_32BGRA)]
        
        self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        self.videoOutput.alwaysDiscardsLateVideoFrames = true
        
        self.captureSession.addOutput(self.videoOutput)
        
        for connection in self.videoOutput.connections {
            connection.videoOrientation = .portrait
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage {
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        let imageRef = context!.makeImage()
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let resultImage: UIImage = UIImage(cgImage: imageRef!)
        return resultImage
    }
}

extension FaceObserver: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        DispatchQueue.main.async {
            let image: UIImage = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer)
            let request = VNDetectFaceRectanglesRequest { (request: VNRequest, error: Error?) in
                self.onFaceObserved(request, error)
            }
            
            if let cgImage = image.cgImage {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                try? handler.perform([request])
            }
        }
    }
}
