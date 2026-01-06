package doc;

interface Directory {
	/**
		Get info about this directory.
	**/
	public function stat():Promise<Stat>;

	/**
		List all entries in this directory.
	**/
	public function list():Promise<Array<FileSystemEntry>>;

	/**
		Check the given path and return a FileSystemEntry that describes what the 
		entry is. This method is useful if you need to check for the existence of 
		a file first.
	**/
	public function entry(path:String):Promise<FileSystemEntry>;

	/**
		Create a file handler relative to this Directory. This method 
		will not check that the file exists first -- use `entry` for that. 
	**/
	public function file(path:String):File;

	/**
		Create a file directory relative to this Directory. This method 
		will not check that the directory exists first -- use `entry` for that. 
	**/
	public function directory(path:String):Directory;
}
