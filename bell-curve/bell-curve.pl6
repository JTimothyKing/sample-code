#!/usr/bin/env perl6
use v6;

=NAME bell-curve.pl6 - Randomly flip a coin and plot the number of heads

=begin USAGE

./bell-curve.pl6 [--num-trials=<Int>] [--num-flips=<Int>] [--display-columns=<Int>]

Flips a coin C<--num-flips> times, repeats for C<--num-trials>, then displays a histogram of
the number of trials vs. number of heads.

    =item C<--num-trials> defaults to 100.

    =item C<--num-flips> defaults to 10.

    =item C<--display-columns> defaults to 80.

=end USAGE

sub USAGE () {
    use Pod::To::Text;
    say pod2text( $=pod.grep({ try .name eq 'USAGE' }) );
}


sub MAIN(Int :$num-trials = 100,
         Int :$num-flips = 10,
         Int :$display-columns = 80) {

    my Bool enum CoinFaces <<:Heads(True) :Tails(False)>>;

    my %trials-of-flips;

    for 1..$num-trials {
        print "trial# $_\r";
        my $num_flips = ( CoinFaces.pick for 1..$num-flips ).grep(* == Heads).elems;
        %trials-of-flips{ $num_flips }++;
    };


    # NOTE: Does not strictly limit displayed columns to specified width.
    # Just takes a shot-in-the-dark estimate. In reality, the columns used will be:
    #   17
    #   + Int( ([max] values %trials-of-flips) / $trials-per-display-column )
    #   + ([max] (values %trials-of-flips)>>.chars)

    my $trials-per-display-column = ceiling( ($num-trials/2) / $display-columns );

    my sub n-trials-str ($trials) {
        return "$trials trial{'s' if $trials != 1}";
    }
    say "# heads:     * = {n-trials-str($trials-per-display-column)}";
    for 0..$num-flips {
        my $trials = %trials-of-flips{$_} // 0;
        say sprintf('%7s: ', $_),
            '*' x ($trials / $trials-per-display-column),
            " ({n-trials-str($trials)})";
    }
}

# end
