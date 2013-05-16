//
// MainScene class
//
var LandingScene = function(){};

// Create callback for button
LandingScene.prototype.onPressButton = function()
{	
    // Rotate the label when the button is pressed
    this.helloLabel.runAction(cc.RotateBy.create(1,360));
};