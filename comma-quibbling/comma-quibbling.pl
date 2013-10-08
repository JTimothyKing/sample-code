#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

# See http://blog.nu42.com/2013/10/comma-quibbling-in-perl.html

use Test::More;

run();

sub run {
    my @cases = (
        [[], ''],
        [[qw(ABC)], 'ABC'],
        [[qw(ABC DEF)], 'ABC and DEF'],
        [[qw(ABC DEF G H)], 'ABC, DEF, G and H'],
    );

    for my $case (@cases) {
        my ($case, $expected) = @$case;
        is(comma_quibbling($case), $expected);
    }
    done_testing;
    return;
}

sub comma_quibbling {
    my $items = shift;
    return join(' and ' =>
        join(', ' => @$items[ 0 .. (@$items - 2) ]) || (),
        $items->[-1] || (),
    );
}

# end
