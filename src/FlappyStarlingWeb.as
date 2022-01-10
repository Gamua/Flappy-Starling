package
{
    import flash.display.Sprite;

    import starling.assets.AssetManager;
    import starling.core.Starling;
    import starling.events.Event;

    [SWF(width="320", height="480", frameRate="60", backgroundColor="#d1f4f7")]
    public class FlappyStarlingWeb extends Sprite
    {
        private var _starling:Starling;

        public function FlappyStarlingWeb()
        {
            _starling = new Starling(Game, stage);
            _starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
            _starling.start();
        }

        private function onRootCreated(event:Event, game:Game):void
        {
            var assets:AssetManager = new AssetManager();
            assets.enqueue(EmbeddedAssets);
            assets.loadQueue(
                function(ratio:Number):void
                {
                    if (ratio == 1.0) game.start(assets);
                });
        }
    }
}
