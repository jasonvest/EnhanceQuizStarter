//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var gameSound: SystemSoundID = 0
    var wrongSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 0
    var perfectGameSound: SystemSoundID = 0
    var wompSound: SystemSoundID = 0
    let gameManager = GameManager(questionsPerRound: 4)
    let soundManager = SoundManager()
    var speedRoundTimer: Timer!
    
    // MARK: - Outlets
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var fourthChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var questionResults: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var speedRoundSwitch: UISwitch!
    @IBOutlet weak var speedRoundLabel: UILabel!
    @IBOutlet weak var timerDisplay: UILabel!
    @IBOutlet weak var progressTimer: UIProgressView!
    
    
    //Researched on the internet and in documentation
    override var preferredStatusBarStyle: UIStatusBarStyle  {
        return .lightContent
    }
    
    override func viewDidLoad() {
        //Researched on internet and documentation
        self.setNeedsStatusBarAppearanceUpdate()
        super.viewDidLoad()
        soundManager.playSelectedSound(soundManager.gameSound)
        startGame()
    }
    
    // MARK: - Helpers
    
    //Return an array of the choice buttons to cycle through and set properties
    func listOfChoiceButtons() -> [UIButton] {
        let buttons: [UIButton] = [fourthChoiceButton,
                                   thirdChoiceButton,
                                   secondChoiceButton,
                                   firstChoiceButton]
        return buttons
    }

    //Format time into the number of seconds
    func formatTimeDisplay(_ totalSeconds: Int) -> String    {
        let seconds: Int = totalSeconds % 60
        let results = String(format: "%02d", seconds)
        return results
    }
    //Update the countdown time displayed and the progress indicator
    @objc func updateTimerDisplay() -> Void   {
        timerDisplay.text = "\(formatTimeDisplay(gameManager.speedRoundTime))"
        let progressCalculation: Float = Float(gameManager.speedRoundTime)/Float(gameManager.speedRoundLength)
        self.progressTimer.setProgress(progressCalculation, animated: true)
        
        
        if gameManager.speedRoundTime != 0  {
            gameManager.speedRoundTime -= 1
        } else  {
            stopTimer()
            checkAndDisplayResults(forChoice: "", isTimeUp: true)
        }
    }
    //Stop the timer
    func stopTimer() -> Void {
        speedRoundTimer.invalidate()
    }
    
    //Display play button and option to select speed round
    func startGame() -> Void  {
        questionField.text = "Are you ready to play?"
    }
    //Display appropriate controls and labels, start timer for speed round
    func checkIfSpeedRound() -> Void {
        if gameManager.speedRoundMode {
            timerDisplay.isHidden = false
            progressTimer.setProgress(1.0, animated: false)
            progressTimer.isHidden = false
            timerDisplay.text = "\(gameManager.speedRoundLength)"
            gameManager.speedRoundTime = gameManager.speedRoundLength
            speedRoundTimer = Timer.scheduledTimer(timeInterval: 1,
                                               target: self,
                                               selector: #selector(updateTimerDisplay),
                                               userInfo: nil,
                                               repeats: true)
        }
        else  {
            timerDisplay.isHidden = true
            progressTimer.isHidden = true
        }
    }
    
    // Display question and choices
    func displayQuestion() -> Void {
        //Hide play, speed round, results and correct answer
        playAgainButton.isHidden = true
        speedRoundLabel.isHidden = true
        speedRoundSwitch.isHidden = true
        questionResults.isHidden = true
        correctAnswerLabel.isHidden = true

        
        //Call the function to generate a random question
        let question = gameManager.randomQuestion()
        questionField.text = question.question
        
        //Check to see if the speedround is selected and display the appropriate labels, start the timer
        checkIfSpeedRound()
        
        //Loop through available choices and update buttons appropriately
        let choices = question.choices.shuffled()
        let buttons = listOfChoiceButtons()
        for button in buttons   {
            button.isHidden = true
            if button.isEnabled == false    {
                button.isEnabled = true
            }
        }
        //Loop through the availble number of choices and enable the same number of buttons as choices
        for index in 0..<choices.count  {
            buttons[index].setTitle(choices[index], for: UIControlState.normal)
            buttons[index].isHidden = false
        }
    }
    
    //Display the score at the end of the game
    func displayScore() -> Void {
        // Hide the answer buttons, question results, correct answer and timer lables
        let buttons = listOfChoiceButtons()
        for button in buttons {
            button.isHidden = true
        }
        questionResults.isHidden = true
        correctAnswerLabel.isHidden = true
        timerDisplay.isHidden = true
        progressTimer.isHidden = true
        
        // Display play again and speed round label and switch
        playAgainButton.setTitle("Play Again", for: UIControlState.normal)
        playAgainButton.isHidden = false
        if gameManager.speedRoundMode   {
            speedRoundSwitch.isOn = true
        } else  {
            speedRoundSwitch.isOn = false
        }
        speedRoundSwitch.isHidden = false
        speedRoundLabel.isHidden = false
        
        // Customize sound and message based on results
        let scorePercentage = gameManager.scorePercentage()
        var message: String = ""
        switch scorePercentage  {
        case 1.0:
            message = "Perfect score!\n"
            soundManager.playSelectedSound(soundManager.perfectGameSound)
        case 0.75..<100.0:
            message = "Not too bad...\n"
            soundManager.playSelectedSound(soundManager.perfectGameSound)
        case 0.50..<0.75:
            message = "I think you need some practice...\n"
            soundManager.playSelectedSound(soundManager.wompSound)
        case 0.00..<0.50:
            message = "That was rough!\n"
            soundManager.playSelectedSound(soundManager.wompSound)
        default:
            break
        }
        //Display the results message
        questionField.text = message + "You got \(gameManager.correctQuestions) out of \(gameManager.questionsPerRound) correct!"
    }
    
    //Display answer results, start next round
    func checkAndDisplayResults(forChoice choice: String, isTimeUp timeUp: Bool) -> Void {
        let choiceSelected = choice
        let timeUp = timeUp
        
        //Highlight the button if selected, and disable input for the others
        let buttons = listOfChoiceButtons()
        for button in buttons   {
            if button.currentTitle! != choiceSelected    {
                button.isEnabled = false
            }
        }
        //Hide progress timer and timer display
        progressTimer.isHidden = true
        timerDisplay.isHidden = true
        
        //Call the game manager method to check the results
        let results = gameManager.checkAnswer(forSelectedChoice: choiceSelected, isTimeUp: timeUp)
        
        //Update display and play appropriate sound based on the results
        if results.correct  {
            soundManager.playSelectedSound(soundManager.correctSound)
            questionResults.text = "Correct!"
            questionResults.textColor = UIColor.init(red: 0, green: 255.0, blue: 0, alpha: 1.0)
        } else if !results.correct  {
            if results.timeIsUp {
                questionResults.text = "Sorry, you ran out of time!"
            } else if !results.timeIsUp {
                questionResults.text = "Sorry, wrong answer!"
            }
            soundManager.playSelectedSound(soundManager.wrongSound)
            questionResults.textColor = UIColor.init(red: 255.0, green: 0, blue: 0, alpha: 1.0)
            correctAnswerLabel.text = "Correct answer: \(results.correctAnswer)"
            correctAnswerLabel.isHidden = false
        }
        questionResults.isHidden = false
        loadNextRound(delay: 3)
    }
    
    
    //Determine if the round is ongoing or over
    func nextRound() -> Void {
        let gameOver = gameManager.isRoundOver()
        if gameOver {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    //Pause between each question
    func loadNextRound(delay seconds: Int) -> Void {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    //Check the answer once a choice is made
    @IBAction func checkAnswer(_ sender: UIButton) -> Void {
        //Stop speed round timer if it is being used
        if gameManager.speedRoundMode   {
            stopTimer()
        }
        //Get selected choice and check if it is correct
        let choiceSelected = sender.currentTitle!
        checkAndDisplayResults(forChoice: choiceSelected, isTimeUp: false)
    }
    
    //Start the game or play it again
    @IBAction func playAgain(_ sender: UIButton) -> Void {
        // Reset choice buttons to hidden
        let buttons = listOfChoiceButtons()
        for button in buttons   {
            button.isHidden = true
        }
        gameManager.resetGame()
        nextRound()
    }
    
    //Enable the speed round based based on user choice
    @IBAction func speedRound(_ sender: UISwitch) -> Void {
        if sender.isOn == true  {
            gameManager.speedRoundMode = true
        } else  {
            gameManager.speedRoundMode = false
        }
    }
}
