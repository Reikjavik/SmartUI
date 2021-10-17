//
//  ViewController.swift
//  SmartUI
//
//  Created by Reikjavik on 12/06/2020.
//  Copyright © 2020 Igor Tiukavkin. All rights reserved.
//

import UIKit
import SmartUI

class ViewController: UIViewController {

    let targets: [(UIViewController.Type, String)] = [
        (LoginViewController.self, "Login Form"),
        (HorizontalScrollGallery.self, "Horizontal Scroll Gallery"),
        (EditableProductsList.self, "Editable Products List")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Example"

        let rows = self.targets.map {
            Text($0.1)
                .foregroundColor(Color.blue)
                .multilineTextAlignment(.leading)
                .padding(16)
        }

        let navigationAction: (IndexPath) -> Void = { [weak self] indexPath in
            guard let vc = self?.targets[indexPath.row].0.init() else { return }
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        ContainerView {
            List(selection: navigationAction) { rows }
        }.layout(in: view)
    }
}
