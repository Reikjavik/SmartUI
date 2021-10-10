//
//  MessengerViewController.swift
//  SmartUI_Example
//
//  Created by Igor Tiukavkin on 06.12.2020.
//  Copyright © 2020 Igor Tiukavkin. All rights reserved.
//

import UIKit
import SmartUI

class MessengerViewController: UIViewController {

    let messages: Binding<[Message]> = .constant([
        .init(type: .incoming, from: "John", content: .text("Hello, how can I help you?"), date: Date()),
        .init(type: .outcoming, from: "Me", content: .text("I am interested in buying a house and need some information"), date: Date()),
        .init(type: .outcoming, from: "Me", content: .image(#imageLiteral(resourceName: "house")), date: Date()),
        .init(type: .incoming, from: "John", content: .text("Yes, of course. What area are you interested in?"), date: Date()),
        .init(type: .outcoming, from: "Me", content: .text("I am interested in Palo Alto"), date: Date()),
        .init(type: .incoming, from: "John", content: .text("What size house would you like?"), date: Date()),
        .init(type: .outcoming, from: "Me", content: .text("I need a medium-sized house with at least 4 bedrooms and 2 bathrooms."), date: Date())
    ])

    let text: Binding<String> = .constant("")
    var scrollToBottom: Action = .empty

    let incomingMessageBgColor = Color(UIColor(red: 10/255, green: 128/255, blue: 245/255, alpha: 1.0))
    let outcomingMessageBgColor = Color(UIColor(red: 216/255, green: 223/255, blue: 230/255, alpha: 1.0))
    let keyboardObserver = KeyboardHeightObserver()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let container = ContainerView { [unowned self] in
            List(self.messages) { message in
                switch message.type {
                case .incoming:
                    return self.incomingMessage(message)
                case .outcoming:
                    return self.outcomingMessage(message)
                }
            }
            .separatorStyle(.none)
            .bindToKeyboard()
            .customModifier { [weak self] view -> UIView in
                self?.scrollToBottom = Action { [weak view] in
                    guard let scrollView = view as? UIScrollView else { return }
                    let bottom = scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom
                    let bottomOffset = CGPoint(x: 0, y: bottom)
                    scrollView.setContentOffset(bottomOffset, animated: true)
                }
                return view
            }
        }
        container.pin([.top, .leading, .trailing], on: view)
        if #available(iOS 11.0, *) {
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -54).isActive = true
        } else {
            container.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: -54).isActive = true
        }
        self.setupInputView()
    }

    private func setupInputView() {
        let inputView = self.createInputView()
        inputView.pin([.leading, .trailing], on: view)
        let bottom: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            bottom = inputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            bottom = inputView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor)
        }
        bottom.isActive = true
        self.keyboardObserver.onWillShow(ActionWith<CGFloat>({ [weak self, weak bottom] height in
            self?.scrollToBottom.execute(delay: 0.1)
            var safeAreaBotttom: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                safeAreaBotttom = self?.view.safeAreaInsets.bottom ?? 0.0
            }
            bottom?.constant = -height + safeAreaBotttom
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }))
        self.keyboardObserver.onWillHide(Action({ [weak self, weak bottom] height in
            bottom?.constant = 0.0
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }))
    }

    private func createInputView() -> UIView {
        let onSend = Action { [unowned self] in
            guard !self.text.value.isEmpty else { return }
            let messages = self.messages.value + [.init(type: .outcoming, from: "Me", content: .text(self.text.value), date: Date())]
            self.messages.update(messages)
            self.text.update("")
            self.scrollToBottom.execute(delay: 0.1)
        }
        let endEditing = Action { [unowned self] in
            self.view.endEditing(true)
        }
        return ContainerView { [unowned self] in
            VStack {[
                Divider(),
                HStack(spacing: 8.0) {[
                    TextField("Message", text: self.text, onCommit: onSend.combine(endEditing))
                        .placeholderColor(.lightGray)
                        .returnKeyType(.done)
                        .foregroundColor(.black)
                        .padding(8.0)
                        .background(Color.lightGray.opacity(0.2))
                        .cornerRadius(8.0),
                    Button("Send", action: onSend)
                        .disabled(self.text.map { $0.isEmpty })
                        .contentCompressionResistance(.required)
                ]}
                .padding([.leading, .trailing], 16.0)
                .padding([.top, .bottom], 8.0)
                .background(Color.white)
            ]}
        }
    }

    private func incomingMessage(_ message: Message) -> View {
        let content: View = {
            switch message.content {
            case .text(let text):
                return Text(text)
                    .font(Font.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
            case .image(let image):
                return Image(uiImage: image)
                    .aspectRatio(image.size)
                    .frame(maxWidth: 300)
            }
        }()
        return ZStack(alignment: .bottomLeading) {[
            Renctangle().size(width: 20, height: 20).fill(self.incomingMessageBgColor),
            VStack(alignment: .leading, spacing: 4.0) {[
                Text(message.from)
                    .font(Font.system(size: 12, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white),
                content,
                Text(message.dateString)
                    .font(Font.italicSystemFont(ofSize: 10))
                    .foregroundColor(.white)
            ]}
            .padding(8)
            .frame(minWidth: 150)
            .background(self.incomingMessageBgColor)
            .cornerRadius(8.0)
            .contentHuggingPriority(.defaultHigh)
        ]}
        .padding(8)
    }

    private func outcomingMessage(_ message: Message) -> View {
        let content: View = {
            switch message.content {
            case .text(let text):
                return Text(text)
                    .font(Font.system(size: 14))
                    .multilineTextAlignment(.leading)
            case .image(let image):
                return Image(uiImage: image)
                    .aspectRatio(image.size)
                    .frame(maxWidth: 300)
            }
        }()
        return ZStack(alignment: .bottomTrailing) {[
            Renctangle().size(width: 20, height: 20).fill(self.outcomingMessageBgColor),
            VStack(alignment: .fill, spacing: 4.0) {[
                Text(message.from)
                    .font(Font.system(size: 12, weight: .semibold))
                    .multilineTextAlignment(.leading),
                content,
                Text(message.dateString)
                    .font(Font.italicSystemFont(ofSize: 10))
                    .multilineTextAlignment(.trailing)
            ]}
            .padding(8)
            .frame(minWidth: 150)
            .background(self.outcomingMessageBgColor)
            .cornerRadius(8.0)
        ]}
        .padding(8)
    }
}

enum MessageType {
    case incoming, outcoming
}

struct Message {

    enum Content {
        case text(String)
        case image(UIImage)
    }

    let type: MessageType
    let from: String
    let content: Content
    let date: Date

    var dateString: String {
        return DateFormatter.shared.string(from: self.date)
    }
}

extension DateFormatter {
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
