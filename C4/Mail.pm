package C4::Mail;

use Mail::Sender;
use C4::Context;
use MIME::Base64;

use vars qw($VERSION @ISA @EXPORT);

BEGIN {
    require Exporter;
    $VERSION = 0.03;
    @ISA = qw(Exporter);
    @EXPORT = qw(
        &SendEmail
    );
}

=head1 NAME

C4::Mail - Funciones para trabajar con la clase Mail::Sender

=head1 SendEmail;

$to 		=> Correo destino del correo
$subject		=> Asunto
$message	=> Mensaje o body
@attachments	=> Array que contiene los ficheros que hay que enviar adjuntos ('/tmp/fichero1.txt','/tmp/fch2.txt') 

}

=cut

sub SendEmail {
	my ($to,$subject,$message,@attachments)=@_;
	my $sender = new Mail::Sender;
	my $auth;

	if (C4::Context->preference("MailAuthProtocol") eq "NO-AUTH"){
		$auth = "";
	}else{
		$auth = C4::Context->preference("MailAuthProtocol");
	}
	
	$sender->Body (C4::Context->preference("MailMessageCharset"),C4::Context->preference("MailMessageEncoding"),'text/html');
	
	if (scalar(@attachments) == 0){
		if ($sender->MailMsg({
			    smtp 	=>  C4::Context->preference("MailSmtp"),
			    from 	=>  C4::Context->preference("MailAccount"),
			    to 		=>  $to,
			    subject =>  $subject,
			    msg 	=>  $message,
			    auth 	=>  $auth,
			    authid 	=>  C4::Context->preference("MailUser"),
			    authpwd =>  C4::Context->preference("MailPassword"),
			  }) < 0) {
			  	$sender->Close;
			  	warn $sender->{'error'};
			   	return 0;
			}else{
				$sender->Close;
				return 1;
			}
	}else{
		if ($sender->MailFile({
			    smtp 	=>  C4::Context->preference("MailSmtp"),
			    from 	=>  C4::Context->preference("MailAccount"),
			    to 		=>  $to,
			    subject =>  $subject,
			    msg 	=>  $message,
			    auth 	=>  $auth,
			    authid 	=>  C4::Context->preference("MailUser"),
			    authpwd =>  C4::Context->preference("MailPassword"),
			    file	=>  @attachments,
			  }) < 0) {
			  	$sender->Close;
			  	warn $sender->{'error_msg'};
			   	return 0;
			}else{
				$sender->Close;
				return 1;
			}
	}
}
1;
__END__

=head1 NOTES

=head1 AUTHOR

Juan Romay
26/06/2008

=cut
