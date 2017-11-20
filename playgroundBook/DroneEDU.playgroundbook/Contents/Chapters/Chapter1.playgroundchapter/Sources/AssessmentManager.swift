import PlaygroundSupport

protocol AssessmentManagerDelegate {
    func checkAnswer()
    func updateAssessmentStatus1(hint: String, solution: String)
    
    func updateAssessmentStatus2()
    
    
}

public class AssessmentManager: AssessmentManagerDelegate{
    
    var commandsUser: [String]!
    var result = false
    
    public func checkAnswer(){
        
        if result {
            updateAssessmentStatus1(hint: "testHint", solution: "test solution")
        }else{
            updateAssessmentStatus2()
        }
    
    }
    
    public func updateAssessmentStatus1(hint: String, solution: String){
      
        
      
            PlaygroundPage.current.assessmentStatus = .fail(hints: ["Try using a `for` loop"], solution: nil)
        PlaygroundPage.current.assessmentStatus = .pass(message: "That's cool **wow wow wow** [Next Lesson](@next)")
    }
    
    public func updateAssessmentStatus2(){
        
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Try using a `for` loop"], solution: nil)
        //PlaygroundPage.current.assessmentStatus = .pass(message: "That's cool **wow wow wow** [Next Lesson](@next)")
    }
    
}
