import Foundation

protocol FileExistenceChecking {
    func fileExists(atPath path: String) -> Bool
    func isReadableFile(atPath path: String) -> Bool
}

extension FileManager: FileExistenceChecking {}

protocol MpvPathProviding {
    func mpvExecutableURL() -> URL?
}

struct MpvPathProvider: MpvPathProviding {
    private let primaryHomebrewMpvExecutableURL = URL(fileURLWithPath: "/opt/homebrew/bin/mpv")
    private let secondaryHomebrewMpvExecutableURL = URL(fileURLWithPath: "/usr/local/bin/mpv")

    private let fileChecker: FileExistenceChecking
    private let customMpvPath: String?

    init(customMpvPath: String? = nil, fileChecker: FileExistenceChecking = FileManager.default) {
        self.customMpvPath = customMpvPath
        self.fileChecker = fileChecker
    }

    internal func mpvExecutableURL() -> URL? {
        if let customLaunchPath = customMpvPath {
            let customExecutableURL = URL(fileURLWithPath: customLaunchPath)
            return fileChecker.fileExists(atPath: customExecutableURL.path()) ? customExecutableURL : nil
        }
        if fileChecker.isReadableFile(atPath: primaryHomebrewMpvExecutableURL.path()) {
            return primaryHomebrewMpvExecutableURL
        }
        if fileChecker.fileExists(atPath: secondaryHomebrewMpvExecutableURL.path()) {
            return secondaryHomebrewMpvExecutableURL
        }
        return nil
    }
}
