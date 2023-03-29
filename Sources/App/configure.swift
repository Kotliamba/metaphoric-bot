import Vapor
import TelegramVaporBot

enum EndPoint {
    case tgWebHook
    
    var description: String {
        switch self {
        case .tgWebHook:
            return "telegramWebHook"
        }
    }
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    guard
        let apiKey = Environment.get("API_KEY"),
        let hostName = Environment.get("HOST_NAME")
    else {
        return
    }
    
    app.http.server.configuration.hostname = "http://195.133.48.73"
    
    TGBot.log.logLevel = .error
    
    let bot = TGBot(app: app, botId: apiKey)
    let webHookURI = URI(string: hostName + "/" + EndPoint.tgWebHook.description)
    let connection = TGWebHookConnection(bot: bot, webHookURL: webHookURI)
    
    Task {
        await DefaultBotHandlers.addHandlers(app: app, connection: connection)
        try await connection.start()
    }
    
    try routes(app, connection)
}
