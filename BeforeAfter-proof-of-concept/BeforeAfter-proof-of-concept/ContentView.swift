import SwiftUI

struct ContentView: View {
    @State private var animationProgress2: CGFloat = 1.0
    @State private var isExpanded: Bool = false
    @Namespace private var animation
    let items = 1...10
    @State private var selected: Item?
    
    let rows = [
        GridItem(.fixed(150))
    ]
    
    var body: some View {
        ZStack {
                VStack {
                    ScrollView(.vertical) {
                        ForEach(0...4, id: \.self) { _ in
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: rows, alignment: .center) {
                                    ForEach(Item.mock, id: \.id) { item in
                                        changeViewAnimation(size: 150, item: item)
                                            .clipShape(.rect(cornerRadius: 20))
                                            .onTapGesture {
                                                withAnimation(.spring()) {
                                                    isExpanded = true
                                                    selected = item
                                                }
                                            }
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                }
        }
        .fullScreenCover(item: $selected) { item in
            DetailsView(item: item, isExpanded: $isExpanded, completion: {
                selected = nil
            })
        }
    }
    private func changeViewAnimation(size: CGFloat, item: Item) -> some View {
        VStack {
            ZStack {
                Image(item.imageBefore)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .clipShape(.rect(cornerRadius: 20))
                
                Image(item.imageAfter)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .mask(
                        GeometryReader { geometry in
                            Rectangle()
                                .frame(width: geometry.size.width * animationProgress2)
                                .offset(x: geometry.size.width * (1 - animationProgress2))
                        }
                    )
                    .clipShape(.rect(cornerRadius: 20))
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 5)
                    .offset(x: -(size * animationProgress2 - (size / 2)))
            }
            .frame(width: size, height: size)
            .clipShape(.rect(cornerRadius: 20))
        }
        .padding()
        .onAppear {
            withAnimation(Animation.timingCurve(0.9, 0.05, 0.05, 1.0, duration: 4).repeatForever(autoreverses: true)) {
                animationProgress2 = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
