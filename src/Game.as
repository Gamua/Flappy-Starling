package
{
    import starling.display.Sprite;
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
        }

        public static function get assets():AssetManager
        {
            return sAssets;
        }
    }
}
