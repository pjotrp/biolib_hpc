/**
 * Iterate through a GFF3 file
 */

module read_gff3_file;

import std.stdio;
import std.path;
import std.string;

import gff3fasta;
import gff3line;

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
  ulong line_number = 0;
  bool has_fasta = false;

  string readln() { 
    line_number++;
    auto res = f.readln();
    return (res.length>1? res[0..$-1] : res); 
  };

  @property bool eof() { return f.eof; }

  @property bool empty( ) { 
    if (buf == "##FASTA") {
      has_fasta = true;
      return true;
    }
    return eof;
  }
  @property auto front() { return buf; }
  void popFront() { 
    do {
      line_number++;
      buf = readln();
    } while (buf == "" && !empty());  // skip empty lines
  }

  GFF3Fasta fasta_seqs() {
    return new GFF3Fasta(this);
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
    // writeln(reader.line_number,":\t",rec);
    if (reader.line_number == 32) {
      auto seqid = get_seq_id(rec);
      // writeln(reader.line_number,":\t",seqid);
      assert(seqid,"Contig1");
    }
  }
  if (reader.has_fasta) {
    ulong[] lines;
    string [] ids;
    foreach(seq ; reader.fasta_seqs) {
      lines ~= reader.line_number;
      ids ~= seq[0][0];
      // writeln(reader.line_number,":\t",seq[0][0]);
    }
    assert(lines == [126,135]);
    assert(ids == ["test01","test02"]);
  }
}
