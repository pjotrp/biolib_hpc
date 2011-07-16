/**
 * Iterate through a GFF3 file
 */

module read_gff3_file;

import std.stdio;
import std.path;
import std.string;

import gff3fasta;

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
  bool has_fasta = false;

  @property bool empty( ) { 
    if (buf == "##FASTA") {
      has_fasta = true;
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

  GFF3Fasta fasta_seqs() {
    return new GFF3Fasta(f,has_fasta);
  }
}

unittest {
  writeln("Unit test " ~ __FILE__);
  alias std.path.join join;
  auto fn = dirname(__FILE__) ~ sep ~ join("..","test","data","test.gff3");
  // auto fn = "/export/data/gwp/m_hapla.WS226.annotations.gff3";
  writeln("  - reading " ~ fn);
  auto reader = new ReadGFF3(fn);
  foreach(rec ; reader) {
    writeln(rec);
  }
  if (reader.has_fasta) {
    foreach(seq ; reader.fasta_seqs) {
      writeln(seq[0][0]);
    }
  }
}
