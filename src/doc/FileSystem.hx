package doc;

@:forward
abstract FileSystem(Directory) to Directory {
	public static function ofCwd() {
		#if (nodejs || sys)
		return of(Sys.getCwd());
		#else
		#error 'FileSystem is not available on this platform'
		#end
	}

	@:from public static function of(path:String):FileSystem {
		return new FileSystem(path);
	}

	public function new(path:String) {
		#if (nodejs || sys)
		this = new doc.std.StdDirectory(path);
		#else
		#error 'FileSystem is not available on this platform'
		#end
	}
}
