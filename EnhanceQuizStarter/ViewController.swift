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
    let gameManager = GameManager(questionsPerRound: 4)
    
    // MARK: - Outlets
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var fourthChoiceButton: UIButton!
    @IBOutlet weak var thirdChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameStartSound()
        playGameStartSound()
        displayQuestion()
    }
    
    // MARK: - Helpers
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    // Display questions and choices
    func displayQuestion() {
        let question = gameManager.randomQuestion()
        questionField.text = question.question
        
        //Loop through available choices and update buttons appropriately
        let choices = question.choices
        let buttons: [UIButton] = [firstChoiceButton, secondChoiceButton, thirdChoiceButton,fourthChoiceButton]
        
        for index in 0..<choices.count  {
            buttons[index].setTitle(choices[index], for: UIControlState.normal)
            buttons[index].isHidden = false
        }
        
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        firstChoiceButton.isHidden = true
        secondChoiceButton.isHidden = true
        thirdChoiceButton.isHidden = true
        fourthChoiceButton.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(gameManager.correctQuestions) out of \(gameManager.questionsPerRound) correct!"
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
    
    // MARK: - Actions
    /*
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        triviaProvider.questionsAsked += 1
        
        let selectedQuestionDict = triviaProvider.questions[triviaProvider.indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict["Answer"]
        
        if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
            triviaProvider.correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
 
        loadNextRound(delay: 2)
    }*/
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        // Show the answer buttons
        firstChoiceButton.isHidden = true
        secondChoiceButton.isHidden = true
        thirdChoiceButton.isHidden = true
        fourthChoiceButton.isHidden = true
        
        gameManager.questionsAsked = 0
        gameManager.correctQuestions = 0
        gameManager.questionsUsed = []
        gameManager.indexOfSelectedQuestion = 0
        nextRound()
    }
    

}

