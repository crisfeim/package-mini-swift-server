//  © 2025  Cristian Felipe Patiño Rojas. Created on 16/6/25.

import Foundation

public struct Server {
    public typealias RequestHandler = (Request) -> Response
    let port: UInt16
    let requestHandler: RequestHandler

    public init(port: UInt16, requestHandler: @escaping RequestHandler) {
        self.port = port
        self.requestHandler = requestHandler
    }
    
    public func run() {
        
        let _socket = socket(AF_INET, SOCK_STREAM, 0)
        guard _socket >= 0 else {
            fatalError("Unable to create socket")
        }
        
        var value: Int32 = 1
        setsockopt(_socket, SOL_SOCKET, SO_REUSEADDR, &value, socklen_t(MemoryLayout<Int32>.size))
        
        var serverAddress = sockaddr_in()
        serverAddress.sin_family = sa_family_t(AF_INET)
        serverAddress.sin_port = in_port_t(port).bigEndian
        serverAddress.sin_addr = in_addr(s_addr: INADDR_ANY)
        
        let bindResult = withUnsafePointer(to: &serverAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                bind(_socket, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        guard bindResult >= 0 else {
            fatalError("Error on socket launch.")
        }
        
        guard listen(_socket, 10) >= 0 else {
            fatalError("Error on socket listning.")
        }
        
        print("Server listening on port \(port)...")
        
        while true {
            var clientAddress = sockaddr_in()
            var clientAddressLength = socklen_t(MemoryLayout<sockaddr_in>.size)
            let clientSocket = withUnsafeMutablePointer(to: &clientAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    accept(_socket, $0, &clientAddressLength)
                }
            }
            
            guard clientSocket >= 0 else {
                print("Error on connxion")
                continue
            }
            
            var buffer = [UInt8](repeating: 0, count: 1024)
            let bytesRead = read(clientSocket, &buffer, 1024)
            
            guard bytesRead > 0 else {
                print("Unable to read data")
                close(clientSocket)
                continue
            }
            
            do {
                
                let request = try Request(buffer)
                let response = requestHandler(request)
                
                let headersAndBody = response.toHTTPResponse()
                
                    write(clientSocket, headersAndBody, headersAndBody.utf8.count)
                
                    if let binaryData = response.binaryData {
                        _ = binaryData.withUnsafeBytes { bytes in
                            write(clientSocket, bytes.baseAddress!, binaryData.count)
                        }
                    }
                
                
                if response.statusCode != 200 {
                    print("Failed response at \(request.path):")
                    print(response)
                }
                
                close(clientSocket)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    enum ServerError: Error {
        case noEndpointFound(String)
        
        var message: String {
            switch self {
                case .noEndpointFound(let path): return "No endpoint found for \(path)"
            }
        }
    }
}



