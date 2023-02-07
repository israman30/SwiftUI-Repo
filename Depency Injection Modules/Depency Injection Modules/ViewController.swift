//
//  ViewController.swift
//  Depency Injection Modules
//
//  Created by Israel Manzo on 2/7/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: .init(x: 0, y: 0, width: 250, height: 50))
        button.setTitle("Tap Here", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        view.addSubview(button)
        button.center = view.center
    }


}

