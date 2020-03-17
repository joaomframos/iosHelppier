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
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
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

