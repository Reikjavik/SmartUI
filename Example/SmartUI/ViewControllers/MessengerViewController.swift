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
        .init(type: .incoming, from: "John", text: "Hello, how can I help you?", date: Date()),
        .init(type: .outcoming, from: "Me", text: "I am interested in buying a house and need some information", date: Date()),
        .init(type: .incoming, from: "John", text: "Yes, of course. What area are you interested in?", date: Date()),
        .init(type: .outcoming, from: "Me", text: "I am interested in Palo Alto", date: Date()),
        .init(type: .incoming, from: "John", text: "What size house would you like?", date: Date()),
        .init(type: .outcoming, from: "Me", text: "I need a medium-sized house with at least 4 bedrooms and 2 bathrooms.", date: Date())
    ])

    let incomingMessageBgColor = Color(UIColor(red: 10/255, green: 128/255, blue: 245/255, alpha: 1.0))
    let outcomingMessageBgColor = Color(UIColor(red: 216/255, green: 223/255, blue: 230/255, alpha: 1.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        ContainerView { [unowned self] in
            List(self.messages) { message in
                switch message.type {
                case .incoming:
                    return self.incomingMessage(message)
                case .outcoming:
                    return self.outcomingMessage(message)
                }
            }.separatorStyle(.none)
        }.layout(in: view)
    }

    private func incomingMessage(_ message: Message) -> View {
            ZStack(alignment: .bottomLeading) {[
                Renctangle().size(width: 20, height: 20).fill(self.incomingMessageBgColor),
                VStack(alignment: .leading, spacing: 4.0) {[
                    Text(message.from)
                        .font(Font.system(size: 12, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white),
                    Text(message.text)
                        .font(Font.system(size: 14))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white),
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
            ZStack(alignment: .bottomTrailing) {[
                Renctangle().size(width: 20, height: 20).fill(self.outcomingMessageBgColor),
                VStack(alignment: .fill, spacing: 4.0) {[
                    Text(message.from)
                        .font(Font.system(size: 12, weight: .semibold))
                        .multilineTextAlignment(.leading),
                    Text(message.text)
                        .font(Font.system(size: 14))
                        .multilineTextAlignment(.leading),
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
    let type: MessageType
    let from: String
    let text: String
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
