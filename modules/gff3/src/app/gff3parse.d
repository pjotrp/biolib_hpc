/**
 * Parser main entry point
 */

import std.stdio;

import read_gff3_file;

int main(string[] args) {
  writeln("gff3parse (BioLib/HPC)\n");
  string[] filelist;
  foreach (arg ; args[1..$]) {
    if (arg[0] != '-') {
      filelist ~= arg;
    }
    else {
      switch(arg) {
        case "-h":
        case "--help" : 
          writeln("
    Usage: gff3parse filename(s)
          ");
          break;
        default: 
          throw new Exception("Unknown switch " ~ arg);
          break;
      }
    }
  }
  foreach(fn ; filelist) {
    writeln("Parsing "~fn);
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
  return 0;
}

