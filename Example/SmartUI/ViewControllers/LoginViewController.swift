//
//  LoginViewController.swift
//  SmartUI_Example
//
//  Created by Igor Tiukavkin on 06.12.2020.
//  Copyright © 2020 Igor Tiukavkin. All rights reserved.
//

import UIKit
import SmartUI

class LoginViewController: UIViewController {
    
    let username: Binding<String> = .create("")
    let password: Binding<String> = .create("")

    lazy var notValid = self.username.combine(self.password)
        .map { $0.0.isEmpty || $0.1.isEmpty }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let accentColor: Color = Color.black.opacity(0.8)
        let grayBackground: Color = Color.gray.opacity(0.1)

        ContainerView { [unowned self] in
            ScrollView {
                VStack {[
                    Text("?")
                        .font(Font.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(
                            LinearGradient(colors: [
                                Color.blue.opacity(0.5),
                                Color.blue.opacity(0.2)
                            ], startPoint: .topTrailing, endPoint: .bottomLeading)
                        )
                        .clipShape(Circle())
                        .padding([.top, .bottom], 40),
                    Text("Sign In")
                        .font(Font.system(size: 24, weight: .semibold))
                        .foregroundColor(accentColor)
                        .padding(.bottom, 20),
                    TextField("Username", text: self.username)
                        .foregroundColor(.black)
                        .padding(16)
                        .background(grayBackground)
                        .cornerRadius(6.0)
                        .padding(.bottom, 20),
                    SecureField("Password", text: self.password)
                        .foregroundColor(.black)
                        .padding(16)
                        .background(grayBackground)
                        .cornerRadius(6.0)
                        .padding(.bottom, 20)
                    ,
                    Button("Continue", action: { [unowned self] in
                        self.view.endEditing(true)
                        self.showAlert()
                    })
                    .font(Font.system(size: 20))
                    .disabled(self.notValid),
                ]}.padding(16)
            }
            .bindToKeyboard(extraOffset: 16.0)
        }.layout(in: view)
    }
    
    private func showAlert() {
        let vc = UIAlertController(
            title: "Success",
            message: """
                You are signed in.
                username: \(self.username.value ?? "")
                password: \(self.password.value ?? "")
            """,
            preferredStyle: .alert
        )
        vc.addAction(.init(title: "OK", style: .cancel, handler: nil))
        self.present(vc, animated: true, completion: nil)
    }
}
