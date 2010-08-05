package Setup;

our (@EXPORT_OK);
use base qw(Exporter);
@EXPORT_OK = qw(getS3Keys);

sub trim($);
sub parseLine($);

sub getS3Keys {
    open (FILE, $ENV{HOME} . '/.boto');
    my $offset = 0;

    (my $aws_access_key_id, my $aws_secret_access_key);

    while (my $line = <FILE>) {
        chomp($line);
        if ($offset==1) {
            $aws_access_key_id = parseLine($line);
        }

        if ($offset==2) {
            $aws_secret_access_key = parseLine($line);
        }
        $offset += 1;

    }

    return  ($aws_access_key_id, $aws_secret_access_key);
}

sub parseLine($)
{
    my $line = shift;
    my @comps = split('=', $line);
    return trim($comps[1]);
}


# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}
