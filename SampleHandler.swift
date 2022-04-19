import BroadcastWriter
import ReplayKit
import Photos

class SampleHandler: RPBroadcastSampleHandler {

  private var writer: BroadcastWriter?
  private let fileManager: FileManager = .default
  private let nodeURL: URL

  private let videoOutputFullFileName = "\(Date().timeIntervalSince1970)"

  override init() {
    print("🧩 Broadcast Sample Handler Created")
    nodeURL = fileManager.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(for: .mpeg4Movie)

    fileManager.removeFileIfExists(url: nodeURL)

    super.init()
  }

  override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
    let screen: UIScreen = .main
    do {
      writer = try .init(
        outputURL: nodeURL,
        screenSize: screen.bounds.size,
        screenScale: screen.scale
      )
    } catch {
      assertionFailure(error.localizedDescription)
      finishBroadcastWithError(error)
      return
    }
    do {
      try writer?.start()
    } catch {
      finishBroadcastWithError(error)
    }
  }

  override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
    guard let writer = writer else {
      debugPrint("processSampleBuffer: Writer is nil")
      return
    }

    do {
      let captured = try writer.processSampleBuffer(sampleBuffer, with: sampleBufferType)
      debugPrint("processSampleBuffer captured", captured)
    } catch {
      debugPrint("processSampleBuffer error:", error.localizedDescription)
    }
  }

  override func broadcastPaused() {
    debugPrint("=== paused")
    writer?.pause()
  }

  override func broadcastResumed() {
    debugPrint("=== resumed")
    writer?.resume()
  }

  override func broadcastFinished() {
    guard let writer = writer else {
      return
    }

    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    let outputURL: URL
    do {
      outputURL = try writer.finish()
    } catch {
      debugPrint("writer failure", error)
      dispatchGroup.leave()
      return
    }

    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
    }) { completed, error in
      if completed {
        print("🎥 Video \(self.videoOutputFullFileName) has been moved to camera roll")
      }

      if error != nil {
        print ("🧨 Cannot move the video \(self.videoOutputFullFileName) to camera roll, error: \(error!.localizedDescription)")
      }
      dispatchGroup.leave()
    }
    dispatchGroup.wait() // <= blocks the thread here
  }
}

extension FileManager {

  func removeFileIfExists(url: URL) {
    guard fileExists(atPath: url.path) else { return }
    do {
      try removeItem(at: url)
    } catch {
      print("error removing item \(url)", error)
    }
  }
}
