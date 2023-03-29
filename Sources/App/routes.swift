import Vapor
import TelegramVaporBot

func routes(_ app: Application, _ connection: TGWebHookConnection) throws {
    try app.register(collection: TelegramController(connection: connection))
}

final class TelegramController: RouteCollection {
    
    private let connection: TGWebHookConnection
    
    init(connection: TGWebHookConnection) {
        self.connection = connection
    }
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.get(PathComponent(stringLiteral: EndPoint.tgWebHook.description), use: telegramWebHook)
    }
    
    func telegramWebHook(_ req: Request) async throws -> Bool {
        let update: TGUpdate = try req.content.decode(TGUpdate.self)
        
        try await connection.dispatcher.process([update])
        
        return true
    }
}
