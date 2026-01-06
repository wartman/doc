package doc.std;

import sys.io.File as HaxeFile;
// import tink.io.Sink;
// import tink.io.Source;

using doc.std.StdFileSystem;
using haxe.io.Path;
using sys.FileSystem;

class StdFile implements File {
	final path:String;

	public function new(path) {
		this.path = path;
	}

	public function stat():Promise<Stat> {
		return switch path.maybeStat() {
			case Some(stat): stat;
			case None: new Error(NotFound, 'File not found: $path');
		}
	}

	public function write(contents:String):Promise<Stat> {
		return path.directory()
			.findFileSystemEntry()
			.ensureDirectory()
			.next(_ -> Error.catchExceptions(() -> HaxeFile.saveContent(path, contents)))
			.next(_ -> stat());
	}

	public function read():Promise<String> {
		if (!path.exists()) return new Error(NotFound, 'File not found: $path');
		return Error.catchExceptions(() -> HaxeFile.getContent(path));
	}

	public function copy(toPath:String):Promise<File> {
		if (!path.exists()) return new Error(NotFound, 'File not found: $path');
		if (toPath.exists()) return new Error(NotAcceptable, 'File already exists: $path');
		return Error
			.catchExceptions(() -> HaxeFile.copy(path, toPath))
			.next(_ -> toPath.findFileSystemEntry().tryFile());
	}

	public function delete():Promise<Bool> {
		if (!path.exists() || path.isDirectory()) return false;
		path.deleteFile();
		return true;
	}

	// public function open():RealSource {
	// 	return Source.ofInput('Input: $path', HaxeFile.read(path, true));
	// }

	// public function pipe():RealSink {
	// 	return Sink.ofOutput('Output: $path', HaxeFile.write(path, true));
	// }
}
