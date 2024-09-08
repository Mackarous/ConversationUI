import Foundation
import SwiftUI

public struct Message: Identifiable, Equatable {
    public var id = UUID()
    public var date = Date()
    public let direction: Direction
    public let kind: Kind
    
    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        direction: Direction,
        kind: Kind
    ) {
        self.id = id
        self.date = date
        self.direction = direction
        self.kind = kind
    }
}

public extension Message {
    enum Kind: Equatable {
        case text(String)
        case image(UIImage)
    }
    
    enum Direction: Equatable {
        case outgoing, incoming
    }
}
