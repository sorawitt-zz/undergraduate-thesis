import Foundation
import PlaygroundSupport
import PlaygroungBluetooth


public class DroneCommand: NSObject{
    
    
    public func isWaitCommand(_ command:PlaygroundValue)->Bool{
        switch command {
        case let .string(text):
            switch(text){
            case CommandType.COMMAND_WAITFOR_OBSTACLE_FRONT.rawValue,
                 CommandType.COMMAND_WAITFOR_OBSTACLE_REAR.rawValue,
                 CommandType.COMMAND_WAITFOR_CLAP.rawValue,
                 CommandType.COMMAND_WAITFOR_BUTTON1.rawValue,
                 CommandType.COMMAND_WAITFOR_BUTTON2.rawValue,
                 CommandType.COMMAND_WAITFOR_BUTTON3.rawValue:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }
    
    
    
    public func sendDroneCommand(_ droneConnection:DroneConnection, _ command:PlaygroundValue){ // Send command to robot
        
        var command = ""
        var duration:Int = 2000
        
        
//        case COMMAND_TAKE_OFF   =   "command_take_off"
//        case COMMAND_LAND       =   "command_land"
//        case COMMAND_TURN_LEFT  =   "command_turn_left"
//        case COMMAND_TURN_RIGHT =   "command_turn_right"
//        case COMMAND_FORWARD    =   "command_forward"
//        case COMMAND_BACKWARD   =   "command_backward"
        
        
        switch command {
        case let .string(text):
            switch text {
            case CommandType.COMMAND_TAKE_OFF.rawValue:
                dataRaw = CommandType.COMMAND_TAKE_OFF.rawValue
                break
            case CommandType.COMMAND_LAND.rawValue:
                dataRaw = CommandType.COMMAND_LAND.rawValue
            case CommandType.COMMAND_TURN_RIGHT.rawValue:
                dataRaw = CommandType.COMMAND_TURN_RIGHT.rawValue
                break
            case CommandType.COMMAND_TURN_LEFT.rawValue:
                dataRaw = CommandType.COMMAND_FORWARD.rawValue
                break
            case CommandType.COMMAND_BACKWARD.rawValue:
                dataRaw = CommandType.COMMAND_BACKWARD.rawValue
            default:
                break
            }
        default:
            break
        }
        
//        switch command {
//        case .string("f"):
//            dataRaw = "f"
//
//            droneConnection.sendDroneData(dataRaw, duration)
//            break
//        default:
//            break
//        }
        
        robotConnection.sendRobotData(data, duration)
    }
    
}
