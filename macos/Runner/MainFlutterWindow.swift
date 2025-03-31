import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame // Pobiera domyślny rozmiar okna
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Ustawienie minimalnego i maksymalnego rozmiaru na aktualny rozmiar okna
    self.minSize = windowFrame.size
    self.maxSize = windowFrame.size
    
    // Usunięcie możliwości zmiany rozmiaru
    self.styleMask.remove(.resizable)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}