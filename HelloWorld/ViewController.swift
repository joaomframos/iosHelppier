//
//  ViewController.swift
//  HelloWorld
//
//  Created by João Ramos on 16/03/2020.
//  Copyright © 2020 João Ramos. All rights reserved.
//

import UIKit

class MyView: UIView {
    let label = UILabel()

    func updateText(_ text:String?) {
        guard let text = text else { return }
        label.text = text
    }

    override init(frame: CGRect){
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MyView!"
        label.numberOfLines = 0
        label.textColor = .red
        label.textAlignment = .center
        self.addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    
//    lazy var editButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Edit", for: .normal)
//        button.setTitleColor(.gray, for: .normal)
//        button.layer.cornerRadius = 4.0
//        button.layer.borderColor = UIColor.gray.cgColor
//        button.layer.borderWidth = 1.0
//        button.tintColor = .gray
//        button.backgroundColor = .clear
//        // button.autoSetDimension(.width, toSize: 96.0)
//        // button.autoSetDimension(.height, toSize: 32.0)
//        return button
//    }()
    
    let newView = MyView();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helppier(view: self.view)
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//        label.center = CGPoint(x: 160, y: 285)
//        label.textAlignment = .center
//        label.text = "I'm a test label"
//        self.view.addSubview(label)
//
//        let button = UIButton(frame: CGRect(x: 500, y: 0, width: 200, height: 100))
//        button.setTitle("Edit", for: .normal)
//        // button.center = CGPoint(x: 100, y: 50)
//        button.setTitleColor(.gray, for: .normal)
//        button.layer.cornerRadius = 4.0
//        button.layer.borderColor = UIColor.gray.cgColor
//        button.layer.borderWidth = 1.0
//        button.tintColor = .gray
//        button.backgroundColor = .clear
//
//        self.view.addSubview(button)
        // Do any additional setup after loading the view.
        // self.view.addSubview(newView);
    }
 
    @IBAction func showMessage(sender: UIButton) {
        let alertController = UIAlertController(title: "Welcome to My First App", message: "Hello World", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func setupStack() {
        newView.updateText("Here goes some random text!")
        let stackView = UIStackView()
        stackView.addArrangedSubview(newView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        // autolayout the stack view
        let sH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[stackView]-20-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["stackView":stackView])
        let sV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[stackView]-30-|", options: NSLayoutConstraint.FormatOptions(rawValue:0), metrics: nil, views: ["stackView":stackView])
        view.addConstraints(sH)
        view.addConstraints(sV)
    }
}

