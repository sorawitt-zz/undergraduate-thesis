import UIKit
import SceneKit
import PlaygroundSupport
struct bodyType {
    static let Ball = 0x1 << 1
    static let Coin = 0x1 << 2
}


public class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    
    
    var scnView: SCNView!
    let scnScene = SCNScene()
    let cameraNode = SCNNode()
    
    var firstBox: SCNNode!
    var tempBox: SCNNode!
    
    var droneNode: SCNNode!
    
    var drone: SCNNode!
    
    var left = Bool()
    var correctPath = Bool()
    
    var firstBoxNumber = Int()
    var prevBoxNumber = Int()
    
    var score = Int()
    var highscore = Int()
    
    var dead = Bool()
    
    var scoreLabel = UILabel()
    var highscoreLabel = UILabel()
    
  
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        createBox()
        createBall()
        
        setupCamera()
        setupLight()
        
        
    }
    
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if nodeA.physicsBody?.categoryBitMask == bodyType.Coin && nodeB.physicsBody?.categoryBitMask == bodyType.Ball {
            nodeA.removeFromParentNode()
            addScore()
        } else if nodeA.physicsBody?.categoryBitMask == bodyType.Ball && nodeB.physicsBody?.categoryBitMask == bodyType.Coin {
            nodeB.removeFromParentNode()
            addScore()
        }
    }
    
    public func addScore() {
        score += 1
        //print(score)
        
        self.performSelector(onMainThread: #selector(GameViewController.updateScoreLabel), with: nil, waitUntilDone: false)
        
        if score > highscore {
            highscore = score
            let scoreDefaults = UserDefaults.standard
            scoreDefaults.set(highscore, forKey: "highscore")
            //print(highscore)
        }
    }
    
    @objc func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
        highscoreLabel.text = "Highscore: \(highscore)"
    }
    
    public func fadeIn(node: SCNNode) {
        node.opacity = 0
        node.runAction(SCNAction.fadeIn(duration: 1.0))
    }
    
    
    
    
    public func addCoin(box: SCNNode) {
        scnScene.physicsWorld.gravity = SCNVector3Make(0, 0, 0)
        let rotate = SCNAction.rotate(by: CGFloat(Double.pi * 2), around: SCNVector3Make(0, 0.5, 0), duration: 0.5)
        let randomCoin = arc4random() % 8
        if randomCoin == 3 {
            let addCoinScene = SCNScene(named: "Coin.dae")
            let coin = addCoinScene?.rootNode.childNode(withName: "Coin", recursively: true)
            coin?.position = SCNVector3Make(box.position.x, box.position.y + 1, box.position.z)
            coin?.scale = SCNVector3Make(0.2, 0.2, 0.2)
            
            coin?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: coin!, options: nil))
            coin?.physicsBody?.categoryBitMask = bodyType.Coin
            coin?.physicsBody?.collisionBitMask = bodyType.Ball
            coin?.physicsBody?.contactTestBitMask = bodyType.Ball
            coin?.physicsBody?.isAffectedByGravity = false
            
            scnScene.rootNode.addChildNode(coin!)
            coin?.runAction(SCNAction.repeatForever(rotate))
            fadeIn(node: coin!)
        }
    }
    
    public func fadeOut(node: SCNNode) {
        let move = SCNAction.move(to: SCNVector3Make(node.position.x, node.position.y - 2, node.position.z), duration: 0.5)
        node.runAction(move)
        node.runAction(SCNAction.fadeOut(duration: 1.0))
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if dead == false {
            let deleteBox = self.scnScene.rootNode.childNode(withName: "\(prevBoxNumber)", recursively: true)
            
            let currentBox = self.scnScene.rootNode.childNode(withName: "\(prevBoxNumber + 1)", recursively: true)
            
            if deleteBox!.position.x > droneNode.position.x + 1 || deleteBox!.position.z > droneNode.position.z + 1 {
                prevBoxNumber += 1
                fadeOut(node: deleteBox!)
                createBoxes()
            }
            
            if droneNode.position.x > currentBox!.position.x - 0.5 && droneNode.position.x < currentBox!.position.x + 0.5 || droneNode.position.z > currentBox!.position.z - 0.5 && droneNode.position.z < currentBox!.position.z + 0.5 {
                //On Platform
            } else {
                die()
                dead = true
            }
        }
    }
    
    public func die() {
        droneNode.runAction(SCNAction.move(to: SCNVector3Make(droneNode.position.x, droneNode.position.y - 10, droneNode.position.z), duration: 1.0))
        
        let wait = SCNAction.wait(duration: 0.5)
        
        let removeBall = SCNAction.run { (node) in
            self.scnScene.rootNode.enumerateChildNodes({ (node, stop) in
                node.removeFromParentNode()
            })
        }
        
        let createScene = SCNAction.run { (node) in
            self.setupView()
            self.setupScene()
            self.createBox()
            self.createBall()
            self.setupCamera()
            self.setupLight()
        }
        
        let sequance = SCNAction.sequence([wait, removeBall, createScene])
        
        droneNode.runAction(sequance)
    }
    
    public func setupView() {
        scnView = self.view as? SCNView
        
    }
    
    public func setupScene() {
        scnView.delegate = self
        scnView.scene = scnScene
        scnView.backgroundColor = .white
    }
    
    public func setupCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 25
        cameraNode.position = SCNVector3Make(50, 25 , 20)
        cameraNode.eulerAngles = SCNVector3Make(-90, 90, 0)
        let constraint = SCNLookAtConstraint(target: droneNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        scnScene.rootNode.addChildNode(cameraNode)
        droneNode.addChildNode(cameraNode)
    }
    
    
    
    public func createBall() {
        droneNode = SCNNode()
        
        let droneModel = SCNScene(named: "art.scnassets/ship.scn")!
        let characterTopLevelNode = droneModel.rootNode.childNodes[0]
        
        droneNode = characterTopLevelNode
        
        droneNode.position = SCNVector3Make(0, 1.1, 0)
        droneNode.scale = SCNVector3(x: Float(0.1), y: Float(0.1), z: Float(0.1))
        droneNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: droneNode!, options: nil))
        droneNode.physicsBody?.categoryBitMask = bodyType.Ball
        droneNode.physicsBody?.collisionBitMask = bodyType.Coin
        droneNode.physicsBody?.contactTestBitMask = bodyType.Coin
        droneNode.physicsBody?.isAffectedByGravity = false
        
        scnScene.rootNode.addChildNode(droneNode)
    }
    
    public func createBox() {
        
        firstBoxNumber = 0
        prevBoxNumber = 0
        correctPath = true
        dead = false
        
        firstBox = SCNNode()
        
        let firstBoxGeometry = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0)
        firstBox.geometry = firstBoxGeometry
        let firstBoxMaterial = SCNMaterial()
        firstBoxMaterial.diffuse.contents = UIColor(red: 1.0, green: 0.7, blue: 0, alpha: 1)
        firstBoxGeometry.materials = [firstBoxMaterial]
        firstBox.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(firstBox)
        firstBox.name = "\(firstBoxNumber)"
        firstBox.opacity = 1
        
        for _ in 0...6 {
            createBoxes()
        }
    }
    
    public func setupLight() {
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = .directional
        light.eulerAngles = SCNVector3Make(-45, 45, 0)
        scnScene.rootNode.addChildNode(light)
        
        let light2 = SCNNode()
        light2.light = SCNLight()
        light2.light?.type = .directional
        light2.eulerAngles = SCNVector3Make(45, 45, 0)
        scnScene.rootNode.addChildNode(light2)
    }
    
    
    public func createBoxes() {
        tempBox = SCNNode(geometry: firstBox.geometry)
        let prevBox = scnScene.rootNode.childNode(withName: "\(firstBoxNumber)", recursively: true)
        firstBoxNumber += 1
        tempBox.name = "\(firstBoxNumber)"
        
        let randomNumber = arc4random() % 2
        
        switch randomNumber {
        case 0:
            tempBox.position = SCNVector3Make((prevBox?.position.x)! - firstBox.scale.x, (prevBox?.position.y)!, (prevBox?.position.z)!)
            if correctPath == true {
                correctPath = false
                left = false
            }
            
            break
        case 1:
            tempBox.position = SCNVector3Make((prevBox?.position.x)!, (prevBox?.position.y)!, (prevBox?.position.z)! - firstBox.scale.z)
            if correctPath == true {
                correctPath = false
                left = true
            }
            break
        default:
            break
        }
        
        self.scnScene.rootNode.addChildNode(tempBox)
        addCoin(box: tempBox)
        fadeIn(node: tempBox)
    }
    
}
