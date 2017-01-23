package
{
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class Obstacle extends Sprite
    {
        private var _passed:Boolean;

        private var _radius:Number;
        private var _gapHeight:Number;

        public function Obstacle(gapHeight:Number)
        {
            var topTexture:Texture = Game.assets.getTexture("obstacle-top");
            var bottomTexture:Texture = Game.assets.getTexture("obstacle-bottom");

            _radius = topTexture.width / 2;
            _gapHeight = gapHeight;

            var top:Image = new Image(topTexture);
            top.pixelSnapping = true;
            top.pivotX = _radius;
            top.pivotY = topTexture.height - _radius;
            top.y = gapHeight / -2;

            var bottom:Image = new Image(bottomTexture);
            bottom.pixelSnapping = true;
            bottom.pivotX = _radius;
            bottom.pivotY = _radius;
            bottom.y = gapHeight / 2;

            addChild(top);
            addChild(bottom);
        }

        public function collidesWithBird(birdX:Number, birdY:Number, birdRadius:Number):Boolean
        {
            return false;
        }

        public function get passed():Boolean { return _passed; }
        public function set passed(value:Boolean):void { _passed = value; }
    }
}
