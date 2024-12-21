import Foundation

enum MpvLauncherError: Error {
    case mpvAlreadyRunning
}

extension MpvLauncherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .mpvAlreadyRunning:
            return NSLocalizedString("MPV is already running.", comment: "Error when MPV is launched more than once.")
        }
    }

    var failureReason: String? {
        switch self {
        case .mpvAlreadyRunning:
            return NSLocalizedString("Another instance of MPV is still active.", comment: "Explanation why MPV can't run.")
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .mpvAlreadyRunning:
            return NSLocalizedString("Please close the existing MPV instance and try again.", comment: "Suggested action for user.")
        }
    }

    var helpAnchor: String? {
        switch self {
        case .mpvAlreadyRunning:
            return NSLocalizedString("mpvAlreadyRunningHelp", comment: "Help anchor for more information.")
        }
    }
}
