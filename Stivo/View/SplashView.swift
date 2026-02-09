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
        
        let url = Bundle.main.url(forResource: videoName, withExtension: "mp4")!
        let player = AVPlayer(url: url)
        player.isMuted = true
        player.play()
        
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
    var body: some View {
        VideoBackground(videoName: "bk")
            .ignoresSafeArea()
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
