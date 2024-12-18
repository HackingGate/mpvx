import Foundation

protocol FileExistenceChecking {
    func fileExists(atPath path: String) -> Bool
}

extension FileManager: FileExistenceChecking {}

protocol MpvPathProviding {
    func mpvInstallPath() -> String?
}

struct MpvPathProvider: MpvPathProviding {
    let primaryHomebrewMpvBinaryPath = "/opt/homebrew/bin/mpv"
    let secondaryHomebrewMpvBinaryPath = "/usr/local/bin/mpv"

    private let fileChecker: FileExistenceChecking
    private let customMpvPath: String?

    init(customMpvPath: String? = nil, fileChecker: FileExistenceChecking = FileManager.default) {
        self.customMpvPath = customMpvPath
        self.fileChecker = fileChecker
    }

    internal func mpvInstallPath() -> String? {
        if let customMpvPath = customMpvPath {
            return fileChecker.fileExists(atPath: customMpvPath) ? customMpvPath : nil
        }
        if fileChecker.fileExists(atPath: primaryHomebrewMpvBinaryPath) {
            return primaryHomebrewMpvBinaryPath
        }
        if fileChecker.fileExists(atPath: secondaryHomebrewMpvBinaryPath) {
            return secondaryHomebrewMpvBinaryPath
        }
        return nil
    }
}
