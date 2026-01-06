import doc.*;
import utest.Async;
import utest.Test;

using haxe.io.Path;
using tink.CoreApi;
using tink.ExtensionsApi;
using utest.Assert;

class TestAll extends Test {
  public function testCanReadFiles(async:Async) {
		FileSystem.ofCwd()
			.entry('test/res/text.txt')
      .next(entry -> entry.tryFile())
      .next(file -> file.read())
			.handle(outcome -> switch outcome {
        case Success(contents):
				  contents.equals('Contains text.');
          async.done();
        case Failure(failure):
          Assert.fail(failure.message);
          async.done();
			});
	}

	public function testCanOpenDirectories(async:Async) {
		FileSystem.ofCwd()
			.entry('test/res')
			.next(entry -> switch entry {
				case Directory(stat, dir):
					stat.path.equals(Path.join([Sys.getCwd(), 'test/res']).normalize());
					dir.list();
				default:
					new Error(NotFound, 'File not found');
			})
			.next(entries -> {
				entries.length.equals(1);
				switch entries {
					case [File(_, file)]:
						file.read();
					default:
					  new Error(NotAcceptable, 'Too many entries');
				}
			})
			.handle(outcome -> switch outcome {
        case Success(contents):
				  contents.equals('Contains text.');
          async.done();
        case Failure(failure):
          Assert.fail(failure.message);
          async.done();
			});
	}

	public function testWillReturnEmptyIfFileDoesNotExist(async:Async) {
		FileSystem.ofCwd()
			.entry('test/res/not-real.txt')
			.next(entry -> entry.tryEmpty())
			.inspect(empty -> empty.path.equals(Path.join([Sys.getCwd(), 'test/res/not-real.txt']).normalize()))
      .always(() -> async.done())
      .eager();
	}
}