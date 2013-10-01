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
    if m/^ \s* (\d+[\.\d+]?) [\s* x \s* (\d+)]? \s* $/ {
        my $height = +$0;
        my $num = +($1 || 1);
        %num_of_height{$height} += $num;
    } elsif ! m/^\s*$/ {
        note "Invalid line ignored: $_";
    }
}

#| unique book heights seen, in order from shortest to tallest
my @heights = sort { $^a <=> $^b }, keys %num_of_height;


say "Histogram data:";
for @heights -> $height {
    my $num = %num_of_height{$height};
    say "$height x $num";
}

#####################################################################

#| Display an actual histogram, with bars comprising ranges of book heights
sub display_histogram (:%num_of_height, :$shortest, :$tallest, :$span_width,
                       :$display_columns = 80) {
    my @histogram_bars;
    for $shortest, ($shortest + $span_width) ... $tallest -> $span_begin {
        my $span_end = $span_begin + $span_width;
        my $num = [+] (
            %num_of_height{$_} if $span_begin <= $_ < $span_end for keys %num_of_height
        );
        @histogram_bars.push({
            span_begin => $span_begin,
            span_end => $span_end,
            num => $num,
        });
    }

    # The number of display columns used in the histogram =
    #   25  # max number of static characters in each line
    #   + floor( ([max] @histogram_bars.map(*.<num>) / $num_per_display_column )
    #   + ([max] (@histogram_bars.map(*.<num>))>>.chars)
    #
    # Therefore, solving algebraically for $num_per_display_column, we get...
    my $num_per_display_column = ceiling(
        ([max] @histogram_bars.map(*.<num>)) /
          ( $display_columns - 25 - ([max] (@histogram_bars.map(*.<num>))>>.chars) )
    );

    my sub n_books_str ($num) {
        return "$num book{'s' if $num != 1}";
    }

    my sub height_span_str ($begin, $end) {
        my ($begin_str, $end_str) = ( sprintf('%2.1f', $_) for $begin, $end );
        return sprintf(' %4s ..^ %4s', $begin_str, $end_str);
    }

    say "";
    say "  height range:     * = {n_books_str($num_per_display_column)}";

    for @histogram_bars {
        my ($span_begin, $span_end, $num) = $_<span_begin span_end num>;
        say height_span_str($span_begin, $span_end), ': ',
            '*' x ($num / $num_per_display_column),
            " ({n_books_str($num)})";
    }
}

display_histogram(
    :%num_of_height, 
    shortest => floor(@heights[0]),
    tallest => ceiling(@heights[*-1]),
    span_width => 0.5,
);

#####################################################################

say "";

#| all books' heights, in order from shortest to tallest
my @all_heights = @heights >>xx<< %num_of_height{@heights};

say "min = ", @heights[0];      # same as [min] @heights, because @heights is in order
say "max = ", @heights[*-1];    # same as [max] @heights, because @heights is in order

my $num_heights = @all_heights.elems;
say "$num_heights measured";

sub median (@a) {
    return ( @a[ @a.elems / 2 ] + @a[ @a.end / 2 ] ) / 2;
}

say "median = ", median(@all_heights);

my $idx_median = @all_heights.end / 2;
my $median_is_datum = @all_heights.end %% 2;

say "first quartile = ", median(@all_heights[0 .. $idx_median]);
say "third quartile = ", median(@all_heights[ ($median_is_datum ?? $idx_median !! $idx_median+1) .. * ]);

# end
