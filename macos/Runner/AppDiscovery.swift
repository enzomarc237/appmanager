import Foundation
import AppKit

class AppDiscovery {
    func getInstalledApplications() -> [[String: Any]] {
        var applications = [[String: Any]]()
        let fileManager = FileManager.default
        let applicationURLs = [
            "/Applications",
            "\(NSHomeDirectory())/Applications"
        ].compactMap { URL(fileURLWithPath: $0) }

        for url in applicationURLs {
            do {
                let appURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [.nameKey, .isDirectoryKey], options: .skipsHiddenFiles)
                for appURL in appURLs {
                    if appURL.pathExtension == "app" {
                        if let appData = getApplicationData(for: appURL) {
                            applications.append(appData)
                        }
                    }
                }
            } catch {
                print("Error scanning directory: \(error)")
            }
        }
        return applications
    }

    private func getApplicationData(for url: URL) -> [String: Any]? {
        let fileManager = FileManager.default
        guard let bundle = Bundle(url: url) else { return nil }
        guard let infoDict = bundle.infoDictionary else { return nil }

        let appName = infoDict["CFBundleName"] as? String ?? bundle.bundleURL.deletingPathExtension().lastPathComponent
        let bundleId = bundle.bundleIdentifier
        let path = url.path
        let isSystemApp = path.starts(with: "/System")

        var creationDate: Date?
        var modificationDate: Date?
        var lastLaunchedDate: Date?
        var fileSize: Int64 = 0

        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)
            creationDate = attributes[.creationDate] as? Date
            modificationDate = attributes[.modificationDate] as? Date
            fileSize = attributes[.size] as? Int64 ?? 0
        } catch {
            print("Error getting file attributes: \(error)")
        }

        if let mditem = MDItemCreate(allocator: nil, queryString: "kMDItemFSName == '\(url.lastPathComponent)'" as CFString),
           MDItemQueryExecute(mditem, .sync) {
            if MDItemQueryGetResultCount(mditem) > 0 {
                if let item = MDItemQueryGetResultAtIndex(mditem, 0) {
                    let mdItemRef = item as! MDItem
                    lastLaunchedDate = MDItemCopyAttribute(mdItemRef, kMDItemLastUsedDate) as? Date
                }
            }
        }


        return [
            "name": appName,
            "bundleId": bundleId ?? "",
            "path": path,
            "createdAt": Int((creationDate?.timeIntervalSince1970 ?? 0) * 1000),
            "modifiedAt": Int((modificationDate?.timeIntervalSince1970 ?? 0) * 1000),
            "lastLaunchedAt": Int((lastLaunchedDate?.timeIntervalSince1970 ?? 0) * 1000),
            "size": fileSize,
            "icon": getIcon(for: url)?.tiffRepresentation,
            "isSystemApp": isSystemApp
        ]
    }

    private func getIcon(for url: URL) -> NSImage? {
        if let values = try? url.resourceValues(forKeys: [.effectiveIconKey]) {
            return values.effectiveIcon as? NSImage
        }
        return nil
    }
}
