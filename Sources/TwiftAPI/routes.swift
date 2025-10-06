import Vapor

let token = ProcessInfo.processInfo.environment["TWITCH_API_TOKEN"]!
let clientId = ProcessInfo.processInfo.environment["TWITCH_CLIENT_ID"]!

struct Wrapper: Codable {
    var data: [Stream]
}

struct Stream: Codable {
    var id: String
    var user_id: String
    var user_login: String
    var user_name: String
    var viewer_count: Int
}

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    app.get("viewcount", ":login") { req async throws -> Int in
        let login = try req.parameters.require("login")
        
        let response = try await req.client.get(URI(string: "https://api.twitch.tv/helix/streams")) { req in
            try req.query.encode(["user_login": login, "first": "1"])
            
            let auth = BearerAuthorization(token: token)
            req.headers.bearerAuthorization = auth
            
            req.headers.add(name: "Client-Id", value: clientId)
        }
        
        let wrapper = try response.content.decode(Wrapper.self)
        
        if (wrapper.data.isEmpty) {
            return -1
        }
        
        return wrapper.data[0].viewer_count
    }
}

