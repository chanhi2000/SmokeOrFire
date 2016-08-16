//
//  Round.swift
//  SmokeOrFire
//
//  Created by Justin Lawrence Hester on 8/6/16.
//  Copyright © 2016 Justin Lawrence Hester. All rights reserved.
//

class Round {
    var card: Card
    var rule: Rule

    init(card: Card, rule: Rule) {
        self.card = card
        self.rule = rule
    }
    deinit {
        print("Round being released from memory")
    }

    func isDrinking(player: Player) -> Bool {
        switch (rule) {
            case .COLOR:
                if (player.choice == PlayerChoices.RED && card.isRed()) {
                    return false
                } else if (player.choice == PlayerChoices.BLACK && (card.isBlack())) {
                    return false
                } else {
                    return true
                }
            case .UP_DOWN:
                if (player.choice == PlayerChoices.HIGHER &&
                        (card.rank.rawValue > player.hand[0].rank.rawValue)) {
                    return false
                } else if (player.choice == PlayerChoices.LOWER &&
                        (card.rank.rawValue < player.hand[0].rank.rawValue)) {
                    return false
                } else if (player.choice == PlayerChoices.SAME &&
                        (card.rank.rawValue == player.hand[0].rank.rawValue)) {
                    return false
                } else {
                    return true
                }
            case .IN_OUT:
                var sortedCards = player.hand
                sortedCards.sortInPlace({ $0.rank.rawValue < $1.rank.rawValue })
                if (player.choice == PlayerChoices.INSIDE &&
                        (card.rank.rawValue > sortedCards[0].rank.rawValue &&
                        card.rank.rawValue < sortedCards[1].rank.rawValue)) {
                    return false
                } else if (player.choice == PlayerChoices.OUTSIDE &&
                        (card.rank.rawValue < sortedCards[0].rank.rawValue ||
                        card.rank.rawValue > sortedCards[1].rank.rawValue)) {
                    return false
                } else if (player.choice == PlayerChoices.SAME &&
                        (card.rank.rawValue == sortedCards[0].rank.rawValue ||
                        card.rank.rawValue == sortedCards[1].rank.rawValue)) {
                    return false
                } else {
                    return true
                }
            case .SUIT:
                return (card.suit.rawValue != player.choice.rawValue)
            case .POKER:
                print("POKER Under Construction")
                return true
            case .GIVE:
                print("GIVE Under Construction")
                return true
            case .TAKE:
                print("TAKE Under Construction")
                return true
        }
    }
}
