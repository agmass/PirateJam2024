package shaders;

import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

class ColoredItemShader extends FlxShader
{


	@:glFragmentSource('
		#pragma header

        uniform vec4 replacementColor;

void main()
{
	vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    if (color.r >= 0.1 && color.g == 0.0 && color.b == 0.0) {
        gl_FragColor = vec4(replacementColor.r,replacementColor.g,replacementColor.b,color.a);
    } else {
        gl_FragColor = vec4(color.r,color.g,color.b,color.a);
    }
		
}'
	)
	
	public function new(color:FlxColor = FlxColor.BLUE)
	{
		super();
		this.replacementColor.value = [color.redFloat, color.greenFloat, color.blueFloat, color.alpha];
	}
}
