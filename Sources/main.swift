import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()

server.serverPort = 8080
server.documentRoot = "webroot"

let dateFormatter = DateFormatter()
dateFormatter.locale = Locale.current

func datetimeArray(dateFormat: Calendar.Component, min: Float, max: Float) -> String {
    var datetimes = ""
    
    var component = Calendar.current.component(dateFormat, from: Date())
    if (dateFormat == Calendar.Component.day) {
        component -= 1
    }
    
    for c in (0...component).reversed() {
        dateFormatter.dateFormat = dateFormat == Calendar.Component.day ? "yyyy-MM-dd" : "yyyy-MM-dd HH:mm:ss"
        let interval = dateFormat == Calendar.Component.day ? TimeInterval(-1 * c * 24 * 60 * 60) : TimeInterval(-1 * c * 60 * 60)
        let formattedDate = dateFormatter.string(from: Date().addingTimeInterval(interval))
        let value = Float.random(min: min, max: max)
        datetimes += "\t\t\t{ \"datetime\" : \"\(formattedDate)\", \"value\" : \"\(value)\" }," + "\r\n"
    }
    datetimes.remove(at: datetimes.index(datetimes.endIndex, offsetBy: -2))

    return datetimes
}

var routes = Routes()

func handlerFunc(request: HTTPRequest, response: HTTPResponse) -> Void {
	response.appendBody(string: "Apros RestAPI Test root!").completed()
	print("Response, /")
}

routes.add(method: .get, uri: "/", handler: handlerFunc)

routes.add(method: .get, uri: "/Status", handler: {
    request, response in
    
    let json : String = "{ " + "\r\n" +
                        "\t\"Result\" : { " + "\r\n" +
                                        "\t\t\"temperature\" : \"%f\", " + "\r\n" +
                                        "\t\t\"electricCurrent\" : \"%f\", " + "\r\n" +
                                        "\t\t\"oscillation\" : \"%f\", " + "\r\n" +
                                        "\t\t\"status\" : \"%d\", " + "\r\n" +
                                        "\t\t\"lifeExpect\" : \"%d\"" + "\r\n" +
                                        "\t }, " + "\r\n" +
                        "\t\"responseCode\" : \"1\" " + "\r\n" +
                        "}"
    
    let temperature = Float.random(min: 20.0, max: 40.0)
    let electricCurrent = Float.random(min: 1.10, max: 1.20)
    let oscillation = Float.random(min: 1.0, max: 2.0)
    let status = Int(arc4random_uniform(2))
    let lifeExpect = Int(arc4random_uniform(2) + 11)
    
    let formatted = String(format: json, temperature, electricCurrent, oscillation, status, lifeExpect)
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: formatted).completed()
    print("Response, /Status, \(formatted)")
})

routes.add(method: .get, uri: "/Temperature", handler: {
    request, response in
    
    let json : String = "{ " + "\r\n" +
                            "\t\"Result\" : { " + "\r\n" +
                                "\t\t\"daily\" : [ " + "\r\n" +
                                datetimeArray(dateFormat: .day, min: 20.0, max: 40.0) + "\r\n" +
                                "\t\t], " + "\r\n" +
                                "\t\t\"hourly\" : [ " + "\r\n" +
                                datetimeArray(dateFormat: .hour, min: 20.0, max: 40.0) + "\r\n" +
                                "\t\t]" + "\r\n" +
                            "\t}, " + "\r\n" +
                            "\t\"responseCode\" : \"1\" " + "\r\n" +
                        "}"
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: json).completed()
    print("Response, /Temperature, \(json)")
})

routes.add(method: .get, uri: "/ElectricCurrent", handler: {
    request, response in
    
    let json : String = "{ " + "\r\n" +
                            "\t\"Result\" : { " + "\r\n" +
                                "\t\t\"daily\" : [ " + "\r\n" +
                                    datetimeArray(dateFormat: .day, min: 1.1, max: 1.2) + "\r\n" +
                                "\t\t], " + "\r\n" +
                                "\t\t\"hourly\" : [ " + "\r\n" +
                                    datetimeArray(dateFormat: .hour, min: 1.1, max: 1.2) + "\r\n" +
                                "\t\t]" + "\r\n" +
                            "\t}, " + "\r\n" +
                            "\t\"responseCode\" : \"1\" " + "\r\n" +
                        "}"
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: json).completed()
    print("Response, /ElectricCurrent, \(json)")
})
server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
