import Foundation
import SwiftUI

struct Message: Identifiable, Equatable {
    var id = UUID()
    var date = Date()
    let direction: Direction
    let kind: Kind
}

extension Message {
    enum Kind: Equatable {
        case text(String)
        case image(UIImage)
    }
    
    enum Direction: Equatable {
        case outgoing, incoming
    }
}
