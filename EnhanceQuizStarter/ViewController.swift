//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var gameSound: SystemSoundID = 0
    var wrongSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 0
    var perfectGameSound: SystemSoundID = 0
    var wompSound: SystemSoundID = 0
    
    let gameManager = GameManager(questionsPerRound: 4)
    
    // MARK: - Outlets
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var fourthChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var questionResults: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    
    
    //Researched on internet and documentation
    override var preferredStatusBarStyle: UIStatusBarStyle  {
        return .lightContent
    }
    override func viewDidLoad() {
        //Researched on internet and documentation
        self.setNeedsStatusBarAppearanceUpdate()
        super.viewDidLoad()
        
        loadGameSounds()
        playGameStartSound()
        displayQuestion()
    }
    
    // MARK: - Helpers
    
    func loadGameSounds() {
        let pathGameSound = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrlGameSound = URL(fileURLWithPath: pathGameSound!)
        AudioServicesCreateSystemSoundID(soundUrlGameSound as CFURL, &gameSound)
        
        let pathWrongSound = Bundle.main.path(forResource: "WrongSound", ofType: "wav")
        let soundUrlWrongSound = URL(fileURLWithPath: pathWrongSound!)
        AudioServicesCreateSystemSoundID(soundUrlWrongSound as CFURL, &wrongSound)
        
        let pathCorrectSound = Bundle.main.path(forResource: "CorrectSound", ofType: "wav")
        let soundUrlCorrectSound = URL(fileURLWithPath: pathCorrectSound!)
        AudioServicesCreateSystemSoundID(soundUrlCorrectSound as CFURL, &correctSound)
        
        let pathPerfectGameSound = Bundle.main.path(forResource: "PerfectGameSound", ofType: "wav")
        let soundUrlPerfectGameSound = URL(fileURLWithPath: pathPerfectGameSound!)
        AudioServicesCreateSystemSoundID(soundUrlPerfectGameSound as CFURL, &perfectGameSound)
        
        let pathWompSound = Bundle.main.path(forResource: "WompSound", ofType: "wav")
        let soundUrlWompSound = URL(fileURLWithPath: pathWompSound!)
        AudioServicesCreateSystemSoundID(soundUrlWompSound as CFURL, &wompSound)
    }
    
    func listOfChoiceButtons() -> [UIButton] {
        let buttons: [UIButton] = [firstChoiceButton, secondChoiceButton, thirdChoiceButton,fourthChoiceButton]
        return buttons
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playCorrectAnswerSound()   {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func playWrongAnswerSound()   {
        AudioServicesPlaySystemSound(wrongSound)
    }
    
    func playPerfectGameSound() {
        AudioServicesPlaySystemSound(perfectGameSound)
    }
    
    func playWompSound()    {
        AudioServicesPlaySystemSound(wompSound)
    }
    
    // Display questions and choices
    func displayQuestion() {
        questionResults.isHidden = true
        correctAnswerLabel.isHidden = true
        
        let question = gameManager.randomQuestion()
        questionField.text = question.question
        
        //Loop through available choices and update buttons appropriately
        let choices = question.choices
        let buttons = listOfChoiceButtons()
        for button in buttons   {
            button.isHidden = true
            if button.isEnabled == false    {
                button.isEnabled = true
            }
        }
        for index in 0..<choices.count  {
            buttons[index].setTitle(choices[index], for: UIControlState.normal)
            buttons[index].isHidden = false
        }
        
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        let buttons = listOfChoiceButtons()
        
        for button in buttons {
            button.isHidden = true
        }
        
        // Hide the question results and correct answer labels
        questionResults.isHidden = true
        correctAnswerLabel.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        // Customize success message based on results
        let scorePercentage = gameManager.scorePercentage()
        var message: String
        switch scorePercentage {
        case 1.0:
            message = "Perfect score!\n"
            playPerfectGameSound()
        case 0.75..<100.0:
            message = "Not too bad...\n"
            playPerfectGameSound()
        case 0.50..<0.75:
            message = "I think you need some practice...\n"
            playWompSound()
        case 0.00..<0.50:
            message = "That was rough!\n"
            playWompSound()
        default:
            message = ""
        }
        questionField.text = message + "You got \(gameManager.correctQuestions) out of \(gameManager.questionsPerRound) correct!"
        
    }
    
    func nextRound() {
        if gameManager.questionsAsked == gameManager.questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }

    @IBAction func checkAnswer(_ sender: UIButton) {
        //Highlight selected button and disable input
        let buttons = listOfChoiceButtons()
        for button in buttons   {
            if button !== sender    {
                button.isEnabled = false
            }
        }
        
        //Increment the questions asked counter
        gameManager.questionsAsked += 1
        let answerSelected = sender.currentTitle!
        let correctAnswer = gameManager.quiz.questions[gameManager.indexOfSelectedQuestion].answer
        
        if answerSelected == correctAnswer {
            gameManager.correctQuestions += 1
            playCorrectAnswerSound()
            questionResults.text = "Correct!"
            questionResults.textColor = UIColor.init(red: 0, green: 255.0, blue: 0, alpha: 1.0)
            questionResults.isHidden = false
            
        } else  {
            playWrongAnswerSound()
            questionResults.text = "Sorry, wrong answer!"
            questionResults.textColor = UIColor.init(red: 255.0, green: 0, blue: 0, alpha: 1.0)
            correctAnswerLabel.text = "Correct answer: \(correctAnswer)"
            
            correctAnswerLabel.isHidden = false
            questionResults.isHidden = false
        }
        loadNextRound(delay: 2)
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        // Reset choice buttons to hidden
        let buttons = listOfChoiceButtons()
        for button in buttons   {
            button.isHidden = true
        }        
        gameManager.questionsAsked = 0
        gameManager.correctQuestions = 0
        gameManager.questionsUsed = []
        gameManager.indexOfSelectedQuestion = 0
        nextRound()
    }
}

