import Foundation
import UIKit
import WebKit
import CoreBluetooth
import PlaygroundSupport
import PlaygroundBluetooth

public class DroneViewController: UIViewController{

    let droneCommand: DroneCommand = DroneCommand()
    var droneConnection:DroneConnection = DroneConnection()
    var page:Int = 1

    var commandText: UITextView!
    var commandsForAssessment:[PlaygroundValue] = [PlaygroundValue]()
    var initialConstraints = [NSLayoutConstraint]()
    
    var btView:PlaygroundBluetoothConnectionView!
    var btViewConstraints = [NSLayoutConstraint]()
    let btViewDelegate = ConnectionViewDelegate()

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(_ page:Int = 1) {
        self.init(nibName: nil, bundle: nil)
        self.page = page
    }
    
    let lblNew = UILabel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
                
        // Setup Playground Bluetooth view
        btView = PlaygroundBluetoothConnectionView(centralManager: droneConnection.centralManager!)

        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        self.view.addSubview(label)
        
        
        btView.delegate = btViewDelegate
        btView.dataSource = btViewDelegate
        

        self.view.addSubview(btView)
        
        NSLayoutConstraint.activate([
            
            btView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            btView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            ])
    }


    public override func viewDidAppear(_ animated: Bool) { // Notifies the view controller that its view was added to a view hierarchy.
        super.viewDidAppear(animated)
        
    }
    
    public override func viewDidLayoutSubviews() { // Called to notify the view controller that its view has just laid out its subviews.
        super.viewDidLayoutSubviews()
        
    }



    public func processCommand(_ message: PlaygroundValue){
        commandText.text = "msg: \(message)"
        
    }
    
   

}

class ConnectionViewDelegate: PlaygroundBluetoothConnectionViewDelegate, PlaygroundBluetoothConnectionViewDataSource {
    
    // MARK: PlaygroundBluetoothConnectionViewDataSource
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView, itemForPeripheral peripheral: CBPeripheral, withAdvertisementData advertisementData: [String : Any]?) -> PlaygroundBluetoothConnectionView.Item {
        // Provide display information associated with a peripheral item.
        let name = peripheral.name ?? NSLocalizedString("Unknown Device", comment:"")
        let icon = UIImage(named: "DroneIcon")!
        let issueIcon = icon
        return PlaygroundBluetoothConnectionView.Item(name: name, icon: icon, issueIcon: issueIcon, firmwareStatus: nil, batteryLevel: nil)
    }
    
    // MARK: PlaygroundBluetoothConnectionView Delegate
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView, shouldDisplayDiscovered peripheral: CBPeripheral, withAdvertisementData advertisementData: [String : Any]?, rssi: Double) -> Bool {
        // Filter out peripheral items (optional)
        return true
    }
    
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView, titleFor state: PlaygroundBluetoothConnectionView.State) -> String {
        // Provide a localized title for the given state of the connection view.
        switch state {
        case .noConnection:
            return NSLocalizedString("Connect Drone", comment:"")
        case .connecting:
            return NSLocalizedString("Connecting Drone", comment:"")
        case .searchingForPeripherals:
            return NSLocalizedString("Searching for Drone", comment:"")
        case .selectingPeripherals:
            return NSLocalizedString("Select Drone", comment:"")
        case .connectedPeripheralFirmwareOutOfDate:
            return NSLocalizedString("Connect to a Different Drone", comment:"")
        }
    }
    
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView, firmwareUpdateInstructionsFor peripheral: CBPeripheral) -> String {
        // Provide firmware update instructions.
        return "Firmware update instructions here."
    }
}

 extension DroneViewController: PlaygroundLiveViewMessageHandler {
    
     public func liveViewMessageConnectionOpened() {

     }
    
     public func liveViewMessageConnectionClosed() {

     }
    
     public func receive(_ message: PlaygroundValue) {
            if case let .string(command) = message { // Commands
                droneCommand.sendDroneCommand(droneConnection, message)
                //processCommand(message)
            }
     }
    
     public func sendMessage(_ message: PlaygroundValue) { // Send message to Constants.swift

     }
 

}

