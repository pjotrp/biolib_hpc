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
    current_seq.reserve(2048);
    read_rec(); // read the first record
  }

  string current_id; 
  string current_seq;
  string lastline = null;  // last line read

  /* 
   * read_rec sets current_id (null at eof), and current_seq. It uses lastline
   * to buffer the FASTA tag of the next record - so there are no seeks
   */
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
  }
  auto count = 0;
  private bool eof() { return !has_fasta || f.eof(); }
  // D iterator functions for 'foreach'
  // the foreach iteration sequence is repeating: empty, front, popFront!
  @property bool empty( ) { return current_id == null; }
  @property auto front() { return new Tuple!(string,string)(current_id[1..$],current_seq); }
  void popFront() { read_rec(); }
}
