import Vapor
import TelegramVaporBot

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    
    app.http.server.configuration.hostname = "195.133.48.73"
    app.http.server.configuration.port = 80
    
    TGBot.log.logLevel = .error
    
    if let apiKey = Environment.get("API_KEY") {
        let bot = TGBot(app: app, botId: apiKey)
        
        let connection = TGLongPollingConnection(bot: bot)
        
        Task {
            await DefaultBotHandlers.addHandlers(app: app, connection: connection)
            try await connection.start()
        }
    }
    
    try routes(app)
}
