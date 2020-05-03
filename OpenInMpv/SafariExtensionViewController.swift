//
//  SafariExtensionViewController.swift
//  OpenInMpv
//
//  Created by HG on 2020/05/03.
//  Copyright © 2020 HG. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
