import UIKit
class ViewController: UIViewController {
    var player = UIImageView(image: #imageLiteral(resourceName: "ship"))
    var ship: [UIImageView]!=[]
    var buttonLeft,buttonRight,buttonShoot,buttonStart:UIButton!
    var rightDirection = true
    var stepDirection = 1
    var shot = 40
    var score:UILabel = UILabel()
    var scoreInt = 0
    override func viewDidLoad() {
        self.view.backgroundColor = .black
        score.frame = CGRect(x: 50, y: 0, width: 200, height: 20)
        score.textColor = .white
        let n=Int(UIScreen.main.bounds.width/10)
        for i in 0..<40 {
            let imageView: UIImageView=UIImageView()
            if(i<8){
                imageView.frame = CGRect(x:n*i+5,y:n,width:n-5,height:n-5)
            }else if(i<16){
                imageView.frame = CGRect(x:n*(i-8)+5,y:n*2,width:n-5,height:n-5)
            }else if(i<24){
                imageView.frame = CGRect(x:n*(i-16)+5,y:n*3,width:n-5,height:n-5)
            }else if(i<32){
                imageView.frame = CGRect(x:n*(i-24)+5,y:n*4,width:n-5,height:n-5)
            }else{
                imageView.frame = CGRect(x:n*(i-32)+5,y:n*5,width:n-5,height:n-5)
            }
            ship.append(imageView)
            self.view.addSubview(ship[i])
            ship[i].isHidden = true
        }
        for i in 40..<60 {
            let imageView: UIImageView
            if(i<59){//good & bad bullets
                imageView = UIImageView(image: #imageLiteral(resourceName: "bullet"))
                imageView.frame = CGRect(x:-50,y:-50,width:n/5,height:n/2)
            }else{//logo
                imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
                imageView.frame = CGRect(x:10,y:n*3,width:Int(UIScreen.main.bounds.width-20),height:Int(UIScreen.main.bounds.width/14))
            }
            ship.append(imageView)
            self.view.addSubview(ship[i])
        }
        player.frame = CGRect(x:Int(self.view.center.x),y:Int(self.view.center.y*1.5),width:n-5,height:n-5)
        buttonLeft = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height-100, width: 80, height: 80))
        buttonLeft.setBackgroundImage(#imageLiteral(resourceName: "left"), for: .normal)
        buttonLeft.addTarget(self, action:#selector(self.leftButtonClicked), for: .touchDown)
        buttonRight = UIButton(frame: CGRect(x: 120, y: UIScreen.main.bounds.height-100, width: 80, height: 80))
        buttonRight.setBackgroundImage(#imageLiteral(resourceName: "right"), for: .normal)
        buttonRight.addTarget(self, action:#selector(self.rightButtonClicked), for: .touchDown)
        buttonShoot = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-110, y: UIScreen.main.bounds.height-110, width: 100, height: 100))
        buttonShoot.setBackgroundImage(#imageLiteral(resourceName: "fire"), for: .normal)
        buttonShoot.addTarget(self, action:#selector(self.shootButtonClicked), for: .touchDown)
        buttonStart = UIButton(frame: CGRect(x:Int(UIScreen.main.bounds.width/2)-Int(UIScreen.main.bounds.width-20)/4,y:Int(UIScreen.main.bounds.height/2),width:Int(UIScreen.main.bounds.width-20)/2,height:Int(UIScreen.main.bounds.width/14)/2))
        buttonStart.setBackgroundImage(#imageLiteral(resourceName: "start"), for: .normal)
        buttonStart.addTarget(self, action:#selector(self.startButtonClicked), for: .touchDown)
        self.view.addSubview(score)
        self.view.addSubview(player)
        self.view.addSubview(buttonLeft)
        self.view.addSubview(buttonRight)
        self.view.addSubview(buttonShoot)
        self.view.addSubview(buttonStart)
        self.gameOver()
        perform(#selector(shipsmove), with: nil, afterDelay: 0.2)
        for view in self.view.subviews as [UIView] {
            view.layer.magnificationFilter = kCAFilterNearest
            view.layer.minificationFilter = kCAFilterNearest
        }
        super.viewDidLoad()
    }
    func startButtonClicked() {
        player.isHidden = false
        buttonStart.isHidden = true
        buttonLeft.isHidden = false
        buttonRight.isHidden = false
        buttonShoot.isHidden = false
        ship[59].image = nil
        for i in 0..<40 {
            ship[i].isHidden = false
        }
        scoreInt = 0
        score.text="Score \(scoreInt)"
    }
    func gameOver() {//win or lose
        player.isHidden = true
        buttonStart.isHidden = false
        buttonLeft.isHidden = true
        buttonRight.isHidden = true
        buttonShoot.isHidden = true
    }
    func leftButtonClicked() {
        if(player.center.x>50&&buttonLeft.isHighlighted){
            player.center=CGPoint(x:player.center.x-10, y:player.center.y)
            perform(#selector(leftButtonClicked), with: nil, afterDelay: 0.05)
        }
    }
    func rightButtonClicked() {
        if(player.center.x<UIScreen.main.bounds.width-50&&buttonRight.isHighlighted){
            player.center=CGPoint(x:player.center.x+10, y:player.center.y)
            perform(#selector(rightButtonClicked), with: nil, afterDelay: 0.05)
        }
    }
    func shootButtonClicked() {
        shot += 1
        if(shot>49){
            shot=40
        }
        ship[shot].center=player.center
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {
            self.ship[self.shot].center=CGPoint(x:self.ship[self.shot].center.x, y:-50)
        })
        perform(#selector(collisionDetect), with: nil, afterDelay: 0.0)
    }
    func shipsmove() {
        for i in 50..<59 {
            if((ship[i].layer.presentation()?.frame)!.intersects((player.layer.presentation()?.frame)!)){//Hit Player
                self.gameOver()
                ship[59].image = #imageLiteral(resourceName: "gameover")
            }
            let m=Int(arc4random())%100
            if(m==1){
                let n=Int(arc4random())%40
                if(ship[n].isHidden == false){
                    ship[i].center=ship[n].center
                    UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
                        self.ship[i].center=CGPoint(x:self.ship[i].center.x, y:UIScreen.main.bounds.height+50)
                    })
                }
            }
        }
        if(stepDirection == 2){
            stepDirection = 1
        }else{
            stepDirection = 2
        }
        for n in 0..<40 {
            if(n<8){
                ship[n].image = UIImage(named:"enemyc" + String(stepDirection))
            }else if(n<24){
                ship[n].image = UIImage(named:"enemyb" + String(stepDirection))
            }else{
                ship[n].image = UIImage(named:"enemya" + String(stepDirection))
            }
        }
        if(rightDirection){
            myLoop:for i in 0..<40 {
                ship[i].center=CGPoint(x:ship[i].center.x+5, y:ship[i].center.y)
                if(ship[39].center.x>UIScreen.main.bounds.width-30){
                    rightDirection=false
                }
            }
        }else{
            for i in 0..<40 {
                ship[i].center=CGPoint(x:ship[i].center.x-5, y:ship[i].center.y)
                if(ship[39].center.x<UIScreen.main.bounds.width/1.25){
                    rightDirection=true
                }
            }
        }
        perform(#selector(shipsmove), with: nil, afterDelay: 0.2)
    }
    func collisionDetect(){
        myLoop:for i in 40..<50 {
            if(UIScreen.main.bounds.intersects((ship[i].layer.presentation()?.frame)!)) {
                myInnerLoop:for n in 0..<40 {
                    if((ship[n].layer.presentation()?.frame)!.intersects((ship[i].layer.presentation()?.frame)!)&&ship[n].isHidden==false){//Hit
                        scoreInt += 10
                        score.text="Score \(scoreInt)"
                        ship[n].isHidden = true
                        ship[i].center=CGPoint(x:-100,y:-100)
                        perform(#selector(collisionDetect), with:nil, afterDelay: 0.01)
                        var countHidden=0
                        for m in 0..<40 {
                            if(ship[m].isHidden){
                                countHidden += 1;
                            }
                            if(countHidden==40){
                                self.gameOver()
                                ship[59].image = #imageLiteral(resourceName: "win")
                            }
                        }
                    }
                }
                perform(#selector(collisionDetect), with:nil, afterDelay: 0.01)
                break myLoop
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
