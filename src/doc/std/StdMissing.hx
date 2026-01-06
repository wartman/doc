package doc.std;

using haxe.io.Path;
using sys.FileSystem;

class StdMissing implements Missing {
	public final path:String;

	public function new(path:String) {
		this.path = path.normalize();
	}

	public function createDirectory():Promise<Directory> {
		if (path.exists()) return (new StdDirectory(path) : Directory);
		return Error.catchExceptions(() -> {
			path.createDirectory();
			(new StdDirectory(path) : Directory);
		});
	}

	public function createFile():Promise<File> {
		if (path.exists()) return new Error(NotAcceptable, 'File already exists: $path');
		return Error.catchExceptions(() -> {
			// Note: this does not actually create the file until the user
			// saves something to it.
			return (new StdFile(path) : File);
		});
	}
}
