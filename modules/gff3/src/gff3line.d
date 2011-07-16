/**
 * Line parser functions
 */

module gff3line;

import std.string;

/**
 * Get the GFF3 seqid
 */

auto get_seq_id(string s) {
  auto i = indexOf(s,'\t');
  return (i > 1 ? s[0..i] : null);
}

/**
 * Split the GFF3 record into fields (string type)
 */

auto fields(string s) {
  // return split(s,"\t"); - the following is 20% faster.
  string[] res;
  auto len = s.length;
  auto first = 0;
  for(uint i = 0; i<len; i++) {
    if (s[i] == '\t') {
      res ~= s[first..i-1];
      first = i;
    }
  }
  res ~= s[first..$];
  return res;
}

