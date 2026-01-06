package doc.std;

using doc.std.StdFileSystem;
using haxe.io.Path;
using sys.FileSystem;

class StdDirectory implements Directory {
	final path:String;

	public function new(path) {
		this.path = path;
	}

	public function stat():Promise<Stat> {
		return switch path.maybeStat() {
			case Some(stat): stat;
			case None: new Error(NotAcceptable, 'Not a directory ${path}');
		}
	}

	public function entry(subPath:String):Promise<FileSystemEntry> {
		return Path.join([path, subPath]).normalize().findFileSystemEntry();
	}

	public function list():Promise<Array<FileSystemEntry>> {
		var items = Error.catchExceptions(() -> FileSystem.readDirectory(path)).orReturn();
		return [for (item in items) Path.join([path, item]).normalize().findFileSystemEntry()];
	}

	public function file(subPath:String):File {
		return new StdFile(Path.join([path, subPath]));
	}

	public function directory(subPath:String):Directory {
		return new StdDirectory(Path.join([path, subPath]));
	}
}
