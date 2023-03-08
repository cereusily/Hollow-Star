# Hollow Star
## The Galaxy is in danger.
The Legion is a self-sustaining AI that went rogue a millenia ago. Now, it has reached the outskirts of your home galaxy with an ultimate weapon: The Hollow Star. Take control of callsign ATLAS, a starship engineered using the same mysterious energy powering the Legion, giving you the ability to harness their power of polarity. It is now up to you to destroy the Hollow Star and return the Legion to stardust! 

## How to Play
ARROW KEYS - Move Starship<br/>
SHIFT - Switch Polarities<br/>
SPACEBAR - Fire<br/>
X - Release Special<br/>
ESC - Pause game<br/>

## Tips & Tricks
ATLAS' bullets will do twice the damage to enemies of opposite polarities--moreover, damaging enemies of opposite polarities will charge your Special which you can release with the X key. You may encounter energized bullets coming your way--but fear not! ATLAS has been engineered to absorb enemy bullets of the same polarity thus charging your Special. However, you will be vulnerable to bullets of the opposite polarity--so be aware!

## About the Game Design
Hollow Star was greatly inspired by the early 2000s' vertical shooter 'Ikaruga'. I hand-designed the ATLAS first on paper and designed the Legion subsequently. It was very rewarding to see something go from ideation to a functioning digital product! I spent a good amount of time working out the Hollow Star's bullet mechanics. In the code, I utilized trigonometry to create interesting attack patterns that keeps the player on their toes. I contemplated using power-ups but went against it. I wanted players to focus more on managing their polarities with enemies and increasing their Special meter. There are currently three different types of enemies that appear after each subsequent rounds: Basic, Elite, and Fast. The frequency of these enemies will also increase as the wave number increases. 

### Notes for Playtesting
In the code, under HollowStar.pde at line 49, there is a Debug tool that is toggled off as of hand-in. If you are finding it too hard to play the game and are unable to reach or beat the boss, toggle the Debug tool to true. This will bring up a variety of information on the HUD as well as give you unlimited Special meter that will OHKO anything including the boss!
