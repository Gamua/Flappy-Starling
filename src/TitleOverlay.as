package
{
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.utils.Color;

    public class TitleOverlay extends Sprite
    {
        private var _topScoreLabel:TextField;
        private var _topScore:int;

        public function TitleOverlay(width:Number, height:Number)
        {
            var title:TextField = new TextField(width, 200, "Flappy\nStarling");
            title.format.setTo("bradybunch", BitmapFont.NATIVE_SIZE, Color.WHITE);
            title.format.leading = -20;

            var tapIndicator:Image = new Image(Game.assets.getTexture("tap-indicator"));
            tapIndicator.x = width / 2;
            tapIndicator.y = (height - tapIndicator.height) / 2;

            _topScoreLabel = new TextField(width, 50, "");
            _topScoreLabel.format.setTo(BitmapFont.MINI, BitmapFont.NATIVE_SIZE * 2);
            _topScoreLabel.y = height * 0.80;

            addChild(title);
            addChild(tapIndicator);
            addChild(_topScoreLabel);
        }

        public function get topScore():int { return _topScore; }
        public function set topScore(value:int):void
        {
            _topScore = value;
            _topScoreLabel.text = "Current Record: " + value;
        }
    }
}
