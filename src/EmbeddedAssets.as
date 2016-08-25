package
{
    public class EmbeddedAssets
    {
        /** ATTENTION: Naming conventions!
         *
         *  - Classes for embedded IMAGES should have the exact same name as the file,
         *    without extension. This is required so that references from XMLs (atlas, bitmap font)
         *    won't break.
         *
         *  - Atlas and font XML files can have an arbitrary name, since they are never
         *    referenced by file name.
         *
         */

        // Texture Atlas

        [Embed(source="../assets/textures/1x/atlas.xml", mimeType="application/octet-stream")]
        public static const atlas_xml:Class;

        [Embed(source="../assets/textures/1x/atlas.png")]
        public static const atlas:Class;

        // Bitmap Fonts

        [Embed(source="../assets/fonts/1x/bradybunch.fnt", mimeType="application/octet-stream")]
        public static const bradybunch_fnt:Class;

        [Embed(source="../assets/fonts/1x/bradybunch.png")]
        public static const bradybunch:Class;
    }
}
