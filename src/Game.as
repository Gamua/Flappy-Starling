package
{
    import flash.net.SharedObject;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.text.TextFormat;
    import starling.utils.AssetManager;
    import starling.utils.Color;

    public class Game extends Sprite
    {
        private static var sAssets:AssetManager;
        private static var sDefaultTextFormat:TextFormat =
            new TextFormat("bradybunch", BitmapFont.NATIVE_SIZE, Color.WHITE);

        private var _world:World;
        private var _score:int;
        private var _scoreLabel:TextField;
        private var _title:TitleOverlay;
        private var _sharedObject:SharedObject;

        public function Game()
        {
            _sharedObject = SharedObject.getLocal("flappy-data");
        }

        public function start(assets:AssetManager):void
        {
            sAssets = assets;

            _world = new World(stage.stageWidth, stage.stageHeight);
            _world.addEventListener(World.BIRD_CRASHED, onBirdCollided);
            _world.addEventListener(World.OBSTACLE_PASSED, onObstaclePassed);
            addChild(_world);

            _scoreLabel = new TextField(100, 80, "", sDefaultTextFormat);
            _scoreLabel.visible = false;
            addChild(_scoreLabel);

            _title = new TitleOverlay(stage.stageWidth, stage.stageHeight);
            addChild(_title);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            stage.addEventListener(TouchEvent.TOUCH, onTouch);

            showTitle();
        }

        private function restart():void
        {
            _scoreLabel.visible = false;
            _world.reset();
            showTitle();
        }

        private function showTitle():void
        {
            _title.alpha = 0;
            _title.topScore = topScore;

            Starling.juggler.tween(_title, 1.0, { alpha: 1.0 });
        }

        private function hideTitle():void
        {
            Starling.juggler.removeTweens(_title);
            Starling.juggler.tween(_title, 0.5, { alpha: 0.0 });
        }

        private function onEnterFrame(event:Event, passedTime:Number):void
        {
            _world.advanceTime(passedTime);
        }

        private function onBirdCollided():void
        {
            if (_score > topScore)
                topScore = _score;

            Starling.juggler.delayCall(restart, 1.5);
        }

        private function onObstaclePassed():void
        {
            this.score += 1;
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
            if (touch)
            {
                if (_world.phase == World.PHASE_IDLE)
                {
                    hideTitle();
                    this.score = 0;
                    _scoreLabel.visible = true;
                    _world.start();
                }

                _world.flapBird();
            }
        }

        private function get score():int { return _score; }
        private function set score(value:int):void
        {
            _score = value;
            _scoreLabel.text = value.toString();
        }

        private function get topScore():int
        {
            return int(_sharedObject.data["topScore"]);
        }

        private function set topScore(value:int):void
        {
            _sharedObject.data["topScore"] = value;
        }

        public static function get assets():AssetManager
        {
            return sAssets;
        }
    }
}
