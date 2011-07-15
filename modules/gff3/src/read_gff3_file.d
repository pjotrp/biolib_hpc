/**
 * Iterate through a GFF3 file
 */

module read_gff3_file;

import std.stdio;
import std.path;
import std.string;

/**
 * This is the basic iterator wich goes over GFF3 records. After  
 * completing the records it can continue parsing FASTA sequences.
 */

class ReadGFF3 {
  private File f;

  this(in string filename) {
    f = File(filename,"r");
  }

  string buf;
  bool hit_fasta = false;

  @property bool empty( ) { 
    if (buf == "##FASTA") {
      hit_fasta = true;
      return true;
    }
    return f.eof;
  }
  @property ref string front() { return buf; }
  void popFront() { 
    do {
      buf = strip(f.readln()); 
    } while (buf == "" && !empty());  // skip empty lines
  }
}

unittest {
  writeln("Unit test " ~ __FILE__);
  alias std.path.join join;
  auto fn = dirname(__FILE__) ~ sep ~ join("..","test","data","test.gff3");
  writeln("  - reading CSV " ~ fn);
  auto reader = new ReadGFF3(fn);
  foreach(rec ; reader) {
    writeln(rec);
  }
}
