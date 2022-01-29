//
//  PhotoInfoViewController.swift
//  WhiteAndFluffy
//
//  Created by Егор Шкарин on 29.01.2022.
//  
//

import UIKit

final class PhotoInfoViewController: UIViewController {
	private let output: PhotoInfoViewOutput

    init(output: PhotoInfoViewOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension PhotoInfoViewController: PhotoInfoViewInput {
}
