//
//  AlertConfig.swift
//  LoginProfileTestApp
//
//  Created by Bogdan Fartdinov on 27.08.2025.
//

import UIKit

struct AlertConfig {
    let title: String?
    let message: String?
    let style: UIAlertController.Style
    let actions: [AlertAction]
    
    init(
        title: String? = nil,
        message: String?,
        style: UIAlertController.Style = .alert,
        actions: [AlertAction]
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
    }
}

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: (() -> Void)?
    
    init(title: String, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}
