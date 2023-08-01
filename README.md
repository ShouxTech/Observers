# Observers

A collection of observer utility functions.

Forked from [RbxObservers](https://github.com/Sleitnick/RbxObservers)

## Install
Install with [wally](https://wally.run/):\
`Observers = "shouxtech/observers@0.1.0"`


## Usage
Usage is mostly identical to [RbxObservers](https://github.com/Sleitnick/RbxObservers). However, here are the differences:
```
All methods are now PascalCase

ObserverCharacters (note the 's' at the end) now has the functionality of ObserveCharacter to observe all characters
ObserveCharacter is now for observing a single player's character

ObservePlayers (note the 's' at the end) now has the functionality of ObservePlayer to observe all players
ObservePlayer is now for observing a single player

ObserveCharacter and ObserveCharacters now pass the character as the first argument and player as second instead of the reverse.
```