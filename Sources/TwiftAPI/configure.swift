import Vapor

let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin: .all,
    allowedMethods: [.GET],
    allowedHeaders: [.authorization, .origin, .accessControlAllowOrigin, .contentType, .accept]
)

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.middleware.use(CORSMiddleware(configuration: corsConfiguration), at: .beginning)

    // register routes
    try routes(app)
}
