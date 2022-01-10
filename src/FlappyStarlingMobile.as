package
{
    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filesystem.File;

    import starling.assets.AssetManager;
    import starling.core.Starling;
    import starling.events.Event;
    import starling.utils.StringUtil;

    import utils.ScreenSetup;

    [SWF(width="320", height="480", frameRate="60", backgroundColor="#d1f4f7")]
    public class FlappyStarlingMobile extends Sprite
    {
        private var _starling:Starling;

        public function FlappyStarlingMobile()
        {
            var screen:ScreenSetup = new ScreenSetup(
                stage.fullScreenWidth, stage.fullScreenHeight, [1, 2, 3]);

            _starling = new Starling(Game, stage, screen.viewPort);
            _starling.stage.stageWidth  = screen.stageWidth;
            _starling.stage.stageHeight = screen.stageHeight;
            _starling.skipUnchangedFrames = true;
            _starling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
            {
                loadAssets(screen.assetScale, startGame);
            });

            _starling.start();

            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });
            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(true); });
        }

        private function loadAssets(scale:int, onComplete:Function):void
        {
            var appDir:File = File.applicationDirectory;
            var assets:AssetManager = new AssetManager(scale);

            assets.enqueue(
                appDir.resolvePath(StringUtil.format("assets/fonts/{0}x", scale)),
                appDir.resolvePath(StringUtil.format("assets/textures/{0}x", scale)),
                appDir.resolvePath("assets/sounds")
            );

            assets.loadQueue(
                function onComplete():void
                {
                    startGame(assets);
                },
                function onError(error:String):void
                {
                    trace("Error while loading assets: " + error);
                });
        }

        private function startGame(assets:AssetManager):void
        {
            var game:Game = _starling.root as Game;
            game.start(assets);
        }
    }
}
