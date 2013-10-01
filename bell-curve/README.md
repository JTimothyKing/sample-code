bell-curve.pl6
==============

Perl 6 script to randomly flip a coin and plot the number of heads.

Inspired by a free-form hacking session with P6, which resulted in the following one-liner
(here split into mulitple lines for readability):

```
my $max = 10;
my %n;
%n{ ((True, False).pick for 1..$max).grep({$_}).elems }++ for 1..($max*100);
say( "$_: ", '*' x (%n{$_}/5 // 0) ) for 0..$max;
```

This produed the output:

<pre>
0: 
1: *
2: *******
3: ************************
4: **************************************
5: *****************************************************
6: ***************************************
7: ***************************
8: ******
9: **
10: 
</pre>
