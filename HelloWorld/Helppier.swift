//
//  Helppier.swift
//  HelloWorld
//
//  Created by João Ramos on 16/03/2020.
//  Copyright © 2020 João Ramos. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    func sendBase64(_ base64: String?) {
        // https://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        let url = URL(string: "http://localhost:3000/widget/ios/screenshot")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "helppierKey": "HELPPIER_FAKE_KEY",
            "base64": base64
        ];
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
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
    
    func handleScreenshot() {
        let screenshot: UIImage? = takeScreenshot(false)
        let base64: String? = toBase64(image: screenshot)
        sendBase64(base64);
    }
    
    
    func getOnboarding(_ callback: @escaping ([String]) -> Void) {
        // https://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
        let url = URL(string: "http://localhost:3000/widget/ios/onboarding")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "helppierKey": "HELPPIER_FAKE_KEY",
        ];
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            // Check the response
            print(response)
        
            // Check if an error occured
            if error != nil {
                // HERE you can manage the error
                print(error)
                return
            }
            
            do {
                   if let data = data, let dataString = String(data: data, encoding: .utf8) {
                       print(dataString);
                       
                       var array: [String]?

                       if let data = dataString.data(using: String.Encoding.utf8) {
                           array = try JSONSerialization.jsonObject(with: data, options: []) as? [String]
                           if let myArray = array {
                                callback(myArray)
                           }
                       }
                   }
           } catch let error as NSError {
               print("Failed to load: \(error.localizedDescription)")
           }
            
        })
        task.resume()
    }
    
    func renderOnboarding(images: [String]) {
        print(images);
        let imageView = UIImageView(frame: CGRect(x: 200, y: 0, width: 200, height: 500));
        imageView.sd_setImage(with: URL(string: images[0]))
        DispatchQueue.main.async {
            self.addSubview(imageView);
        }
    }
    
    func handleOnboarding() {
        getOnboarding(renderOnboarding);
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        // handleScreenshot();
        handleOnboarding();
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

