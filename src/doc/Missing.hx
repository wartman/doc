package doc;

interface Missing {
	public final path:String;
	public function createDirectory():Promise<Directory>;
	public function createFile():Promise<File>;
}
