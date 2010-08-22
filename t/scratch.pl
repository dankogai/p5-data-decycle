#
# $Id$
#
use strict;
use warnings;
use Scalar::Util qw/isweak/;
use Data::Decycle;

local $Data::Decycle::DEBUG = 2;

{
    package Dummy;
    sub DESTROY {
        warn "($_[0]) is being DESTROY()ed";
    }
}

{
    my $guard = Data::Decycle->new;
    add $guard my $cyclic_sref = bless \my $dummy, 'Dummy';
    $cyclic_sref = \$cyclic_sref;
    add $guard my $cyclic_aref = bless [], 'Dummy';
    $cyclic_aref->[0] = $cyclic_aref;
    add $guard my $cyclic_href = bless {}, 'Dummy';
    $cyclic_href->{cyclic} = $cyclic_href;
}

{
    my $guard = Data::Decycle->new(
        my $cyclic_sref = ( bless \my $dummy, 'Dummy' ),
        my $cyclic_aref = ( bless [], 'Dummy' ),
        my $cyclic_href = ( bless {}, 'Dummy' )
    );
    $cyclic_sref           = \$cyclic_sref;
    $cyclic_aref->[0]      = $cyclic_aref;
    $cyclic_href->{cyclic} = $cyclic_href;
}

__END__
{
    my $guard = Data::Decycle->new;
    $guard->add(my $cyclic_sref = bless \my $dummy, 'Dummy');
    $cyclic_sref = \$cyclic_sref;
    $guard->add(my $cyclic_aref = bless [], 'Dummy');
    $cyclic_aref->[0] = $cyclic_aref;
    $guard->add(my $cyclic_href = bless {}, 'Dummy');
    $cyclic_href->{cyclic} =  $cyclic_href;
}



__END__
