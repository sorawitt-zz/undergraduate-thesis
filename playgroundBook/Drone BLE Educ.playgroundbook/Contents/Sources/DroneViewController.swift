import Foundation
import UIKit
import WebKit
import CoreBluetooth
import PlaygroundSupport
import PlaygroundBluetooth

public class DroneViewController: UIViewController {

    let robotCommand: DroneCommand = DroneCommand()
    var droneConnection:DroneConnection = DroneConnection()
    var page:Int = 1

    var commandsForAssessment:[PlaygroundValue] = [PlaygroundValue]()

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

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup robot connection callbacks
        droneConnection.onCharacteristicsDiscovered = onRobotConnected
        droneConnection.onDataWritten = onCommandCompleted
        droneConnection.onPeripheralNotFound = onRobotNotFound
        //droneConnection.onCharacteristicsUpdated0 = onSensorUpdated0
        //droneConnection.onCharacteristicsUpdated1 = onSensorUpdated1
        //droneConnection.onMyPrint = myPrint


        setupView()
    }


    public override func viewDidAppear(_ animated: Bool) { // Notifies the view controller that its view was added to a view hierarchy.
        super.viewDidAppear(animated)
        
    }
    
    public override func viewDidLayoutSubviews() { // Called to notify the view controller that its view has just laid out its subviews.
        super.viewDidLayoutSubviews()
        
    }


    func setupView(){

        
        // Setup commandText window
        commandText = UITextView(frame: CGRect(
            x: self.view.frame.width*5/100, y: self.view.frame.height*68/100,
            width: self.view.frame.width*89/200, height: self.view.frame.height*15/100))
        commandText.text = ""
        commandText.isEditable = false
        commandText.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0)
        commandText.textColor = #colorLiteral(red: 0.933, green: 0.443, blue: 0.137, alpha: 1)
        commandText.font = UIFont.init(name: "Avenir Next", size: 30)
        commandText.textAlignment = .center
        commandText.textContainer.lineBreakMode = .byWordWrapping
        self.view.addSubview(commandText)
        
        // Setup animation
        setCommandAnimation(CommandType.COMMAND_DISCONNECT.rawValue)
        
        // Setup Playground Bluetooth view
        btView = PlaygroundBluetoothConnectionView(centralManager: droneConnection.centralManager!)
        btView.delegate = btViewDelegate
        btView.dataSource = btViewDelegate
        self.view.addSubview(btView)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            self.droneConnection.centralManager!.connectToLastConnectedPeripheral()
        }

    }

    func onRobotConnected(peripheral: CBPeripheral){

    }
    
    func onRobotNotFound(){

    }
    
    func onCommandCompleted(){

    }

    var sensorType:String?
    var sensorValue:Bool = false
    var clapCount:UInt8 = 0;
    
    func resetSensorValues(){
        sensorType = nil
        sensorValue = false
        clapCount = 0
    }
    
    func onSensorUpdated0(_ data:Data){
       // handleWaitForCommand0(data)
    }
    
    func onSensorUpdated1(_ data:Data){

    }
    
    func handleWaitForCommand0(_ data:Data){

    }
    
    func handleWaitForCommand1(_ data:Data){

    }
    
    func handleSensorCommand1(_ data:Data){

    }
    
    func finishSensorCommand(_ sensor:String){

    }
    
    func addCommandToAssessmentArray(_ command:PlaygroundValue){
        if(self.commandsForAssessment.count <= 30){
            self.commandsForAssessment.append(command)
        }
    }
    
    func processCommand(_ command:PlaygroundValue){
        robotCommand.sendDroneCommand(droneConnection, command)
    }
    
    func processSensorCommand(_ command:PlaygroundValue){

    }
    
    func processWaitCommand(_ command:PlaygroundValue){
        robotCommand.sendDroneCommand(droneConnection, command)
    }
    
    func setCommandAnimationAsync(_ command:PlaygroundValue){
        // if case let .string(text) = command {
        //     setCommandAnimationAsync(text)
        // }
    }
    
    func setCommandAnimationAsync(_ command:CommandType){
        //setCommandAnimationAsync(command.rawValue)
    }
    
    var currentCommand:String = "";
    
    func setCommandAnimationAsync(_ text:String){

    }
    
    func setCommandAnimation(_ text:String){
        
    }
    
    func exitProgram(){

    }
}

class ConnectionViewDelegate: PlaygroundBluetoothConnectionViewDelegate, PlaygroundBluetoothConnectionViewDataSource {
    
    // MARK: PlaygroundBluetoothConnectionViewDataSource
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView, itemForPeripheral peripheral: CBPeripheral, withAdvertisementData advertisementData: [String : Any]?) -> PlaygroundBluetoothConnectionView.Item {
        // Provide display information associated with a peripheral item.
        let name = peripheral.name ?? NSLocalizedString("Unknown Device", comment:"")
        let icon = #imageLiteral(resourceName: "robotAvatar.png")
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
            return NSLocalizedString("Connect Dash", comment:"")
        case .connecting:
            return NSLocalizedString("Connecting Dash", comment:"")
        case .searchingForPeripherals:
            return NSLocalizedString("Searching for Dash", comment:"")
        case .selectingPeripherals:
            return NSLocalizedString("Select Dash", comment:"")
        case .connectedPeripheralFirmwareOutOfDate:
            return NSLocalizedString("Connect to a Different Dash", comment:"")
        }
    }
    
    public func connectionView(_ connectionView: PlaygroundBluetoothConnectionView, firmwareUpdateInstructionsFor peripheral: CBPeripheral) -> String {
        // Provide firmware update instructions.
        return "Firmware update instructions here."
    }
}

 extension DroneViewController: PlaygroundLiveViewMessageHandler {
    
     public func liveViewMessageConnectionOpened() {
//         self.log.text = ""
         isShowingResult = false
//         //myPrint("liveViewMessageConnectionOpened")
     }
    
     public func liveViewMessageConnectionClosed() {

     }
    
     public func receive(_ message: PlaygroundValue) {
            if case let .string(command) = message { // Commands

                processCommand(message)
            }
     }
    
     public func sendMessage(_ message: PlaygroundValue) { // Send message to Constants.swift

     }
 

}

