package
{
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class World extends Sprite
    {
        private var _width:Number;
        private var _height:Number;

        public function World(width:Number, height:Number)
        {
            _width = width;
            _height = height;

            addBackground();
        }

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
    }
}
