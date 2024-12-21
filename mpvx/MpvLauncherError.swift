import Foundation

struct MpvLauncherErrorStrings {
    static let mpvPathNotFoundDescription = "mpv executable path not found."
    static let mpvAlreadyRunningDescription = "mpv is currently running."
    static let mpvPathNotFoundReason = "The path to the mpv executable could not be located."
    static let mpvAlreadyRunningReason = "Another instance of mpv is currently playing."
    static let mpvPathNotFoundSuggestion = "Please verify the mpv installation and update the executable path."
    static let mpvAlreadyRunningSuggestion = "Please close the current playing instance of mpv and try again."
    static let mpvPathNotFoundHelpAnchor = "mpvPathNotFoundHelp"
    static let mpvAlreadyRunningHelpAnchor = "mpvAlreadyRunningHelp"
}

enum MpvLauncherError: Error {
    case mpvPathNotFound
    case mpvAlreadyRunning

    private var description: String {
        switch self {
        case .mpvPathNotFound:
            return MpvLauncherErrorStrings.mpvPathNotFoundDescription
        case .mpvAlreadyRunning:
            return MpvLauncherErrorStrings.mpvAlreadyRunningDescription
        }
    }

    private var reason: String {
        switch self {
        case .mpvPathNotFound:
            return MpvLauncherErrorStrings.mpvPathNotFoundReason
        case .mpvAlreadyRunning:
            return MpvLauncherErrorStrings.mpvAlreadyRunningReason
        }
    }

    private var suggestion: String {
        switch self {
        case .mpvPathNotFound:
            return MpvLauncherErrorStrings.mpvPathNotFoundSuggestion
        case .mpvAlreadyRunning:
            return MpvLauncherErrorStrings.mpvAlreadyRunningSuggestion
        }
    }

    private var helpAnchorText: String {
        switch self {
        case .mpvPathNotFound:
            return MpvLauncherErrorStrings.mpvPathNotFoundHelpAnchor
        case .mpvAlreadyRunning:
            return MpvLauncherErrorStrings.mpvAlreadyRunningHelpAnchor
        }
    }
}

extension MpvLauncherError: LocalizedError {
    var errorDescription: String? {
        NSLocalizedString(description, comment: "Error description for \(description)")
    }

    var failureReason: String? {
        NSLocalizedString(reason, comment: "Failure reason for \(description)")
    }

    var recoverySuggestion: String? {
        NSLocalizedString(suggestion, comment: "Recovery suggestion for \(description)")
    }

    var helpAnchor: String? {
        NSLocalizedString(helpAnchorText, comment: "Help anchor for \(description)")
    }
}
