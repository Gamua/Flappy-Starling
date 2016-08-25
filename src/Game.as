package
{
    import starling.display.Sprite;
    import starling.utils.AssetManager;

    public class Game extends Sprite
    {
        private static var sAssets:AssetManager;

        public function Game()
        { }

        public function start(assets:AssetManager):void
        {
            sAssets = assets;
        }

        public static function get assets():AssetManager
        {
            return sAssets;
        }
    }
}
