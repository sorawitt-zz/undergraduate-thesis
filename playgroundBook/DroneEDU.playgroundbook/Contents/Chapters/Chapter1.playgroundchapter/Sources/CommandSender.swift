import Foundation
import PlaygroundSupport


public enum CommandType: String{
    
    case COMMAND_ARM        =   "command_arm"
    case COMMAND_DISARM     =   "command_disarm"
    case COMMAND_TAKE_OFF   =   "command_take_off"
    case COMMAND_LAND       =   "command_land"
    case COMMAND_TURN_LEFT  =   "command_turn_left"
    case COMMAND_TURN_RIGHT =   "command_turn_right"
    case COMMAND_FORWARD    =   "command_forward"
    case COMMAND_BACKWARD   =   "command_backward"
    
}

public protocol CommandPauseDelegate {
    var isReadyForMoreCommands: Bool { get set }
    var returnValue: Bool { get set }
}

extension CommandPauseDelegate {
    /// Waits until `isReadyForMoreCommands` is set to true.
    func wait() {
        repeat {
            RunLoop.main.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1))
        } while !isReadyForMoreCommands
    }
}

public class CommandSender: CommandPauseDelegate {
    
    public var isReadyForMoreCommands = true
    public var returnValue = false
    
    var command: PlaygroundValue = .string("")
    //var commands:[PlaygroundValue] = [PlaygroundValue]() // PlaygroundValue could be .string(String) .dictionary([String:PlaygroundValue])
    
    public init(){
    }
    
    public func sendCommand(_ commandData:PlaygroundValue) {
        let page = PlaygroundPage.current
        if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
            proxy.send(commandData)
        }
// Spin the runloop until the LiveView process has completed the current command.
       isReadyForMoreCommands = false
        wait()
    }
    
    public func connectToRobot(_ name:String){

    }
    
    public func exitProgram()
    {
        var assessmentManager = AssessmentManager()
        assessmentManager.checkAnswer()
        

    }
    
    public func arm(){

    }
    
    public func disArm(){
        command = .string(CommandType.COMMAND_DISARM.rawValue)
        sendCommand(command)
    }
    
    public func moveForward(){
        command = .string(CommandType.COMMAND_FORWARD.rawValue)
        sendCommand(command)
    }
    
    public func moveBackward(){
        command = .string(CommandType.COMMAND_BACKWARD.rawValue)
        sendCommand(command)
    }
    
    public func takeOff(){
        command = .string(CommandType.COMMAND_TAKE_OFF.rawValue)
        sendCommand(command)
    }
    
    public func land(){
        command = .string(CommandType.COMMAND_LAND.rawValue)
        sendCommand(command)
    }
    
    public func turnLeft(){
        command = .string(CommandType.COMMAND_TURN_LEFT.rawValue)
        sendCommand(command)
    }
    
    public func turnRight(){
        command = .string(CommandType.COMMAND_TURN_RIGHT.rawValue)
        sendCommand(command)
    }
    

    
}
