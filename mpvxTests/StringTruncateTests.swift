import Testing
@testable import mpvx

struct StringTruncateTests {
    @Test func testShortFilename() async throws {
        let filename = "short.mp4"
        let result = filename.truncatedFilename(to: 100)
        #expect(result == "short.mp4", "Short filenames should not be truncated")
    }

    @Test func testExactLengthFilename() async throws {
        let filename = "12345678901234567890.mp4" // 20 + ".mp4" = 24 chars
        let result = filename.truncatedFilename(to: 24)
        #expect(result == "12345678901234567890.mp4", "Filenames exactly at max length should remain unchanged")
    }

    @Test func testLongFilename() async throws {
        let filename = "[Test-File] Example Movie Title With Very Long Name That Exceeds Limit.mp4"
        let result = filename.truncatedFilename(to: 50)
        #expect(result == "[Test-File] Example Movie Title With Very Long.mp4", "Long filenames should be truncated correctly")
    }

    @Test func testFilenameWithNoExtension() async throws {
        let filename = "averyverylongfilenamewithoutanyextension"
        let result = filename.truncatedFilename(to: 20)
        #expect(result == "averyverylongfilenam", "Filenames without extensions should be truncated")
    }

    @Test func testFilenameWithEdgeCaseLength() async throws {
        let filename = "filename.extension"
        let result = filename.truncatedFilename(to: 5)
        #expect(result == ".extension", "When truncating, keep the extension even if it exceeds maxLength")
    }

    @Test func testVeryLongFilename() async throws {
        let filename = String(repeating: "a", count: 96) + ".mp4" // Total length: 100
        let result = filename.truncatedFilename(to: 100)
        #expect(result == filename, "Filenames at 100 characters should not be truncated")

        let tooLongFilename = String(repeating: "a", count: 105) + ".mp4" // Total length: 109
        let truncatedResult = tooLongFilename.truncatedFilename(to: 100)
        #expect(truncatedResult == String(repeating: "a", count: 96) + ".mp4", "Filenames over 100 characters should be truncated to 100")
    }
}
