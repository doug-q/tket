OPENQASM 2.0;
include "hqslib1.inc";

qreg q[1];
creg a[2];
creg b[3];
creg c[4];
creg d[1];
creg tk_SCRATCH_BIT[6];
c = 2;
c = a;
if(b!=2) c[1] = b[1] & a[1];
if(b!=2) c[1] = a[0] | c[1];
c = b & a;
c = d | c;
d = 1;
CCE(c);
d[0] = a[0] ^ d[0];
if(c>=2) h q[0];
a = CCE(a, b);
if(c<=2) h q[0];
if(c<=1) h q[0];
if(c>=3) h q[0];
if(c!=2) h q[0];
if(d[0]==1) rx(1.0*pi) q[0];