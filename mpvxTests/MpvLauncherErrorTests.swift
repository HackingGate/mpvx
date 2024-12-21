import Testing
@testable import mpvx

struct MpvLauncherErrorTests {
    
    @Test func testErrorDescription() async throws {
        let alreadyRunningError = MpvLauncherError.mpvAlreadyRunning
        #expect(alreadyRunningError.localizedDescription == "MPV is already running.", "Expected description for mpvAlreadyRunning doesn't match")
        
        let pathNotFoundError = MpvLauncherError.mpvPathNotFound
        #expect(pathNotFoundError.localizedDescription == "MPV executable path not found.", "Expected description for mpvPathNotFound doesn't match")
    }

    @Test func testFailureReason() async throws {
        let alreadyRunningError = MpvLauncherError.mpvAlreadyRunning
        #expect(alreadyRunningError.failureReason == "Another instance of MPV is still active.", "Expected failure reason for mpvAlreadyRunning doesn't match")
        
        let pathNotFoundError = MpvLauncherError.mpvPathNotFound
        #expect(pathNotFoundError.failureReason == "The path to the MPV executable could not be located.", "Expected failure reason for mpvPathNotFound doesn't match")
    }

    @Test func testRecoverySuggestion() async throws {
        let alreadyRunningError = MpvLauncherError.mpvAlreadyRunning
        #expect(alreadyRunningError.recoverySuggestion == "Please close the existing MPV instance and try again.", "Expected recovery suggestion for mpvAlreadyRunning doesn't match")
        
        let pathNotFoundError = MpvLauncherError.mpvPathNotFound
        #expect(pathNotFoundError.recoverySuggestion == "Please verify the MPV installation and update the executable path.", "Expected recovery suggestion for mpvPathNotFound doesn't match")
    }

    @Test func testHelpAnchor() async throws {
        let alreadyRunningError = MpvLauncherError.mpvAlreadyRunning
        #expect(alreadyRunningError.helpAnchor == "mpvAlreadyRunningHelp", "Expected help anchor for mpvAlreadyRunning doesn't match")
        
        let pathNotFoundError = MpvLauncherError.mpvPathNotFound
        #expect(pathNotFoundError.helpAnchor == "mpvPathNotFoundHelp", "Expected help anchor for mpvPathNotFound doesn't match")
    }
}
