import Foundation

protocol MpvPathProviding {
    func mpvInstallPath() -> String?
}

struct MpvPathProvider: MpvPathProviding {
    public let primaryHomebrewMpvBinaryPath = "/opt/homebrew/bin/mpv"
    public let secondaryHomebrewMpvBinaryPath = "/usr/local/bin/mpv"

    let customMpvPath: String?
    init() {
        self.customMpvPath = nil
    }
    init(customMpvPath: String?) {
        self.customMpvPath = customMpvPath
    }
    func mpvInstallPath() -> String? {
        if let customMpvPath = customMpvPath {
            if FileManager.default.fileExists(atPath: customMpvPath) {
                return customMpvPath
            } else {
                return nil
            }
        }
        if FileManager.default.fileExists(atPath: primaryHomebrewMpvBinaryPath) {
            return primaryHomebrewMpvBinaryPath
        } else if FileManager.default.fileExists(atPath: secondaryHomebrewMpvBinaryPath) {
            return secondaryHomebrewMpvBinaryPath
        } else {
            return nil
        }
    }
}
