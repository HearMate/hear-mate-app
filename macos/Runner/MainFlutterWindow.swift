import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let aspectRatio: CGFloat = 1512.0 / 982.0
    let newWidth: CGFloat = 1200.0
    let newHeight: CGFloat = newWidth / aspectRatio
    let windowFrame = NSRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newWidth, height: newHeight)
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // // Ustawienie minimalnego i maksymalnego rozmiaru na aktualny rozmiar okna
    // self.minSize = windowFrame.size
    // self.maxSize = windowFrame.size
    
    // // Usunięcie możliwości zmiany rozmiaru
    // self.styleMask.remove(.resizable)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}