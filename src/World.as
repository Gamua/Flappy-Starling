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
        private static const OBSTACLE_DISTANCE:Number = 180;
        private static const OBSTACLE_GAP_HEIGHT:Number = 170;

        public static const BIRD_CRASHED:String = "birdCrashed";
        public static const OBSTACLE_PASSED:String = "obstaclePassed";

        public static const PHASE_IDLE:String = "phaseIdle";
        public static const PHASE_PLAYING:String = "phasePlaying";
        public static const PHASE_CRASHED:String = "phaseCrashed";

        private var _phase:String;
        private var _width:Number;
        private var _height:Number;
        private var _ground:Image;
        private var _obstacles:Sprite;
        private var _bird:MovieClip;
        private var _birdVelocity:Number = 0.0;

        private var _currentX:Number;
        private var _lastObstacleX:Number;

        public function World(width:Number, height:Number)
        {
            _phase = PHASE_IDLE;
            _width = width;
            _height = height;

            addBackground();
            addObstacleSprite();
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

        private function addObstacleSprite():void
        {
            _obstacles = new Sprite();
            addChild(_obstacles);
        }

        private function addObstacle():void
        {
            var minY:Number = OBSTACLE_GAP_HEIGHT / 2;
            var maxY:Number = _ground.y - OBSTACLE_GAP_HEIGHT / 2;
            var obstacle:Obstacle = new Obstacle(OBSTACLE_GAP_HEIGHT);
            obstacle.y = minY + Math.random() * (maxY - minY);
            obstacle.x = _width + obstacle.width / 2;
            _obstacles.addChild(obstacle);
        }

        // game control

        public function start():void
        {
            _phase = PHASE_PLAYING;
            _currentX = _lastObstacleX = 0;
        }

        public function reset():void
        {
            _phase = PHASE_IDLE;
            _obstacles.removeChildren(0, -1, true);
            resetBird();
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
            var collision:Boolean = false;

            if (_bird.y > bottom)
            {
                _bird.y = bottom;
                _birdVelocity = 0;
                collision = true;
            }
            else
            {
                for (var i:int=0; i < _obstacles.numChildren; ++i)
                {
                    var obstacle:Obstacle = _obstacles.getChildAt(i) as Obstacle;

                    if (!obstacle.passed && _bird.x > obstacle.x)
                    {
                        obstacle.passed = true;
                        dispatchEventWith(OBSTACLE_PASSED, true);
                    }

                    if (obstacle.collidesWithBird(_bird.x, _bird.y, BIRD_RADIUS))
                    {
                        collision = true;
                        break;
                    }
                }
            }

            if (collision)
            {
                _phase = PHASE_CRASHED;
                dispatchEventWith(BIRD_CRASHED);
            }
        }

        public function flapBird():void
        {
            _birdVelocity = FLAP_VELOCITY;
        }

        // time-related methods

        public function advanceTime(passedTime:Number):void
        {
            if (_phase == PHASE_IDLE || _phase == PHASE_PLAYING)
            {
                _bird.advanceTime(passedTime);
                advanceGround(passedTime);
            }

            if (_phase == PHASE_PLAYING)
            {
                _currentX += SCROLL_VELOCITY * passedTime;
                advanceObstacles(passedTime);
                advancePhysics(passedTime);
                checkForCollisions();
            }
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

        private function advanceObstacles(passedTime:Number):void
        {
            if (_currentX >= _lastObstacleX + OBSTACLE_DISTANCE)
            {
                _lastObstacleX = _currentX;
                addObstacle();
            }

            var obstacle:Obstacle;
            var numObstacles:int = _obstacles.numChildren;

            for (var i:int=0; i<numObstacles; ++i)
            {
                obstacle = _obstacles.getChildAt(i) as Obstacle;

                if (obstacle.x < -obstacle.width)
                {
                    i--; numObstacles--;
                    obstacle.removeFromParent(true);
                }
                else obstacle.x -= passedTime * SCROLL_VELOCITY;
            }
        }

        // properties

        public function get phase():String { return _phase; }
    }
}
