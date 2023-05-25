import SwiftUI
import WebKit
import AVFoundation

struct MyWebView: UIViewRepresentable {
    let urlToLoad: String
    let webView = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: urlToLoad) else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var permissionManager = PermissionManager()

    var body: some View {
        NavigationView {
            VStack {
                Button("Request Microphone Permission") {
                    permissionManager.requestAudioPermission()
                }
                .padding()

                NavigationLink(destination: MyWebView(urlToLoad: "https://dev-app.tutoring.co.kr/new_class?key=c3Qwbk4rMHNkK2VCUmplNjQvbGRoZz09&params=eyJ0X2lkeCI6MjM4OTI3OCwidG9waWNfaWR4Ijo2NywiY3B0X2lkeCI6NzQ1NjE0NCwidF90eXBlIjoiQyJ9")) {
                    Text("Open WebView")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error.localizedDescription)")
        }

        return true
    }
}

class PermissionManager: ObservableObject {
    func requestAudioPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Microphone permission granted")
            } else {
                print("Microphone permission denied")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
