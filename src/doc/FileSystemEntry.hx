package doc;

@:using(FileSystemEntry.FileSystemEntryTools)
enum FileSystemEntry {
	File(stat:Stat, file:File);
	Directory(stat:Stat, directory:Directory);
	Missing(missing:Missing);
}

class FileSystemEntryTools {
	public static function tryDirectory(entry:FileSystemEntry):Outcome<Directory, Error> {
		return switch entry {
			case Directory(_, directory):
				Success(directory);
			case File(stat, _):
				Failure(new Error(NotAcceptable, 'Not a directory: ${stat.path}'));
			case Missing(missing):
				Failure(new Error(NotFound, 'Not found: ${missing.path}'));
		}
	}

	public static function ensureDirectory(entry:FileSystemEntry):Promise<Directory> {
		return switch entry {
			case Directory(_, directory):
				directory;
			case Missing(missing):
				missing.createDirectory();
			case File(stat, _):
				new Error(NotAcceptable, 'Not a directory: ${stat.path}');
		}
	}

	public static function tryFile(entry:FileSystemEntry):Outcome<File, Error> {
		return switch entry {
			case File(_, file):
				Success(file);
			case Directory(stat, _):
				Failure(new Error(NotAcceptable, 'Not a file: ${stat.path}'));
			case Missing(missing):
				Failure(new Error(NotFound, 'Not found: ${missing.path}'));
		}
	}

	public static function ensureFile(entry:FileSystemEntry):Promise<File> {
		return switch entry {
			case File(_, file):
				file;
			case Missing(missing):
				missing.createFile();
			case Directory(stat, _):
				new Error(NotAcceptable, 'Not a file: ${stat.path}');
		}
	}

	public static function tryEmpty(entry:FileSystemEntry):Outcome<Missing, Error> {
		return switch entry {
			case Missing(missing):
				Success(missing);
			case File(stat, _) | Directory(stat, _):
				Failure(new Error(NotAcceptable, 'Entry already exists: ${stat.path}'));
		}
	}
}
