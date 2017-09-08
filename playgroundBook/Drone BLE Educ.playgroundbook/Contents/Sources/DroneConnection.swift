import PlaygroundBluetooth
import PlaygroundSupport
import Foundation
import CoreBluetooth

//let TRANSFER_SERVICE_UUID                           = "31C03FBD-072E-072E-47DE-A78B-DE10422B8AF3"
let TRANSFER_SERVICE_UUID                           = "FFE0"
let transferServiceUUID = CBUUID(string: TRANSFER_SERVICE_UUID)

public class DroneConnection: NSObject, PlaygroundBluetoothCentralManagerDelegate, CBPeripheralDelegate {

    public var centralManager: PlaygroundBluetoothCentralManager?
    private var discoveredPeripheral: CBPeripheral?
    private var discoveredPeripherals = [CBPeripheral]()
    private var commandCharacteristic: CBCharacteristic?


    public var onPeripheralDiscovered:(([CBPeripheral])->Void)?     // Found robot
    public var onPeripheralNotFound:(()->Void)?                     // Can't connect to robot
    public var onCharacteristicsDiscovered:((CBPeripheral)->Void)?  // Robot connected
    public var onDataWritten:(()->Void)?                            // Command sent

    public override init() {
        super.init()

        centralManager = PlaygroundBluetoothCentralManager(services: [transferServiceUUID], queue: .global())
        //centralManager = PlaygroundBluetoothCentralManager(services: nil, queue: .global())
        centralManager!.delegate = self
    }

    public func centralManagerStateDidChange(_ centralManager: PlaygroundBluetoothCentralManager) {

    }

    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager, didDiscover peripheral: CBPeripheral, withAdvertisementData advertisementData: [String : Any]?, rssi: Double)  {
        // // Handle peripheral discovery.
        // myPrint("Discovered \(peripheral.name) at \(rssi)")
    }
            
     public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager, willConnectTo peripheral: CBPeripheral) {
        // Handle peripheral connection attempts (prior to connection being made).
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager, didConnectTo peripheral: CBPeripheral) {
        //// Handle successful peripheral connection.
        //myPrint("Peripheral:\(peripheral.name) connected")
        peripheral.delegate = self                          // Make sure we get the discovery callbacks
        peripheral.discoverServices([transferServiceUUID])  // Search only for services that match our service UUID
        discoveredPeripheral = peripheral
    }

     public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager, didFailToConnectTo peripheral: CBPeripheral, error: Error?) {
        // Handle failed peripheral connection.
    }
    
    public func centralManager(_ centralManager: PlaygroundBluetoothCentralManager, didDisconnectFrom peripheral: CBPeripheral, error: Error?) {
        // Handle peripheral disconnection.
        discoveredPeripheral = nil
    }

    public func sendDroneData(_ data:String, _ duration:Int){
        let data = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        discoveredPeripheral!.writeValue(data, for: commandCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(duration) ) {
            self.onDataWritten?()
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {


         if let servicePeripherrals = peripheral.services as [CBService]!{
            for service in servicePeripherrals{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }



    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        // check the uuid of each characteristic to find config and data characteristics
        for charateristic in service.characteristics! {
            
            let thisCharacteristic = charateristic as CBCharacteristic
            // Set notify for characteristics here.
            peripheral.setNotifyValue(true, for: thisCharacteristic)
            commandCharacteristic = thisCharacteristic
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
        guard error == nil else {
            myPrint("Error writing data: \(error!.localizedDescription)")
            return
        }
        onDataWritten?()
    }



     // Callback on data arrival via notification on the characteristic
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        var input = ""

        if characteristic.uuid.uuidString == "FFE1" {
            
            let message = String(data: characteristic.value!, encoding: String.Encoding.utf8)
            
//            if let message = message {
//                input = input + message
//                if input.contains("\n") {
//                    var components = input.components(separatedBy: "\n")
//                    let line = components.removeFirst()
//                    input = components.joined(separator: "\n")
//                    if line != "" {
//                        print(line)
//                        if line.hasPrefix("ready") {
//                            receivedReadyMessage()
//                        }
//                    }
//                }
//            }   
        }
    }


}
