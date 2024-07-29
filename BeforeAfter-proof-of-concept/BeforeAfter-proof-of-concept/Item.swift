import SwiftUI

struct Item: Identifiable {
    var id = UUID()
    let imageBefore: ImageResource
    let imageAfter: ImageResource
    
    static let mock: [Item] = [
        Item(imageBefore: .man1Before, imageAfter: .man1After),
        Item(imageBefore: .woman1Before, imageAfter: .woman1After),
        Item(imageBefore: .woman2Before, imageAfter: .woman2After)
    ]
}
