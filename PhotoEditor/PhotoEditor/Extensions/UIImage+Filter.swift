import UIKit

extension UIImage {
    func addFilter(_ filterType: FilterType) -> UIImage {
        guard let input = CIImage(image: self) else {
            return self
        }
            
        guard let filter = CIFilter(name: filterType.name) else {
            return self
        }
            
        filter.setValue(input, forKey: kCIInputImageKey)
            
        guard let output = filter.outputImage else {
            return self
        }
            
        let context = CIContext()
            
        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return self
        }
            
        let orientedImage = UIImage(
            cgImage: cgImage,
            scale: self.scale,
            orientation: self.imageOrientation
        )
            
        return orientedImage
    }
}
