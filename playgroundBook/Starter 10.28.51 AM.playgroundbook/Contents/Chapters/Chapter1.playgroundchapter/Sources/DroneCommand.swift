import Foundation
import PlaygroundSupport

public class DroneCommand: NSObject{
    
    public func sendDroneCommand(_ droneConnection:DroneConnection, _ command:PlaygroundValue){ // Send command to robot
        
        var dataRaw = ""
        var duration:Int = 2000
        
        switch command {
        case .string("f"):
            dataRaw = "f"
            droneConnection.sendDroneData(dataRaw, duration)
            break
        default:
            break
        }
    }
    
}
