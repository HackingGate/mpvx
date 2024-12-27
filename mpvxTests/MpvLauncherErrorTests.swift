import Testing
@testable import mpvx

struct MpvLauncherErrorTests {
    @Test func testErrorDescription() async throws {
        let alreadyRunningError = MpvLauncherError.mpvAlreadyRunning
        #expect(alreadyRunningError.localizedDescription == MpvLauncherErrorStrings.mpvAlreadyRunningDescription, "Expected description for mpvAlreadyRunning doesn't match")
        
        let pathNotFoundError = MpvLauncherError.mpvPathNotFound
        #expect(pathNotFoundError.localizedDescription == MpvLauncherErrorStrings.mpvPathNotFoundDescription, "Expected description for mpvPathNotFound doesn't match")
    }

    @Test func testFailureReason() async throws {
        let alreadyRunningError = MpvLauncherError.mpvAlreadyRunning
        #expect(alreadyRunningError.failureReason == MpvLauncherErrorStrings.mpvAlreadyRunningReason, "Expected failure reason for mpvAlreadyRunning doesn't match")
        
        let pathNotFoundError = MpvLauncherError.mpvPathNotFound
        #expect(pathNotFoundError.failureReason == MpvLauncherErrorStrings.mpvPathNotFoundReason, "Expected failure reason for mpvPathNotFound doesn't match")
    }

    @Test func testRecoverySuggestion() async throws {
        let alreadyRunningError = MpvLauncherError.mpvAlreadyRunning
        #expect(alreadyRunningError.recoverySuggestion == MpvLauncherErrorStrings.mpvAlreadyRunningSuggestion, "Expected recovery suggestion for mpvAlreadyRunning doesn't match")
        
        let pathNotFoundError = MpvLauncherError.mpvPathNotFound
        #expect(pathNotFoundError.recoverySuggestion == MpvLauncherErrorStrings.mpvPathNotFoundSuggestion, "Expected recovery suggestion for mpvPathNotFound doesn't match")
    }

    @Test func testHelpAnchor() async throws {
        let alreadyRunningError = MpvLauncherError.mpvAlreadyRunning
        #expect(alreadyRunningError.helpAnchor == MpvLauncherErrorStrings.mpvAlreadyRunningHelpAnchor, "Expected help anchor for mpvAlreadyRunning doesn't match")
        
        let pathNotFoundError = MpvLauncherError.mpvPathNotFound
        #expect(pathNotFoundError.helpAnchor == MpvLauncherErrorStrings.mpvPathNotFoundHelpAnchor, "Expected help anchor for mpvPathNotFound doesn't match")
    }
}
