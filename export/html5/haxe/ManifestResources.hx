package;

import haxe.io.Bytes;
import haxe.io.Path;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

#if disable_preloader_assets
@:dox(hide) class ManifestResources {
	public static var preloadLibraries:Array<Dynamic>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;

	public static function init (config:Dynamic):Void {
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
	}
}
#else
@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

			if(!StringTools.endsWith (rootPath, "/")) {

				rootPath += "/";

			}

		}

		if (rootPath == null) {

			#if (ios || tvos || webassembly)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif (console || sys)
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		data = '{"name":null,"assets":"aoy4:pathy36:assets%2Fmusic%2Fmusic-goes-here.txty4:sizezy4:typey4:TEXTy2:idR1y7:preloadtgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R7R6tgoR0y38:assets%2Fimages%2Ftilemaps%2Flight.pngR2i87R3y5:IMAGER5R8R6tgoR0y41:assets%2Fimages%2Ftilemaps%2FtilesDBG.pngR2i641R3R9R5R10R6tgoR0y42:assets%2Fimages%2Fparticles%2Fbloodpng.pngR2i431R3R9R5R11R6tgoR0y40:assets%2Fimages%2Fparticles%2Fswoosh.pngR2i270R3R9R5R12R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R4R5R13R6tgoR0y34:assets%2Fdata%2Fdata-goes-here.txtR2zR3R4R5R14R6tgoR0y26:assets%2Fdata%2Flevel.jsonR2i10505642R3R4R5R15R6tgoR0y25:assets%2Fdata%2Fogmo.ogmoR2i3441R3R4R5R16R6tgoR0y33:assets%2Fdata%2Flevel%20copy.jsonR2i10002751R3R4R5R17R6tgoR0y50:assets%2Fdata%2Fgenrooms%2FRoomStraight-copy0.jsonR2i20295R3R4R5R18R6tgoR0y44:assets%2Fdata%2Fgenrooms%2FRoomStraight.jsonR2i17318R3R4R5R19R6tgoR0y40:assets%2Fdata%2Fgenrooms%2FRoomgsUD.jsonR2i20585R3R4R5R20R6tgoR0y42:assets%2Fdata%2Fgenrooms%2FRoomCorner.jsonR2i17318R3R4R5R21R6tgoR0y37:assets%2Fdata%2Fgenrooms%2FRoomX.jsonR2i18389R3R4R5R22R6tgoR0y49:assets%2Fdata%2Fgenrooms%2FRoomCornerCounter.jsonR2i17318R3R4R5R23R6tgoR0y37:assets%2Fdata%2Fgenrooms%2FRoomT.jsonR2i17798R3R4R5R24R6tgoR0y26:assets%2Fdata%2Fempty.jsonR2i6052R3R4R5R25R6tgoR2i8220R3y5:MUSICR5y26:flixel%2Fsounds%2Fbeep.mp3y9:pathGroupaR27y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R26R5y28:flixel%2Fsounds%2Fflixel.mp3R28aR30y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i33629R3y5:SOUNDR5R31R28aR30R31hgoR2i6840R3R32R5R29R28aR27R29hgoR2i15744R3y4:FONTy9:classNamey35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R33R34y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i277R3R9R5R39R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i505R3R9R5R40R6tgoR0y42:flixel%2Fimages%2Ftransitions%2Fcircle.pngR2i824R3R9R5R41R6tgoR0y42:flixel%2Fimages%2Ftransitions%2Fsquare.pngR2i383R3R9R5R42R6tgoR0y53:flixel%2Fimages%2Ftransitions%2Fdiagonal_gradient.pngR2i3812R3R9R5R43R6tgoR0y43:flixel%2Fimages%2Ftransitions%2Fdiamond.pngR2i788R3R9R5R44R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

	}


}

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tilemaps_light_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tilemaps_tilesdbg_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_particles_bloodpng_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_particles_swoosh_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_level_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_ogmo_ogmo extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_level_copy_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomstraight_copy0_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomstraight_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomgsud_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomcorner_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomx_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomcornercounter_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomt_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_empty_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_circle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_square_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_diagonal_gradient_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_diamond_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/tilemaps/light.png") @:noCompletion #if display private #end class __ASSET__assets_images_tilemaps_light_png extends lime.graphics.Image {}
@:keep @:image("assets/images/tilemaps/tilesDBG.png") @:noCompletion #if display private #end class __ASSET__assets_images_tilemaps_tilesdbg_png extends lime.graphics.Image {}
@:keep @:image("assets/images/particles/bloodpng.png") @:noCompletion #if display private #end class __ASSET__assets_images_particles_bloodpng_png extends lime.graphics.Image {}
@:keep @:image("assets/images/particles/swoosh.png") @:noCompletion #if display private #end class __ASSET__assets_images_particles_swoosh_png extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/data/level.json") @:noCompletion #if display private #end class __ASSET__assets_data_level_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/ogmo.ogmo") @:noCompletion #if display private #end class __ASSET__assets_data_ogmo_ogmo extends haxe.io.Bytes {}
@:keep @:file("assets/data/level copy.json") @:noCompletion #if display private #end class __ASSET__assets_data_level_copy_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/genrooms/RoomStraight-copy0.json") @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomstraight_copy0_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/genrooms/RoomStraight.json") @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomstraight_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/genrooms/RoomgsUD.json") @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomgsud_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/genrooms/RoomCorner.json") @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomcorner_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/genrooms/RoomX.json") @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomx_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/genrooms/RoomCornerCounter.json") @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomcornercounter_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/genrooms/RoomT.json") @:noCompletion #if display private #end class __ASSET__assets_data_genrooms_roomt_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/empty.json") @:noCompletion #if display private #end class __ASSET__assets_data_empty_json extends haxe.io.Bytes {}
@:keep @:file("/home/deck/haxelib/flixel/5,8,0/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("/home/deck/haxelib/flixel/5,8,0/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("/home/deck/haxelib/flixel/5,8,0/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:file("/home/deck/haxelib/flixel/5,8,0/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("export/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("/home/deck/haxelib/flixel/5,8,0/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("/home/deck/haxelib/flixel/5,8,0/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:image("/home/deck/haxelib/flixel-addons/3,2,3/assets/images/transitions/circle.png") @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_circle_png extends lime.graphics.Image {}
@:keep @:image("/home/deck/haxelib/flixel-addons/3,2,3/assets/images/transitions/square.png") @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_square_png extends lime.graphics.Image {}
@:keep @:image("/home/deck/haxelib/flixel-addons/3,2,3/assets/images/transitions/diagonal_gradient.png") @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_diagonal_gradient_png extends lime.graphics.Image {}
@:keep @:image("/home/deck/haxelib/flixel-addons/3,2,3/assets/images/transitions/diamond.png") @:noCompletion #if display private #end class __ASSET__flixel_images_transitions_diamond_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end