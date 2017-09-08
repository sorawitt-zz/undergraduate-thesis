import Foundation
import PlaygroundSupport
import PlaygroundBluetooth


let commandSender:CommandSender = CommandSender()

public func setup(){
    let page = PlaygroundPage.current
    page.needsIndefiniteExecution = true

}

public func assessment(_ playgroundValue:PlaygroundValue)->Bool{
    // Assessment
    let result:Bool = true
    //Update assessment status
    PlaygroundPage.current.assessmentStatus = .pass(message: NSLocalizedString("### Nice one! \nDash has got the moves!\n\n[**Learn More**](http://makewonder.com/playbook) about Dash.", comment: ""))
    return result
}
