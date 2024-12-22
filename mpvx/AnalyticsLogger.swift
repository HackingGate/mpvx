import Cocoa
import FirebaseAnalytics

struct AnalyticsLogger {
    enum Event: String {
        case displayOpenPanel = "display_open_panel"
        case menuOpenClicked = "menu_open_clicked"
        case mpvxRepoOpened = "mpvx_repo_opened"
        case mpvManualOpened = "mpv_manual_opened"
        case panelCompletion = "panel_completion"
        case openUrl = "open_url"
        case mpvLaunchError = "mpv_launch_error"
        case mpvLauncherError = "mpv_launcher_error"
        case genericAlertShown = "generic_alert_shown"
        case mpvLaunchResult = "mpv_launch_result"
        case recentDocumentAdded = "recent_document_added"
        case appOpen = "app_open"
        case appBecameActive = "app_became_active"
        case appReopened = "app_reopened"
        case appTerminated = "app_terminated"
        case alertResponse = "alert_response"
    }

    enum Parameter: String {
        case sender
        case url
        case response
        case urlCount = "url_count"
        case errorDescription = "error_description"
        case errorType = "error_type"
        case message
        case description
        case hasVisibleWindows = "has_visible_windows"
        case result
        case urlPath = "url_path"
    }

    static func logEvent(_ event: Event, parameters: [Parameter: Any]? = nil) {
        let transformedParameters = parameters?.reduce(into: [String: Any]()) { result, parameter in
            result[parameter.key.rawValue] = parameter.value
        }
        Analytics.logEvent(event.rawValue, parameters: transformedParameters)
    }
}
