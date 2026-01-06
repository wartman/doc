package doc.std;

using haxe.io.Path;
using sys.FileSystem;

@:allow(doc.std)
class StdFileSystem {
	private static function maybeStat(path:String):Option<Stat> {
		if (!path.exists()) return None;
		var data = FileSystem.stat(path);
		return Some({
			path: path,
			mode: data.mode,
			size: data.size,
			ctime: data.ctime,
			mtime: data.mtime,
			atime: data.atime,
			uid: data.uid,
			gid: data.gid
		});
	}

	private static function findFileSystemEntry(path:String):FileSystemEntry {
		return switch maybeStat(path) {
			case None:
				FileSystemEntry.Missing(new StdMissing(path));
			case Some(stat) if (path.isDirectory()):
				FileSystemEntry.Directory(stat, new StdDirectory(path));
			case Some(stat):
				FileSystemEntry.File(stat, new StdFile(path));
		}
	}
}
