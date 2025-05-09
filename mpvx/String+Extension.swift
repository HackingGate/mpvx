extension String {
    func truncatedFilename(to maxLength: Int) -> String {
        guard self.count > maxLength else { return self }

        let components = self.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)

        // If there's no extension, truncate the entire string
        guard let baseName = components.first else { return self }
        if components.count == 1 {
            return String(baseName.prefix(maxLength))
        }

        // Handle filenames with extensions
        let extensionName = components.last ?? ""
        let allowedBaseLength = maxLength - extensionName.count - 1
        let truncatedBaseName = String(baseName.prefix(max(allowedBaseLength, 0)))
        return truncatedBaseName + "." + extensionName
    }
}
