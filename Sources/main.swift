import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()

server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()

func handlerFunc(request: HTTPRequest, response: HTTPResponse) -> Void {
	response.appendBody(string: "Apros RestAPI Test root!").completed()
	print("Response, /")
}

routes.add(method: .get, uri: "/", handler: handlerFunc)

server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}

print("Hello, world!")
