package
{
    import flash.geom.Rectangle;

    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class World extends Sprite
    {
        private static const SCROLL_VELOCITY:Number = 130;
        private static const FLAP_VELOCITY:Number = -300;
        private static const GRAVITY:Number = 800;
        private static const BIRD_RADIUS:Number = 18;

        private var _width:Number;
        private var _height:Number;
        private var _ground:Image;
        private var _bird:MovieClip;
        private var _birdVelocity:Number = 0.0;

        public function World(width:Number, height:Number)
        {
            _width = width;
            _height = height;

            addBackground();
            addGround();
            addBird();
        }

        // setup methods

        private function addBackground():void
        {
            var skyTexture:Texture = Game.assets.getTexture("sky");
            var sky:Image = new Image(skyTexture);
            sky.y = _height - skyTexture.height;
            addChild(sky);

            var cloud1:Image = new Image(Game.assets.getTexture("cloud-1"));
            cloud1.x = _width * 0.5;
            cloud1.y = _height * 0.1;
            addChild(cloud1);

            var cloud2:Image = new Image(Game.assets.getTexture("cloud-2"));
            cloud2.x = _width * 0.1;
            cloud2.y = _height * 0.2;
            addChild(cloud2);
        }

        private function addBird():void
        {
            var birdTextures:Vector.<Texture> = Game.assets.getTextures("bird-");
            birdTextures.push(birdTextures[1]);

            _bird = new MovieClip(birdTextures);
            _bird.pivotX = 46;
            _bird.pivotY = 45;
            _bird.pixelSnapping = true;

            addChild(_bird);
            resetBird();
        }

        private function addGround():void
        {
            var tile:Texture = Game.assets.getTexture("ground");

            _ground = new Image(tile);
            _ground.y = _height - tile.height;
            _ground.width = _width;
            _ground.tileGrid = new Rectangle(0, 0, tile.width, tile.height);
            addChild(_ground);
        }

        // helper methods

        private function resetBird():void
        {
            _bird.x = _width / 3;
            _bird.y = _height / 2;
        }

        private function checkForCollisions():void
        {
            var bottom:Number = _ground.y - BIRD_RADIUS;

            if (_bird.y > bottom)
            {
                _bird.y = bottom;
                _birdVelocity = 0;
            }
        }

        public function flapBird():void
        {
            _birdVelocity = FLAP_VELOCITY;
        }

        // time-related methods

        public function advanceTime(passedTime:Number):void
        {
            _bird.advanceTime(passedTime);
            advanceGround(passedTime);
            advancePhysics(passedTime);
            checkForCollisions();
        }

        private function advanceGround(passedTime:Number):void
        {
            var distance:Number = SCROLL_VELOCITY * passedTime;

            _ground.tileGrid.x -= distance;
            _ground.tileGrid = _ground.tileGrid;
        }

        private function advancePhysics(passedTime:Number):void
        {
            _bird.y += _birdVelocity * passedTime;
            _birdVelocity += GRAVITY * passedTime;
        }
    }
}
