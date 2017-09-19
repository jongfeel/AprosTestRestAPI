import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()

server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()

routes.add(method: .get, uri: "/", handler: {
	request, response in
	response.setBody(string: "Apros RestAPI Test root!").completed()
	print("Response, /")
})

server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}

print("Hello, world!")
