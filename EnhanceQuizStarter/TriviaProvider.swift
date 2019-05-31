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
        ["Question": "This was the only US President to serve more than two consecutive terms:",
         "Choice 1": "George Washington",
         "Choice 2": "Franklin D. Roosevelt",
         "Choice 3": "Woodrow Wilson",
         "Choice 4": "Andrew Jackson",
         "Answer": "Choice 2"],
        ["Question": "Which of the following countries has the most residents?",
         "Choice 1": "Nigeria",
         "Choice 2": "Russia",
         "Choice 3": "Iran",
         "Choice 4": "Vietnam",
         "Answer": "Choice 1"],
        ["Question": "In what year was the United Nations founded?",
         "Choice 1": "1918",
         "Choice 2": "1919",
         "Choice 3": "1945",
         "Choice 4": "1954",
         "Answer": "Choice 3"],
        ["Question": "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
         "Choice 1": "Paris",
         "Choice 2": "Washington D.C.",
         "Choice 3": "New York City",
         "Choice 4": "Boston",
         "Answer": "Choice 3"],
        ["Question": "Which nation produces the most oil?",
         "Choice 1": "Iran",
         "Choice 2": "Iraq",
         "Choice 3": "Brazil",
         "Choice 4": "Canada",
         "Answer": "Choice 4"],
        ["Question": "Which country has most recently won consecutive World Cups in Soccer?",
         "Choice 1": "Italy",
         "Choice 2": "Brazil",
         "Choice 3": "Argentina",
         "Choice 4": "Spain",
         "Answer": "Choice 2"],
        ["Question": "Which of the following rivers is longest?",
         "Choice 1": "Yangtze",
         "Choice 2": "Mississippi",
         "Choice 3": "Congo",
         "Choice 4": "Mekong",
         "Answer": "Choice 2"],
        ["Question": "Which city is the oldest?",
         "Choice 1": "Mexico City",
         "Choice 2": "Cape Town",
         "Choice 3": "San Juan",
         "Choice 4": "Sydney",
         "Answer": "Choice 1"],
        ["Question": "Which country was the first to allow women to vote in national elections?",
         "Choice 1": "Poland",
         "Choice 2": "United States",
         "Choice 3": "Sweden",
         "Choice 4": "Senegal",
         "Answer": "Choice 1"],
        ["Question": "Which of these countries won the most medals in the 2012 Summer Games?",
         "Choice 1": "France",
         "Choice 2": "Germany",
         "Choice 3": "Japan",
         "Choice 4": "Great Britian",
         "Answer": "Choice 4"],
    ]
    
    let questionsPerRound: Int 
    var questionsAsked: Int
    var correctQuestions: Int
    var indexOfSelectedQuestion: Int
    var questionsUsed: [Int]

    
    init() {
        self.questionsPerRound = 4
        self.questionsAsked = 0
        self.correctQuestions = 0
        self.indexOfSelectedQuestion = 0
        self.questionsUsed = []
    }
    
    func randomQuestion() -> String {
        repeat  {
            self.indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        } while questionsUsed.contains(indexOfSelectedQuestion) == true
        
        let questionDictionary = questions[indexOfSelectedQuestion]
        var questionText = ""
        
        if questionDictionary["Question"] != nil    {
            questionText = questionDictionary["Question"]!
            questionsUsed.append(indexOfSelectedQuestion)
        }
        else    {
            questionText = ""
        }
        return questionText
    }
    
    func questionChoices() -> [String] {
        var results = [String]()
        for (key, value) in questions[indexOfSelectedQuestion]  {
            if key.hasPrefix("Choice") && value != ""  {
                results.append(value)
            }
        }
        return results
    }
}
