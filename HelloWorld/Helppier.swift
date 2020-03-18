//
//  Helppier.swift
//  HelloWorld
//
//  Created by João Ramos on 16/03/2020.
//  Copyright © 2020 João Ramos. All rights reserved.
//

import UIKit

let session = URLSession.shared

class HelppierLayer: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        // helppierLayer.frame.size.height = (view.bounds.height)!
        self.alpha = 0.5
        self.translatesAutoresizingMaskIntoConstraints = true
        
        setupButton();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func simulateHttpRequest() {
        // https://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        let url = URL(string: "http://localhost:3000/widget/ios")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            // Check the response
            print(response)
            
            // Check if an error occured
            if error != nil {
                // HERE you can manage the error
                print(error)
                return
            }
            
        })
        task.resume()
    }
    
    /// Takes the screenshot of the screen and returns the corresponding image
    ///
    /// - Parameter shouldSave: Boolean flag asking if the image needs to be saved to user's photo library. Default set to 'true'
    /// - Returns: (Optional)image captured as a screenshot
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    func toBase64(image: UIImage?) -> String? {
        guard let imageData = image?.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        let screenshot: UIImage? = takeScreenshot(false)
        let base64: String? = toBase64(image: screenshot)
        print(base64)
    }

    func setupButton() {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
          button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.addSubview(button);
    }

}

//class HelppierController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let frame = CGRect(x: 0, y: 0, width: 200, height: 500)
//        let appLayer = HelppierLayer(frame: frame);
//        self.view.addSubview(appLayer)
//    }
//}

class Helppier {
    let view: UIView;
    
    init(view: UIView) {
        self.view = view
        renderLayer();
    }
    
    deinit {
        print("Helppier deinitialization")
    }
    
    func renderLayer() {
        let screenSize: CGRect = UIScreen.main.bounds
        let frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        let helppierLayer: UIView = HelppierLayer(frame: frame);
        self.view.addSubview(helppierLayer)
    }
}

