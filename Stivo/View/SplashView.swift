//
//  ContentView.swift
//  stivo
//
//  Created by s on 16/08/1447 AH.
//

import SwiftUI
import AVKit

struct VideoBackground: UIViewRepresentable {
    let videoName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            return view
        }
        let player = AVPlayer(url: url)
        player.isMuted = true
        player.play()
        player.actionAtItemEnd = .none
        
        // Loop the video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        
        DispatchQueue.main.async {
            if let window = view.window {
                layer.frame = window.bounds
            } else {
                layer.frame = view.bounds
            }
        }
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            layer.frame = uiView.bounds
        }
    }
}

struct SplashView: View {
    @State private var showMain = false
    @StateObject private var dashboardVM = DashboardViewModel()
    
    var body: some View {
        ZStack {
            VideoBackground(videoName: "bk")
                .ignoresSafeArea()
                .opacity(showMain ? 0 : 1)
                .animation(.easeInOut(duration: 0.4), value: showMain)
            
            if showMain {
                MainDashboardView()
                    .environmentObject(dashboardVM)
                    .transition(.opacity)
            }
        }
        .onAppear {
            // انتقل بعد 2 ثانية. يمكنك تعديلها حسب رغبتك.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    showMain = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

#Preview {
    SplashView()
}
