package doc;

// import tink.io.Sink;
// import tink.io.Source;

interface File {
	public function stat():Promise<Stat>;
	public function write(contents:String):Promise<Stat>;
	public function read():Promise<String>;
	public function copy(toPath:String):Promise<File>;
	public function delete():Promise<Bool>;
	// public function open():RealSource;
	// public function pipe():RealSink;
}
