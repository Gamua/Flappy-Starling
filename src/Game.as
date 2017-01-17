package
{
    import starling.core.Starling;
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
            _world.addEventListener(World.BIRD_CRASHED, onBirdCollided);
            addChild(_world);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            stage.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function restart():void
        {
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

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
            if (touch)
            {
                if (_world.phase == World.PHASE_IDLE)
                    _world.start();

                _world.flapBird();
            }
        }

        public static function get assets():AssetManager
        {
            return sAssets;
        }
    }
}
