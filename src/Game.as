package
{
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

        public function Game()
        { }

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

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            stage.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function restart():void
        {
            _scoreLabel.visible = false;
            _world.reset();
        }

        private function onEnterFrame(event:Event, passedTime:Number):void
        {
            _world.advanceTime(passedTime);
        }

        private function onBirdCollided():void
        {
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

        public static function get assets():AssetManager
        {
            return sAssets;
        }
    }
}
