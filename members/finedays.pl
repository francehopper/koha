#!/usr/bin/perl

# Copyright 2010 Xercode Media Software S.L.
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Koha; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
# Suite 330, Boston, MA  02111-1307 USA



use strict;
use C4::Context;
use C4::Auth;
use C4::Output;
use CGI;
use C4::Members;
use C4::Accounts;
use C4::Stats;
use C4::Koha;
use C4::Branch; # GetBranches

my $input = new CGI;

my ( $template, $loggedinuser, $cookie ) = get_template_and_user(
    {
        template_name   => "members/finedays.tmpl",
        query           => $input,
        type            => "intranet",
        authnotrequired => 0,
        flagsrequired   => { borrowers => 1 },
        debug           => 1,
    }
);

my $borrowernumber = $input->param('borrowernumber');
if ( $borrowernumber eq '' ) {
    $borrowernumber = $input->param('borrowernumber0');
}

# get borrower details
my $data = GetMember( borrowernumber => $borrowernumber );

my $user = $input->remote_user;

# get account details
my $branches = GetBranches();

my $branch   = GetBranch( $input, $branches );
=cut
my @names = $input->param;
my %inp;
=cut
my $check = 0;
=cut
warn Data::Dumper::Dumper($data);
for ( my $i = 0 ; $i < @names ; $i++ ) {
    my $temp = $input->param( $names[$i] );
    if ( $temp eq 'wo' ) {
        $inp{ $names[$i] } = $temp;
        $check = 1;
    }
    if ( $temp eq 'yes' ) {

# FIXME : using array +4, +5, +6 is dirty. Should use arrays for each accountline
        my $amount         = $input->param( $names[ $i + 4 ] );
        my $borrowernumber = $input->param( $names[ $i + 5 ] );
        my $accountno      = $input->param( $names[ $i + 6 ] );
        makepayment( $borrowernumber, $accountno, $amount, $user, $branch );
        $check = 2;
    }
}
warn "check ".$check;
=cut
my $total = $input->param('total');
if ( $check == 0 ) {
    

	my ($borrower_datedue,$allfile)= GetMemberAccountRecordsFinesDays($data);
    

	if ( $data->{'category_type'} eq 'C') {
	   my  ( $catcodes, $labels ) =  GetborCatFromCatType( 'A', 'WHERE category_type = ?' );
	   my $cnt = scalar(@$catcodes);
	   $template->param( 'CATCODE_MULTI' => 1) if $cnt > 1;
	   $template->param( 'catcode' =>    $catcodes->[0])  if $cnt == 1;
	}

	$template->param( adultborrower => 1 ) if ( $data->{'category_type'} eq 'A' );

	my ($picture, $dberror) = GetPatronImage($data->{'cardnumber'});
	$template->param( picture => 1 ) if $picture;
	
    $template->param(
        allfile        => $allfile,
        firstname      => $data->{'firstname'},
        surname        => $data->{'surname'},
        borrowernumber => $borrowernumber,
		cardnumber => $data->{'cardnumber'},
	    categorycode => $data->{'categorycode'},
	    category_type => $data->{'category_type'},
	    category_description => $data->{'description'},
	    address => $data->{'address'},
		address2 => $data->{'address2'},
	    city => $data->{'city'},
		zipcode => $data->{'zipcode'},
		phone => $data->{'phone'},
		email => $data->{'email'},
	    branchcode => $data->{'branchcode'},
		is_child        => ($data->{'category_type'} eq 'C'), 	    
        total          => sprintf( "%d", $total ),
        borrower_datedue => $borrower_datedue,
        
    );
    output_html_with_http_headers $input, $cookie, $template->output;

}else {

    my %inp;
    my @name = $input->param;
    for ( my $i = 0 ; $i < @name ; $i++ ) {
        my $test = $input->param( $name[$i] );
        if ( $test eq 'wo' ) {
            my $temp = $name[$i];
            $temp =~ s/payfine//;
            $inp{ $name[$i] } = $temp;
        }
    }
    my $borrowernumber;
    while ( my ( $key, $value ) = each %inp ) {

        my $accounttype = $input->param("accounttype$value");
        $borrowernumber = $input->param("borrowernumber$value");
        my $itemno    = $input->param("itemnumber$value");
        my $amount    = $input->param("amount$value");
        my $accountno = $input->param("accountno$value");
        forgetFinedays( $borrowernumber, $accountno, $itemno, $accounttype, $amount,$user,$branch);
    }
    $borrowernumber = $input->param('borrowernumber');
    print $input->redirect(
        "/cgi-bin/koha/members/boraccount.pl?borrowernumber=$borrowernumber");
}
