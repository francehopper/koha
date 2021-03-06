#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use C4::Auth;
use C4::Serials;
use C4::Acquisition;
use C4::Output;
use C4::Bookseller;
use C4::Context;
use C4::Letters;
my $input = new CGI;

my $serialid = $input->param('serialid');
my $op = $input->param('op');
my $claimletter = $input->param('claimletter');
my $supplierid = $input->param('supplierid');
my $suppliername = $input->param('suppliername');
my $order = $input->param('order');
my %supplierlist = GetSuppliersWithLateIssues();

# open template first (security & userenv set here)
my ($template, $loggedinuser, $cookie)
= get_template_and_user({template_name => "serials/claims.tmpl",
            query => $input,
            type => "intranet",
            authnotrequired => 0,
            flagsrequired => {serials => 1},
            debug => 1,
            });
my $supplier_loop = [];
foreach my $s_id (sort {$supplierlist{$a} cmp $supplierlist{$b} } keys %supplierlist){
        my ($count) = GetLateOrMissingIssues($s_id,q{},$order);
        push @{$supplier_loop}, {
            id   => $s_id,
            name => $supplierlist{$s_id} . "($count)",
            selected => ( $supplierid && $supplierid == $s_id ),
        };
}

my $letters = GetLetters('claimissues');
my @letters;
foreach (keys %{$letters}){
    push @letters ,{code=>$_,name=> $letters->{$_}};
}

my $letter=((scalar(@letters)>1) || ($letters[0]->{name}||$letters[0]->{code}));
my ($count2, @missingissues);
if ($supplierid) {
    ($count2, @missingissues) = GetLateOrMissingIssues($supplierid,$serialid,$order);
}

my ($singlesupplier,@supplierinfo);
if($supplierid){
   (@supplierinfo)=GetBookSeller($supplierid);
} else { # set up supplierid for the claim links out of main table if all suppliers is chosen
   for my $mi (@missingissues){
       $mi->{supplierid} = getsupplierbyserialid($mi->{serialid});
   }
}

my $preview=0;
if($op && $op eq 'preview'){
    $preview = 1;
}
if ($op eq "send_alert"){
  my @serialnums=$input->param("serialid");
  SendAlerts('claimissues',\@serialnums,$input->param("letter_code"));
  my $cntupdate=UpdateClaimdateIssues(\@serialnums);
  ### $cntupdate SHOULD be equal to scalar(@$serialnums)
  $template->param('SHOWCONFIRMATION' => 1);
  $template->param('suppliername' => $suppliername);
}

$template->param('letters'=>\@letters,'letter'=>$letter);
$template->param(
        order =>$order,
        supplier_loop => $supplier_loop,
        phone => $supplierinfo[0]->{phone},
        booksellerfax => $supplierinfo[0]->{booksellerfax},
        bookselleremail => $supplierinfo[0]->{bookselleremail},
        preview => $preview,
        missingissues => \@missingissues,
        supplierid => $supplierid,
        claimletter => $claimletter,
        singlesupplier => $singlesupplier,
        supplierloop => \@supplierinfo,
        dateformat    => C4::Context->preference("dateformat"),
    	DHTMLcalendar_dateformat => C4::Dates->DHTMLcalendar(),
        );
output_html_with_http_headers $input, $cookie, $template->output;
