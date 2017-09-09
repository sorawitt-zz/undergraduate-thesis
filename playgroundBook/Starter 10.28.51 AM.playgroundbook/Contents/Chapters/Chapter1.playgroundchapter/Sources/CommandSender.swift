import Foundation
import PlaygroundSupport




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
//        isReadyForMoreCommands = false
//        wait()
    }
    
    public func connectToRobot(_ name:String){

    }
    
    public func exitProgram()
    {

    }
    
    public func moveForward(){
        command = .string("f")
        sendCommand(command)
    }
    
}
