import ReplayKit

class BroadcastSetupViewController: UIViewController {

  // MARK: Replace These Values
  let broadcastName = "My Recording"
  let myErrorDomain = "My Error Domain"

  private let fileManager: FileManager = .default

  override func viewDidAppear(_ animated: Bool) {
    userDidFinishSetup()
  }

  // Call this method when the user has finished interacting with the view controller and a broadcast stream can start
  func userDidFinishSetup() {
    // URL of the resource where broadcast can be viewed that will be returned to the application
    let broadcastURL = fileManager.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(for: .mpeg4Movie)

    // Dictionary with setup information that will be provided to broadcast extension when broadcast is started
    let setupInfo: [String : NSCoding & NSObjectProtocol] = ["broadcastName": broadcastName as NSCoding & NSObjectProtocol]

    // Tell ReplayKit that the extension is finished setting up and can begin broadcasting
    self.extensionContext?.completeRequest(withBroadcast: broadcastURL, setupInfo: setupInfo)
  }

  func userDidCancelSetup() {
    let error = NSError(domain: myErrorDomain, code: -1, userInfo: nil)
    // Tell ReplayKit that the extension was cancelled by the user
    self.extensionContext?.cancelRequest(withError: error)
  }
}
