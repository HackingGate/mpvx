import XCTest
@testable import mpvx

final class MockFileChecker: FileExistenceChecking {
    var existingPaths: Set<String>

    init(existingPaths: Set<String> = []) {
        self.existingPaths = existingPaths
    }

    func fileExists(atPath path: String) -> Bool {
        return existingPaths.contains(path)
    }
    
    func isReadableFile(atPath path: String) -> Bool {
        return existingPaths.contains(path)
    }
}

final class MpvPathProviderTests: XCTestCase {
    func testCustomMpvPathExists() {
        let mockChecker = MockFileChecker(existingPaths: ["/tmp/custom_mpv"])
        let provider = MpvPathProvider(customMpvPath: "/tmp/custom_mpv", fileChecker: mockChecker)
        XCTAssertEqual(provider.mpvExecutableURL()?.path(), "/tmp/custom_mpv")
    }

    func testCustomMpvPathDoesNotExist() {
        let mockChecker = MockFileChecker()
        let provider = MpvPathProvider(customMpvPath: "/tmp/non_existent", fileChecker: mockChecker)
        XCTAssertNil(provider.mpvExecutableURL())
    }

    func testPrimaryMpvPathExists() {
        let mockChecker = MockFileChecker(existingPaths: ["/opt/homebrew/bin/mpv"])
        let provider = MpvPathProvider(fileChecker: mockChecker)
        XCTAssertEqual(provider.mpvExecutableURL()?.path(), "/opt/homebrew/bin/mpv")
    }

    func testSecondaryMpvPathExistsWhenPrimaryDoesNot() {
        let mockChecker = MockFileChecker(existingPaths: ["/usr/local/bin/mpv"])
        let provider = MpvPathProvider(fileChecker: mockChecker)
        XCTAssertEqual(provider.mpvExecutableURL()?.path(), "/usr/local/bin/mpv")
    }

    func testNoPathsExist() {
        let mockChecker = MockFileChecker()
        let provider = MpvPathProvider(fileChecker: mockChecker)
        XCTAssertNil(provider.mpvExecutableURL())
    }
}
