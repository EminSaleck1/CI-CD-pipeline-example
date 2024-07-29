import SwiftUI

struct DetailsView: View {
    let item: Item
    @Binding var isExpanded: Bool
    @State private var isShaking: Bool = false
    @State private var animationProgress: CGFloat = 0.5
    @State private var shakeCount: Int = 0
    @State private var shakeOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0

    let size: CGFloat = 350
    let completion: () -> Void
    
    var body: some View {
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
                                .frame(width: geometry.size.width * animationProgress)
                                .offset(x: geometry.size.width * (1 - animationProgress))
                        }
                    )
                    .clipShape(.rect(cornerRadius: 20))
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 10)
                    .overlay {
                        Image(uiImage: .checkmark)
                    }
                    .offset(x: -(size * animationProgress - (size / 2)) + shakeOffset)
                
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isShaking = false
                                let newOffset = gesture.translation.width + dragOffset
                                animationProgress = (-newOffset / size) + 0.5
                                animationProgress = min(max(animationProgress, 0.025), 0.95)
                            }
                            .onEnded { gesture in
                                dragOffset = gesture.translation.width + dragOffset
                                dragOffset = min(max(dragOffset, -size/2), size/2)
                            }
                    )
            }
            .frame(width: size, height: size)
            .clipShape(.rect(cornerRadius: 20))
            .clipped()
        }
        .padding()
        .onAppear(perform: startShaking)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                completion()
            }, label: {
               Text("CLOSE")
                    .foregroundStyle(.white)
            })
        }
    }
    
    private func startShaking() {
        isShaking = true
        shakeAnimation()
    }
    
    private func shakeAnimation() {
        guard isShaking else { return }
        
        withAnimation(Animation.easeInOut(duration: 0.3)) {
            shakeOffset = shakeCount % 2 == 0 ? 5 : -5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            shakeCount += 1
            if shakeCount < 6 {
                shakeAnimation()
            } else {
                isShaking = false
            }
        }
    }
}
