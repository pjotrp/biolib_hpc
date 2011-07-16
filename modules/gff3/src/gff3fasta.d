/**
 * Fetch FASTA current_sequences for GFF3
 */

module gff3fasta;

import std.stdio; 
import std.string;
import std.typecons;

/**
 * Helper class for reading the FASTA records related to a GFF3 file. It uses a 
 * File object, expecting it to point to the first record. 
 */

class GFF3Fasta {

  private File f;
  immutable bool has_fasta;

  this(File f, bool has_fasta) {
    this.f = f;
    this.has_fasta = has_fasta;
    read_rec(); // read the first record
  }

  string current_id = null; 
  string current_seq;
  string lastline = null;  // last line read

  private void read_rec() {
    if (eof()) { current_id = null; return; };

    if (lastline != null) 
      current_id = lastline;
    else 
      current_id = strip(f.readln()); 

    // make sure it is an current_id!
    if (current_id[0] != '>')
      throw new Exception("FASTA corrupt " ~ current_id);

    current_seq = "";
    string buf;
    do {
      buf = strip(f.readln());
      if (buf.length > 0 && buf[0] == '>') {
        lastline = buf;
        return; // done reading rec!
      }
      current_seq ~= buf;
    } while (!f.eof()); 
    lastline = null;
    writeln(current_id);
  }
  auto count = 0;
  private bool eof() { return !has_fasta || f.eof(); }
  @property bool empty( ) { if(count++ > 20) return true; writeln("empty", current_id); return current_id == null; }
  @property auto front() { writeln("front"); return new Tuple!(string,string)(current_id,current_seq); }

  void popFront() { 
    writeln("popFront");
    read_rec();
  }

}
