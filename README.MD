# Perform a Magic Trick
### Udacity ARKit with Swift Course Project 

An AR ball toss game - the application starts by tracking the environment, searching for a horizontal plane; once detected will place a hat in the center of the surface. Once placed the user can tap on the screen to project balls into the hat along with being able to tap on the **Magic!** button to make all the captured balls vanish. 

### Files
- art.scnassets/magichat.scn; game asset (hat) 
- MagicHat.swift; MagicHat node (details loaded from art.scnassets/magichat.scn) 
- Ball.swift; Ball Node
- SKExtensions.swift; some helper extensions 
- ViewController.swift; main controller 

### Notes 
- Debug information has been commented out 
- Scan on *textured* surface to improve detection and tracking 
- Place near-by (force is fixed, requiring the hat to be in close proximity)
