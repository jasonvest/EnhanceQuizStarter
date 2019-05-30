//
//  TriviaProvider.swift
//  EnhanceQuizStarter
//
//  Created by Jason Vest on 5/28/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//
import GameKit


class TriviaProvider    {
    let questions: [[String: String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]
    
    let questionsPerRound: Int 
    var questionsAsked: Int
    var correctQuestions: Int
    var indexOfSelectedQuestion: Int

    
    init() {
        self.questionsPerRound = 4
        self.questionsAsked = 0
        self.correctQuestions = 0
        self.indexOfSelectedQuestion = 0
    }
    
    func randomQuestion() -> String {
        self.indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        let questionDictionary = questions[indexOfSelectedQuestion]
        var questionText = ""
        
        if questionDictionary["Question"] != nil    {
            questionText = questionDictionary["Question"]!
        }
        else    {
            questionText = ""
        }
        return questionText
    }
}
