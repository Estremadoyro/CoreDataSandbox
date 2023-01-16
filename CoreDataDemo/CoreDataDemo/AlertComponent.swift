//
//  AlertComponent.swift
//  CoreDataDemo
//
//  Created by Leonardo  on 15/01/23.
//

import UIKit

/// As **AlertComponent** is a wrapper for **UIAalertController**, this class is meant to be **deallocated** after presenting the UIAlertController.
/// Therefore, attempting to capture it (**self**) in any closure executed, after the controller is being presented, is futile.
final class AlertComponent {
    typealias Callback = (UIAlertAction, [String]?) -> Void

    private(set) var alertController: UIAlertController

    init(title: String, msg: String, style: UIAlertController.Style) {
        self.alertController = UIAlertController(title: title,
                                                 message: msg,
                                                 preferredStyle: style)
    }

    // MARK: Methods
    func addAction(_ action: AlertAction, callback: Callback? = nil) {
        let alertAction = UIAlertAction(title: action.title, style: action.style) { [weak alertController] (alertAction) in
            let textFieldValues = alertController?.textFields?.compactMap { $0.text }
            callback?(alertAction, textFieldValues)
        }
        alertController.addAction(alertAction)
    }

    func addTextField() {
        alertController.addTextField()
    }

    func present(from controller: UIViewController, animated: Bool = true) {
        controller.present(alertController, animated: animated)
    }
}

extension AlertComponent {
    struct AlertAction {
        var title: String
        var style: UIAlertAction.Style
    }
}
