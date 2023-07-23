import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    var imageUrls: [String] = []
    var buttons: [UIButton] = []
    
    
    var click = 1
    var click1 = 0
    var click2 = 0
    var points1 = 0
    var points2 = 0
    var player = 1
    
    @IBOutlet weak var player1Label: UILabel!
    
    @IBOutlet weak var player2Label: UILabel!
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button10: UIButton!
    @IBOutlet weak var button11: UIButton!
    @IBOutlet weak var button12: UIButton!
    
    var matchedButtons: Set<UIButton> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkingManager.fetchImagesFromFlickr { [weak self] imageUrls in
            if let imageUrls = imageUrls {
                self?.imageUrls = imageUrls
                print("Fetched Image URLs: \(imageUrls)") // Add this print statement
                self?.setButtonImages(imageUrls: imageUrls)
            }
        }

        buttons = [button1, button2, button3, button4, button5, button6, button7, button8, button9, button10, button11, button12]
    }
    private let defaultImage = UIImage(named: "card")
    
    @IBAction func button1Action(_ sender: Any) {
        handleButtonClick(for: button1, atIndex: 0)
    }
    
    @IBAction func button2Action(_ sender: Any) {
        handleButtonClick(for: button2, atIndex: 1)
    }
    
    @IBAction func button3Action(_ sender: Any) {
        handleButtonClick(for: button3, atIndex: 2)
    }
    
    @IBAction func button4Action(_ sender: Any) {
        handleButtonClick(for: button4, atIndex: 3)
    }
    
    @IBAction func button5Action(_ sender: Any) {
        handleButtonClick(for: button5, atIndex: 4)
    }
    
    @IBAction func button6Action(_ sender: Any) {
        handleButtonClick(for: button6, atIndex: 5)
    }
    
    @IBAction func button7Action(_ sender: Any) {
        handleButtonClick(for: button7, atIndex: 6)
    }
    
    @IBAction func button8Action(_ sender: Any) {
        handleButtonClick(for: button8, atIndex: 7)
    }
    
    @IBAction func button9Action(_ sender: Any) {
        handleButtonClick(for: button9, atIndex: 8)
    }
    
    @IBAction func button10Action(_ sender: Any) {
        handleButtonClick(for: button10, atIndex: 9)
    }
    
    @IBAction func button11Action(_ sender: Any) {
        handleButtonClick(for: button11, atIndex: 10)
    }
    
    @IBAction func button12Action(_ sender: Any) {
        handleButtonClick(for: button12, atIndex: 11)
    }
    func checkGameEnd() {
        // Assuming all matched buttons are hidden (alpha = 0)
        let allButtonsMatched = matchedButtons.reduce(true) { $0 && $1.alpha == 0 }

        if allButtonsMatched {
            // You can display an alert or perform any other actions here
            let alertController = UIAlertController(title: "Game Over", message: "Congratulations! The game has ended.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func handleButtonClick(for button: UIButton, atIndex index: Int) {
        // Check if the button is already matched or has been clicked before
        if button.alpha == 0 || matchedButtons.contains(button) {
            print("Button already matched or clicked.")
            return
        }

        if click == 1 {
            // Set the corresponding image URL to the button
            button.sd_setImage(with: URL(string: imageUrls[index]), for: .normal)
            click = 2
            click1 = index + 1
            print("First click: \(click1)")
        } else if click == 2 {
            // Set the corresponding image URL to the button
            button.sd_setImage(with: URL(string: imageUrls[index]), for: .normal)
            click = 1
            click2 = index + 1
            print("Second click: \(click2)")
            compare()
        }
    }
    func compare() {
        print("Comparing images...")
        if imageUrls[click1 - 1] == imageUrls[click2 - 1] {
            print("Match found!")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
                // Hide matched cards
                self?.buttons[self!.click1 - 1].alpha = 0
                self?.buttons[self!.click2 - 1].alpha = 0

                // Add the matched buttons to the set
                self?.matchedButtons.insert(self!.buttons[self!.click1 - 1])
                self?.matchedButtons.insert(self!.buttons[self!.click2 - 1])

                // Increase the points for the current player
                if self?.player == 1 {
                    self?.points1 += 1
                    self?.player1Label.text = "Player 1: \(self?.points1 ?? 0) points"
                } else {
                    self?.points2 += 1
                    self?.player2Label.text = "Player 2: \(self?.points2 ?? 0) points"
                }

                // Check for game end here
                let allButtonsMatched = self?.matchedButtons.count == self?.buttons.count
                if allButtonsMatched {
                    // Determine the winner
                    let winner: String
                    if self?.points1 == self?.points2 {
                        winner = "It's a Tie!"
                    } else if self?.points1 ?? 0 > self?.points2 ?? 0 {
                        winner = "Player 1 Wins!"
                    } else {
                        winner = "Player 2 Wins!"
                    }

                    // Display an alert with the winner's information
                    let alertController = UIAlertController(title: "Game Over", message: winner, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alertController, animated: true, completion: nil)

                    // Send a local notification with the winner's information
                    let content = UNMutableNotificationContent()
                    content.title = "Game Over"
                    content.body = winner
                    let request = UNNotificationRequest(identifier: "gameOver", content: content, trigger: nil)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        } else {
            print("No match!")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
                // Hide the unmatched cards
                self?.buttons[self!.click1 - 1].setImage(UIImage(named: "card"), for: .normal)
                self?.buttons[self!.click2 - 1].setImage(UIImage(named: "card"), for: .normal)
                self?.switchPlayer()
            }
        }
    }

    func switchPlayer() {
        if player == 1 {
            player = 2
            player1Label.textColor = .gray
            player2Label.textColor = .black
            
        } else {
            player = 1
            player1Label.textColor = .black
            player2Label.textColor = .gray
        }
        
        
    }
    private func setButtonImages(imageUrls: [String]) {
        print("Image URLs count: \(imageUrls.count)")
        print("Buttons count: \(buttons.count)")

        guard imageUrls.count == buttons.count / 2 else {
             print("Error: The number of image URLs doesn't match the number of buttons.")
             return
         }
        let doubledImageUrls = imageUrls + imageUrls
            print("Doubled Image URLs count: \(doubledImageUrls.count)")

        let shuffledImageUrls = doubledImageUrls.shuffled()

        for (index, button) in buttons.enumerated() {
               button.sd_setImage(with: URL(string: shuffledImageUrls[index]), for: .normal)
               print("Button \(index + 1) Image URL: \(shuffledImageUrls[index])")
           }
    }

}
