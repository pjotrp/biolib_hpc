/**
 * Fetch FASTA sequences for GFF3
 */

module gff3fasta;

import std.stdio; 
import std.string;
import std.typecons;

class GFF3Fasta {

  private File f;
  immutable bool has_fasta;

  this(File f, bool has_fasta) {
    this.f = f;
    this.has_fasta = has_fasta;
  }

  string id, next_id = null;
  string seq;

  @property bool empty( ) { 
    return f.eof || !has_fasta;
  }
  @property auto front() { return new Tuple!(string,string)(id,seq); }
  void popFront() { 
    if (next_id != null) {
      id = next_id;
      next_id = null;
    } 
    else 
    {
      do {
        id = strip(f.readln()); 
      } while (id == "" && !empty());  // skip empty lines
    }
    // make sure it is an id!
    if (id[0] != '>')
      throw new Exception("FASTA corrupt " ~ id);
    seq = "";
    string buf;
    do {
      buf = strip(f.readln());
      if (buf.length > 0 && buf[0] == '>') {
        next_id = buf;
        return;
      }
      seq ~= buf;
    } while (!empty()); 
  }

}
