import Foundation

/// Saves and loads MicroFreak parameter snapshots as JSON. Stored in app support.
enum PresetStore {
    private static let fileExtension = "mfpreset"
    private static let presetListKey = "MicroFreakEditor.presetNames"

    static var presetDirectory: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("MicroFreakEditor", isDirectory: true)
    }

    static func ensureDirectory() {
        try? FileManager.default.createDirectory(at: presetDirectory, withIntermediateDirectories: true)
    }

    /// List of saved preset names (order preserved).
    static func listPresetNames() -> [String] {
        (UserDefaults.standard.array(forKey: presetListKey) as? [String]) ?? []
    }

    static func save(_ model: MicroFreakModel, name: String) throws {
        ensureDirectory()
        let data = try JSONEncoder().encode(model.values)
        let url = presetDirectory.appendingPathComponent("\(name.sanitizedFileName).\(fileExtension)")
        try data.write(to: url)
        var names = listPresetNames()
        if !names.contains(name) {
            names.append(name)
            UserDefaults.standard.set(names, forKey: presetListKey)
        }
    }

    static func load(name: String) throws -> MicroFreakModel? {
        let url = presetDirectory.appendingPathComponent("\(name.sanitizedFileName).\(fileExtension)")
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        let values = try JSONDecoder().decode([String: Double].self, from: data)
        // Merge with defaults so new params get default values
        var merged: [String: Double] = [:]
        for p in ParameterRegistry.all {
            merged[p.id] = values[p.id] ?? p.defaultValue
        }
        return MicroFreakModel(values: merged)
    }

    static func delete(name: String) throws {
        let url = presetDirectory.appendingPathComponent("\(name.sanitizedFileName).\(fileExtension)")
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
        var names = listPresetNames()
        names.removeAll { $0 == name }
        UserDefaults.standard.set(names, forKey: presetListKey)
    }
}

private extension String {
    var sanitizedFileName: String {
        String(unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) || $0 == " " || $0 == "-" })
            .replacingOccurrences(of: " ", with: "_")
    }
}

