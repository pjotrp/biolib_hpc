/**
 * Iterate through a GFF3 file
 */

module read_gff3_file;

import std.stdio;
import std.path;

class ReadGFF3 {
  private File f;

  this(in string filename) {
    f = File(filename,"r");
  }
}

unittest {
  writeln("Unit test " ~ __FILE__);
  alias std.path.join join;
  auto fn = dirname(__FILE__) ~ sep ~ join("..","test","data","standard.gff3");
  writeln("  - reading CSV " ~ fn);
  auto reader = new ReadGFF3(fn);
  // foreach(mrna ; reader) {
  // }
}
