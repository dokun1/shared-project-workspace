import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import EmojiJournalCore

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
        router.get("/entries", handler: getAllEntries)
    }
  
    func getAllEntries(completion: @escaping ([JournalEntry]?, RequestError?) -> Void) {
        let entries = [JournalEntry(emoji: "😂"), JournalEntry(emoji: "😎")]
        completion(entries, nil)
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
