import Network
import Combine

class NetworkMonitor: ObservableObject {
    @Published var isWiFiConnected: Bool = false
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor_L")
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let isWiFiConnected = path.usesInterfaceType(.wifi)
                self?.isWiFiConnected = isWiFiConnected
                // Inform any observers or call the necessary completion handler here
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
    
    func checkWiFiConnection(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            // Check the current path status immediately
            let isWiFiConnected = self.monitor.currentPath.usesInterfaceType(.wifi)
            DispatchQueue.main.async {
                self.isWiFiConnected = isWiFiConnected
                completion(isWiFiConnected)
            }
        }
    }
}
