//import Foundation
//import PlaygroundSupport
//
//
//public class DroneCommand: NSObject{
//    
//    public var onVirtualDataWritten:(()->Void)?     // When user doesn't have a physical robot
//    public var onVirtualRobotConnected:(()->Void)?
//    public var onVirtualSensorUpdated:(()->Void)?
//    public var useVirtualRobot:Bool = false         // TODO:should be getter
//    public var sensorType:String?
//    
//
//    
//    public func connectVirtualRobot(){
//        useVirtualRobot = true
//        onVirtualRobotConnected?()
//    }
//    
//    
//    public func isWaitCommand(_ command:PlaygroundValue)->Bool{
//        switch command {
//        case let .string(text):
//            switch(text){
//                case CommandType.COMMAND_WAITFOR_OBSTACLE_FRONT.rawValue,
//                     CommandType.COMMAND_WAITFOR_CLAP.rawValue:
//                return true
//            default:
//                return false
//            }
//        default:
//            return false
//        }
//    }
//    
//    public func sendDroneCommand(_ droneConnection:DroneConnection, _ command:PlaygroundValue){ // Send command to robot
//        // TODO: refact this function to processRobotCommand since it has sensor command too. command should also to be refactored to dict(commandType:String, command:String)
//        switch command {
//        case let .string(text):
//           var dataRaw = ""
//            var duration:Int = 2000
//            sensorType = nil // Reset sensor type
//            switch(text){
//           
//            case CommandType.COMMAND_MOVE_FORWARD.rawValue:
//                dataRaw = "f"
//                break
//            default:
//                break
//            }
//            if sensorType==nil {
//                
//                    let data:String = dataRaw
//                    
//                    droneConnection.sendDroneData(data, duration)
//                
//            }
//
//            break
//        default:
//            break
//        }
//    }
//    
//    public static func solutionChecker(_ commands:[PlaygroundValue], _ correctSolution:[CommandType])->Bool{ // Don't pass in robot connect command into this
//        var result:Bool = false
//        if commands.count == correctSolution.count{
//            for index in 0...(commands.count-1) {
//                let command:PlaygroundValue = commands[index]
//                if case let .string(text) = command {
//                    if !text.isEqual(correctSolution[index].rawValue){
//                        break
//                    }
//                }
//                if index==(commands.count-1){
//                    result = true
//                }
//            }
//        }
//        return result
//    }
//}
