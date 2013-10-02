/*
 * A JavaScript implementation of the Secure Hash Algorithm, SHA-512, as defined
 * in FIPS 180-2
 * Version 2.2 Copyright Anonymous Contributor, Paul Johnston 2000 - 2009.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for details.
 */
dojo.provide("wm.packages.zabonline.crypt.SHA512");

dojo.declare("SHA512", null, {
  constructor: function (hc, b64) {
    console.debug('Start SHA512.constructor');

    this.sha512_k;
    this.hexcase = hc;
    this.b64pad = b64;

    console.debug('End SHA512.constructor');
  },
  hex_sha512: function (s) {
    return this.rstr2hex(this.rstr_sha512(this.str2rstr_utf8(s)));
  },
  b64_sha512: function (s) {
    return this.rstr2b64(this.rstr_sha512(this.str2rstr_utf8(s)));
  },
  any_sha512: function (s, e) {
    return this.rstr2any(this.rstr_sha512(this.str2rstr_utf8(s)), e);
  },
  hex_hmac_sha512: function (k, d) {
    return this.rstr2hex(this.rstr_hmac_sha512(this.str2rstr_utf8(k), this.str2rstr_utf8(d)));
  },
  b64_hmac_sha512: function (k, d) {
    return this.rstr2b64(this.rstr_hmac_sha512(this.str2rstr_utf8(k), this.str2rstr_utf8(d)));
  },
  any_hmac_sha512: function (k, d, e) {
    return this.rstr2any(this.rstr_hmac_sha512(this.str2rstr_utf8(k), this.str2rstr_utf8(d)), e);
  },
  rstr_sha512: function (s) {
    return this.binb2rstr(this.binb_sha512(this.rstr2binb(s), s.length * 8));
  },
  rstr_hmac_sha512: function (key, data) {
    var bkey = this.rstr2binb(key);
    if (bkey.length > 32) bkey = this.binb_sha512(bkey, key.length * 8);

    var ipad = Array(32),
      opad = Array(32);
    for (var i = 0; i < 32; i++) {
      ipad[i] = bkey[i] ^ 0x36363636;
      opad[i] = bkey[i] ^ 0x5C5C5C5C;
    }

    var hash = this.binb_sha512(ipad.concat(this.rstr2binb(data)), 1024 + data.length * 8);
    return this.binb2rstr(binb_sha512(opad.concat(hash), 1024 + 512));
  },
  rstr2hex: function (input) {
    try {
      this.hexcase;
    } catch (e) {
      this.hexcase = 0;
    }
    var hex_tab = this.hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
    var output = "";
    var x;
    for (var i = 0; i < input.length; i++) {
      x = input.charCodeAt(i);
      output += hex_tab.charAt((x >>> 4) & 0x0F) + hex_tab.charAt(x & 0x0F);
    }
    return output;
  },
  rstr2b64: function (input) {
    try {
      this.b64pad;
    } catch (e) {
      this.b64pad = '';
    }
    var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var output = "";
    var len = input.length;
    for (var i = 0; i < len; i += 3) {
      var triplet = (input.charCodeAt(i) << 16) | (i + 1 < len ? input.charCodeAt(i + 1) << 8 : 0) | (i + 2 < len ? input.charCodeAt(i + 2) : 0);
      for (var j = 0; j < 4; j++) {
        if (i * 8 + j * 6 > input.length * 8) output += this.b64pad;
        else output += tab.charAt((triplet >>> 6 * (3 - j)) & 0x3F);
      }
    }
    return output;
  },
  rstr2any: function (input, encoding) {
    var divisor = encoding.length;
    var i, j, q, x, quotient;

    /* Convert to an array of 16-bit big-endian values, forming the dividend */
    var dividend = Array(Math.ceil(input.length / 2));
    for (i = 0; i < dividend.length; i++) {
      dividend[i] = (input.charCodeAt(i * 2) << 8) | input.charCodeAt(i * 2 + 1);
    }

    /*
     * Repeatedly perform a long division. The binary array forms the dividend,
     * the length of the encoding is the divisor. Once computed, the quotient
     * forms the dividend for the next step. All remainders are stored for later
     * use.
     */
    var full_length = Math.ceil(input.length * 8 /
      (Math.log(encoding.length) / Math.log(2)));
    var remainders = Array(full_length);
    for (j = 0; j < full_length; j++) {
      quotient = Array();
      x = 0;
      for (i = 0; i < dividend.length; i++) {
        x = (x << 16) + dividend[i];
        q = Math.floor(x / divisor);
        x -= q * divisor;
        if (quotient.length > 0 || q > 0)
          quotient[quotient.length] = q;
      }
      remainders[j] = x;
      dividend = quotient;
    }
    /* Convert the remainders to the output string */
    var output = "";
    for (i = remainders.length - 1; i >= 0; i--)
      output += encoding.charAt(remainders[i]);

    return output;
  },
  str2rstr_utf8: function (input) {
    var output = "";
    var i = -1;
    var x, y;

    while (++i < input.length) {
      /* Decode utf-16 surrogate pairs */
      x = input.charCodeAt(i);
      y = i + 1 < input.length ? input.charCodeAt(i + 1) : 0;
      if (0xD800 <= x && x <= 0xDBFF && 0xDC00 <= y && y <= 0xDFFF) {
        x = 0x10000 + ((x & 0x03FF) << 10) + (y & 0x03FF);
        i++;
      }

      /* Encode output as utf-8 */
      if (x <= 0x7F)
        output += String.fromCharCode(x);
      else if (x <= 0x7FF)
        output += String.fromCharCode(0xC0 | ((x >>> 6) & 0x1F),
          0x80 | (x & 0x3F));
      else if (x <= 0xFFFF)
        output += String.fromCharCode(0xE0 | ((x >>> 12) & 0x0F),
          0x80 | ((x >>> 6) & 0x3F),
          0x80 | (x & 0x3F));
      else if (x <= 0x1FFFFF)
        output += String.fromCharCode(0xF0 | ((x >>> 18) & 0x07),
          0x80 | ((x >>> 12) & 0x3F),
          0x80 | ((x >>> 6) & 0x3F),
          0x80 | (x & 0x3F));
    }
    return output;
  },
  str2rstr_utf16le: function (input) {
    var output = "";
    for (var i = 0; i < input.length; i++)
      output += String.fromCharCode(input.charCodeAt(i) & 0xFF, (input.charCodeAt(i) >>> 8) & 0xFF);
    return output;
  },
  str2rstr_utf16be: function (input) {
    var output = "";
    for (var i = 0; i < input.length; i++)
      output += String.fromCharCode((input.charCodeAt(i) >>> 8) & 0xFF,
        input.charCodeAt(i) & 0xFF);
    return output;
  },
  rstr2binb: function (input) {
    var output = Array(input.length >> 2);
    for (var i = 0; i < output.length; i++)
      output[i] = 0;
    for (var i = 0; i < input.length * 8; i += 8)
      output[i >> 5] |= (input.charCodeAt(i / 8) & 0xFF) << (24 - i % 32);
    return output;
  },
  binb2rstr: function (input) {
    var output = "";
    for (var i = 0; i < input.length * 32; i += 8)
      output += String.fromCharCode((input[i >> 5] >>> (24 - i % 32)) & 0xFF);
    return output;
  },
  binb_sha512: function (x, len) {

    if (this.sha512_k == undefined) {
      //SHA512 constants
      sha512_k = new Array(
        new this.int64(0x428a2f98, -685199838), new this.int64(0x71374491, 0x23ef65cd),
        new this.int64(-1245643825, -330482897), new this.int64(-373957723, -2121671748),
        new this.int64(0x3956c25b, -213338824), new this.int64(0x59f111f1, -1241133031),
        new this.int64(-1841331548, -1357295717), new this.int64(-1424204075, -630357736),
        new this.int64(-670586216, -1560083902), new this.int64(0x12835b01, 0x45706fbe),
        new this.int64(0x243185be, 0x4ee4b28c), new this.int64(0x550c7dc3, -704662302),
        new this.int64(0x72be5d74, -226784913), new this.int64(-2132889090, 0x3b1696b1),
        new this.int64(-1680079193, 0x25c71235), new this.int64(-1046744716, -815192428),
        new this.int64(-459576895, -1628353838), new this.int64(-272742522, 0x384f25e3),
        new this.int64(0xfc19dc6, -1953704523), new this.int64(0x240ca1cc, 0x77ac9c65),
        new this.int64(0x2de92c6f, 0x592b0275), new this.int64(0x4a7484aa, 0x6ea6e483),
        new this.int64(0x5cb0a9dc, -1119749164), new this.int64(0x76f988da, -2096016459),
        new this.int64(-1740746414, -295247957), new this.int64(-1473132947, 0x2db43210),
        new this.int64(-1341970488, -1728372417), new this.int64(-1084653625, -1091629340),
        new this.int64(-958395405, 0x3da88fc2), new this.int64(-710438585, -1828018395),
        new this.int64(0x6ca6351, -536640913), new this.int64(0x14292967, 0xa0e6e70),
        new this.int64(0x27b70a85, 0x46d22ffc), new this.int64(0x2e1b2138, 0x5c26c926),
        new this.int64(0x4d2c6dfc, 0x5ac42aed), new this.int64(0x53380d13, -1651133473),
        new this.int64(0x650a7354, -1951439906), new this.int64(0x766a0abb, 0x3c77b2a8),
        new this.int64(-2117940946, 0x47edaee6), new this.int64(-1838011259, 0x1482353b),
        new this.int64(-1564481375, 0x4cf10364), new this.int64(-1474664885, -1136513023),
        new this.int64(-1035236496, -789014639), new this.int64(-949202525, 0x654be30),
        new this.int64(-778901479, -688958952), new this.int64(-694614492, 0x5565a910),
        new this.int64(-200395387, 0x5771202a), new this.int64(0x106aa070, 0x32bbd1b8),
        new this.int64(0x19a4c116, -1194143544), new this.int64(0x1e376c08, 0x5141ab53),
        new this.int64(0x2748774c, -544281703), new this.int64(0x34b0bcb5, -509917016),
        new this.int64(0x391c0cb3, -976659869), new this.int64(0x4ed8aa4a, -482243893),
        new this.int64(0x5b9cca4f, 0x7763e373), new this.int64(0x682e6ff3, -692930397),
        new this.int64(0x748f82ee, 0x5defb2fc), new this.int64(0x78a5636f, 0x43172f60),
        new this.int64(-2067236844, -1578062990), new this.int64(-1933114872, 0x1a6439ec),
        new this.int64(-1866530822, 0x23631e28), new this.int64(-1538233109, -561857047),
        new this.int64(-1090935817, -1295615723), new this.int64(-965641998, -479046869),
        new this.int64(-903397682, -366583396), new this.int64(-779700025, 0x21c0c207),
        new this.int64(-354779690, -840897762), new this.int64(-176337025, -294727304),
        new this.int64(0x6f067aa, 0x72176fba), new this.int64(0xa637dc5, -1563912026),
        new this.int64(0x113f9804, -1090974290), new this.int64(0x1b710b35, 0x131c471b),
        new this.int64(0x28db77f5, 0x23047d84), new this.int64(0x32caab7b, 0x40c72493),
        new this.int64(0x3c9ebe0a, 0x15c9bebc), new this.int64(0x431d67c4, -1676669620),
        new this.int64(0x4cc5d4be, -885112138), new this.int64(0x597f299c, -60457430),
        new this.int64(0x5fcb6fab, 0x3ad6faec), new this.int64(0x6c44198c, 0x4a475817));
    }

    //Initial hash values
    var H = new Array(
      new this.int64(0x6a09e667, -205731576),
      new this.int64(-1150833019, -2067093701),
      new this.int64(0x3c6ef372, -23791573),
      new this.int64(-1521486534, 0x5f1d36f1),
      new this.int64(0x510e527f, -1377402159),
      new this.int64(-1694144372, 0x2b3e6c1f),
      new this.int64(0x1f83d9ab, -79577749),
      new this.int64(0x5be0cd19, 0x137e2179));

    var T1 = new this.int64(0, 0),
      T2 = new this.int64(0, 0),
      a = new this.int64(0, 0),
      b = new this.int64(0, 0),
      c = new this.int64(0, 0),
      d = new this.int64(0, 0),
      e = new this.int64(0, 0),
      f = new this.int64(0, 0),
      g = new this.int64(0, 0),
      h = new this.int64(0, 0),
      //Temporary variables not specified by the document
      s0 = new this.int64(0, 0),
      s1 = new this.int64(0, 0),
      Ch = new this.int64(0, 0),
      Maj = new this.int64(0, 0),
      r1 = new this.int64(0, 0),
      r2 = new this.int64(0, 0),
      r3 = new this.int64(0, 0);
    var j, i;
    var W = new Array(80);
    for (i = 0; i < 80; i++)
      W[i] = new this.int64(0, 0);

    // append padding to the source string. The format is described in the FIPS.
    x[len >> 5] |= 0x80 << (24 - (len & 0x1f));
    x[((len + 128 >> 10) << 5) + 31] = len;

    for (i = 0; i < x.length; i += 32) //32 dwords is the block size
    {
      this.int64copy(a, H[0]);
      this.int64copy(b, H[1]);
      this.int64copy(c, H[2]);
      this.int64copy(d, H[3]);
      this.int64copy(e, H[4]);
      this.int64copy(f, H[5]);
      this.int64copy(g, H[6]);
      this.int64copy(h, H[7]);

      for (j = 0; j < 16; j++) {
        W[j].h = x[i + 2 * j];
        W[j].l = x[i + 2 * j + 1];
      }

      for (j = 16; j < 80; j++) {
        //sigma1
        this.int64rrot(r1, W[j - 2], 19);
        this.int64revrrot(r2, W[j - 2], 29);
        this.int64shr(r3, W[j - 2], 6);
        s1.l = r1.l ^ r2.l ^ r3.l;
        s1.h = r1.h ^ r2.h ^ r3.h;
        //sigma0
        this.int64rrot(r1, W[j - 15], 1);
        this.int64rrot(r2, W[j - 15], 8);
        this.int64shr(r3, W[j - 15], 7);
        s0.l = r1.l ^ r2.l ^ r3.l;
        s0.h = r1.h ^ r2.h ^ r3.h;

        this.int64add4(W[j], s1, W[j - 7], s0, W[j - 16]);
      }

      for (j = 0; j < 80; j++) {
        //Ch
        Ch.l = (e.l & f.l) ^ (~e.l & g.l);
        Ch.h = (e.h & f.h) ^ (~e.h & g.h);

        //Sigma1
        this.int64rrot(r1, e, 14);
        this.int64rrot(r2, e, 18);
        this.int64revrrot(r3, e, 9);
        s1.l = r1.l ^ r2.l ^ r3.l;
        s1.h = r1.h ^ r2.h ^ r3.h;

        //Sigma0
        this.int64rrot(r1, a, 28);
        this.int64revrrot(r2, a, 2);
        this.int64revrrot(r3, a, 7);
        s0.l = r1.l ^ r2.l ^ r3.l;
        s0.h = r1.h ^ r2.h ^ r3.h;

        //Maj
        Maj.l = (a.l & b.l) ^ (a.l & c.l) ^ (b.l & c.l);
        Maj.h = (a.h & b.h) ^ (a.h & c.h) ^ (b.h & c.h);

        this.int64add5(T1, h, s1, Ch, sha512_k[j], W[j]);
        this.int64add(T2, s0, Maj);

        this.int64copy(h, g);
        this.int64copy(g, f);
        this.int64copy(f, e);
        this.int64add(e, d, T1);
        this.int64copy(d, c);
        this.int64copy(c, b);
        this.int64copy(b, a);
        this.int64add(a, T1, T2);
      }
      this.int64add(H[0], H[0], a);
      this.int64add(H[1], H[1], b);
      this.int64add(H[2], H[2], c);
      this.int64add(H[3], H[3], d);
      this.int64add(H[4], H[4], e);
      this.int64add(H[5], H[5], f);
      this.int64add(H[6], H[6], g);
      this.int64add(H[7], H[7], h);
    }

    //represent the hash as an array of 32-bit dwords
    var hash = new Array(16);
    for (i = 0; i < 8; i++) {
      hash[2 * i] = H[i].h;
      hash[2 * i + 1] = H[i].l;
    }
    return hash;
  },
  int64: function (h, l) {
    this.h = h;
    this.l = l;
    //this.toString = int64toString;
  },
  int64copy: function (dst, src) {
    dst.h = src.h;
    dst.l = src.l;
  },
  int64rrot: function (dst, x, shift) {
    dst.l = (x.l >>> shift) | (x.h << (32 - shift));
    dst.h = (x.h >>> shift) | (x.l << (32 - shift));
  },
  int64revrrot: function (dst, x, shift) {
    dst.l = (x.h >>> shift) | (x.l << (32 - shift));
    dst.h = (x.l >>> shift) | (x.h << (32 - shift));
  },
  int64shr: function (dst, x, shift) {
    dst.l = (x.l >>> shift) | (x.h << (32 - shift));
    dst.h = (x.h >>> shift);
  },
  int64add: function (dst, x, y) {
    var w0 = (x.l & 0xffff) + (y.l & 0xffff);
    var w1 = (x.l >>> 16) + (y.l >>> 16) + (w0 >>> 16);
    var w2 = (x.h & 0xffff) + (y.h & 0xffff) + (w1 >>> 16);
    var w3 = (x.h >>> 16) + (y.h >>> 16) + (w2 >>> 16);
    dst.l = (w0 & 0xffff) | (w1 << 16);
    dst.h = (w2 & 0xffff) | (w3 << 16);
  },
  int64add4: function (dst, a, b, c, d) {
    var w0 = (a.l & 0xffff) + (b.l & 0xffff) + (c.l & 0xffff) + (d.l & 0xffff);
    var w1 = (a.l >>> 16) + (b.l >>> 16) + (c.l >>> 16) + (d.l >>> 16) + (w0 >>> 16);
    var w2 = (a.h & 0xffff) + (b.h & 0xffff) + (c.h & 0xffff) + (d.h & 0xffff) + (w1 >>> 16);
    var w3 = (a.h >>> 16) + (b.h >>> 16) + (c.h >>> 16) + (d.h >>> 16) + (w2 >>> 16);
    dst.l = (w0 & 0xffff) | (w1 << 16);
    dst.h = (w2 & 0xffff) | (w3 << 16);
  },
  int64add5: function (dst, a, b, c, d, e) {
    var w0 = (a.l & 0xffff) + (b.l & 0xffff) + (c.l & 0xffff) + (d.l & 0xffff) + (e.l & 0xffff);
    var w1 = (a.l >>> 16) + (b.l >>> 16) + (c.l >>> 16) + (d.l >>> 16) + (e.l >>> 16) + (w0 >>> 16);
    var w2 = (a.h & 0xffff) + (b.h & 0xffff) + (c.h & 0xffff) + (d.h & 0xffff) + (e.h & 0xffff) + (w1 >>> 16);
    var w3 = (a.h >>> 16) + (b.h >>> 16) + (c.h >>> 16) + (d.h >>> 16) + (e.h >>> 16) + (w2 >>> 16);
    dst.l = (w0 & 0xffff) | (w1 << 16);
    dst.h = (w2 & 0xffff) | (w3 << 16);
  }
});