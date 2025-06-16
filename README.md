# mini-swift-server

A tiny Swift HTTP server built with Foundation sockets.
Handles basic request parsing and response generation. Nothing fancy.

## Features

- Accepts HTTP `GET`, `POST`, `PATCH`, `PUT`, and `DELETE` requests.
- Parses basic request info: method, path, body.
- Supports plain text and binary responses.
- No dependencies outside of Foundation.
- Intended for simple, local use cases and quick prototyping.

## Usage

```swift
import MiniSwiftServer

let server = Server(port: 8080) { request in
    switch request.path {
    case "hello":
        return Response(statusCode: 200, contentType: "text/plain", body: .text("Hello, world!"))
    default:
        return Response(statusCode: 404, contentType: "text/plain", body: .text("Not Found"))
    }
}

server.run()
```

## Installation

Add via Swift Package Manager:

```swift
.package(url: "https://github.com/yourusername/mini-swift-server.git", branc: "main")
```

## Notes

- This is not production-ready. It’s not thread-safe and assumes small, simple payloads.
- Designed for learning or prototyping, not deployment.

## License
MIT

## Showcase

- [cli-swiftdown](https://github.com/crisfeim/cli-swiftdown)
