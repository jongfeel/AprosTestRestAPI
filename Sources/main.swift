import Foundation
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

routes.add(method: .get, uri: "/Status", handler: {
    request, response in
    
    let json : String = "{ " +
                        "\"Result\" : {" +
                                        "\"temperature\" : \"%f\", " +
                                        "\"electricCurrent\" : \"%f\", " +
                                        "\"oscillation\" : \"%f\", " +
                                        "\"status\" : \"%d\", " +
                                        "\"lifeExpect\" : \"%d\"" +
                                        "}, " +
                        "\"responseCode\" : \"1\" " +
                        "}"
    
    let temperature = Float.random(min: 20.0, max: 40.0)
    let electricCurrent = Float.random(min: 1.10, max: 1.20)
    let oscillation = Float.random(min: 1.0, max: 2.0)
    let status = Int(arc4random_uniform(2))
    let lifeExpect = Int(arc4random_uniform(2) + 11)
    
    let formatted = String(format: json, temperature, electricCurrent, oscillation, status, lifeExpect)
    
    //response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: formatted).completed()
    print("Response, /Status, \(formatted)")
})

server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
