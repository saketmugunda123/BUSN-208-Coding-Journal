import SwiftUI
import CoreML
import Vision
import UIKit

struct ContentView: View {
    @State private var image: UIImage?
    @State private var resultText: String = "No result yet"
    @State private var showingImagePicker = false
    
    let fastVitModel = try! FastViTT8F16(configuration: MLModelConfiguration())
    let trialErrorModel = try! TrialError_1(configuration: MLModelConfiguration())

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.2, green: 0.2, blue: 0.3)]),
                          startPoint: .top,
                          endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // App Title
                    VStack(spacing: 8) {
                        Text("Caption Generator")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Smart Caption Assistant")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 20)
                    
                    // Image Display Area
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.1))
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        if let img = image {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .padding(10)
                        } else {
                            VStack(spacing: 15) {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.5))
                                Text("Tap to select an image")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.headline)
                            }
                        }
                    }
                    .frame(height: 300)
                    .padding(.horizontal)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                    
                    // Result Display
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Caption")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text(resultText)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    // Select Image Button
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Select Image")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                          startPoint: .leading,
                                          endPoint: .trailing)
                        )
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $image, didSelectImage: { img in
                if let img = img {
                    processImage(img)
                }
            })
        }
    }

    func processImage(_ uiImage: UIImage) {
        guard let pixelBuffer = uiImage.pixelBuffer(width: 256, height: 256) else {
            resultText = "Image conversion failed"
            return
        }

        // Step 1: Get label from FastVit
        guard let fastVitOutput = try? fastVitModel.prediction(image: pixelBuffer) else {
            resultText = "FastVit failed"
            return
        }

        let dominantLabel = fastVitOutput.classLabel

        // Step 2: Feed label to TrialError_1
        guard let output = try? trialErrorModel.prediction(text: dominantLabel) else {
            resultText = "TrialError_1 failed"
            return
        }

        resultText = output.label
    }
}

// UIViewControllerRepresentable for UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var didSelectImage: (UIImage?) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.didSelectImage(uiImage)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No update needed
    }
}

// Helper: Convert UIImage to CVPixelBuffer
extension UIImage {
    func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width, height,
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(buffer, [])
        let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                width: width, height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }
}

#Preview {
    ContentView()
}
