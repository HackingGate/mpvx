import Foundation

enum MpvLauncherError: Error {
    case mpvPathNotFound
    case mpvAlreadyRunning
}

extension MpvLauncherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .mpvPathNotFound:
            return NSLocalizedString("MPV executable path not found.", comment: "Error when MPV's path is missing or invalid.")
        case .mpvAlreadyRunning:
            return NSLocalizedString("MPV is already running.", comment: "Error when MPV is launched more than once.")
        }
    }

    var failureReason: String? {
        switch self {
        case .mpvPathNotFound:
            return NSLocalizedString("The path to the MPV executable could not be located.", comment: "Explanation for missing MPV path.")
        case .mpvAlreadyRunning:
            return NSLocalizedString("Another instance of MPV is still active.", comment: "Explanation why MPV can't run.")
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .mpvPathNotFound:
            return NSLocalizedString("Please verify the MPV installation and update the executable path.", comment: "Suggested action for resolving the missing path issue.")
        case .mpvAlreadyRunning:
            return NSLocalizedString("Please close the existing MPV instance and try again.", comment: "Suggested action for user.")
        }
    }

    var helpAnchor: String? {
        switch self {
        case .mpvPathNotFound:
            return NSLocalizedString("mpvPathNotFoundHelp", comment: "Help anchor for more information on fixing the MPV path.")
        case .mpvAlreadyRunning:
            return NSLocalizedString("mpvAlreadyRunningHelp", comment: "Help anchor for more information.")
        }
    }
}
