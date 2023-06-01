//
//  UsersViewController.swift
//  MyUKit
//
//  Created by Israel Manzo on 2/7/23.
//

import UIKit

public protocol DataFechable {
    func fetchUsers(completion: @escaping([String])->())
}

public class UsersViewController: UIViewController {
    
    let dataFechable: DataFechable
    
    public init(dataFechable: DataFechable) {
        self.dataFechable = dataFechable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    

}
