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
            // check if bird is completely left or right of the obstacle
            if (birdX + birdRadius < x - _radius || birdX - birdRadius > x + _radius)
                return false;

            var bottomY:Number = y + _gapHeight / 2;
            var topY:Number = y - _gapHeight / 2;

            // check if bird is within gap
            if (birdY < topY || birdY > bottomY)
                return true;

            // check for collision with circular end pieces
            var distX:Number = x - birdX;
            var distY:Number;

            // top trunk
            distY = topY - birdY;
            if (Math.sqrt(distX * distX + distY * distY) < _radius + birdRadius)
                return true;

            // bottom trunk
            distY = bottomY - birdY;
            if (Math.sqrt(distX * distX + distY * distY) < _radius + birdRadius)
                return true;

            // bird flies through in-between the circles
            return false;
        }

        public function get passed():Boolean { return _passed; }
        public function set passed(value:Boolean):void { _passed = value; }
    }
}
