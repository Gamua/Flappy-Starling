package
{
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.utils.AssetManager;

    public class Game extends Sprite
    {
        private static var sAssets:AssetManager;

        private var _world:World;

        public function Game()
        { }

        public function start(assets:AssetManager):void
        {
            sAssets = assets;

            _world = new World(stage.stageWidth, stage.stageHeight);
            addChild(_world);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            stage.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function onEnterFrame(event:Event, passedTime:Number):void
        {
            _world.advanceTime(passedTime);
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
            if (touch)
            {
                _world.flapBird();
            }
        }

        public static function get assets():AssetManager
        {
            return sAssets;
        }
    }
}
