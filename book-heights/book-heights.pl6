#!/usr/bin/env perl6
use v6;

=NAME book-heights.pl6 - Find histogram and statistic data for heights of books

=begin USAGE

./book-heights.pl6 [<data-file-name> ... ]

Collects data on the heights of books (on a bookshelf) and dumps some information about
them.

If no data file(s) are specified, reads from standard-in.

The data is composed of lines, each containing a single book height. The book height
may be followed by 'x' and an integer number of books of that height. So, for example:

    8.5 x 3
    7
    8.5

This sequence lists 4 books of 8.5 inches each (or whatever unit) and 1 book of 7 inches.

=end USAGE


my %num_of_height;
for lines() {
    if m/^ \s* (\d+[\.\d+]?) [\s* x \s* (\d+)]? / {
        my $height = +$0;
        my $num = +($1 || 1);
        %num_of_height{$height} += $num;
    }
}

my @heights; #= book heights in order from shortest to tallest
say "Histogram data:";
for sort { $^a <=> $^b }, keys %num_of_height -> $height {
    my $num = %num_of_height{$height};
    say "$height x $num";
    @heights.push($height xx $num);
}


say "";

say "min = ", @heights[0];      # same as [min] @heights, because @heights is in order
say "max = ", @heights[*-1];    # same as [max] @heights, because @heights is in order

my $num_heights = @heights.elems;
say "$num_heights measured";

sub median (@a) {
    return ( @a[ @a.elems / 2 ] + @a[ @a.end / 2 ] ) / 2;
}

say "median = ", median(@heights);

my $idx_median = @heights.end / 2;
my $median_is_datum = @heights.end %% 2;

say "first quartile = ", median(@heights[0 .. $idx_median]);
say "third quartile = ", median(@heights[ ($median_is_datum ?? $idx_median !! $idx_median+1) .. * ]);

#say "";
#say "All heights:";
#say @heights.join("\n");

# end
