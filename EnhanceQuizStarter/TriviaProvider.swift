//
//  TriviaProvider.swift
//  EnhanceQuizStarter
//
//  Created by Jason Vest on 5/28/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//
import GameKit

struct TriviaProvider   {
    let questions: [[String: String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]
    func randomQuestion() -> String {
        let randomInt = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        let question = questions[randomInt]["Question"]!
        return question
    }
}
