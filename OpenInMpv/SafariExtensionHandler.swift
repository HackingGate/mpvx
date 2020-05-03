//
//  SafariExtensionHandler.swift
//  OpenInMpv
//
//  Created by HG on 2020/05/03.
//  Copyright © 2020 HG. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    override func toolbarItemClicked(in window: SFSafariWindow) {
        window.getActiveTab {
            $0?.getActivePage {
                $0?.getPropertiesWithCompletionHandler {
                    $0?.url.flatMap {
                        self.launchMpv([$0.absoluteString])
                    }
                }
            }
        }
    }

    func launchMpv(_ args: [String]) {
        let task = Process()
        task.launchPath = "/usr/local/bin/mpv"
        task.arguments = args
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
    }
}
