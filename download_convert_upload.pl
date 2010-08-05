#!/opt/local/bin/perl
# Upload an image from my local computer to my s3 account.
# Majority of this code was taken from module docs here:
# http://search.cpan.org/dist/Net-Amazon-S3/lib/Net/Amazon/S3.pm
use strict;
use Net::Amazon::S3;
use Graphics::Magick;
use Setup qw(getS3Keys);
use lib qw(./);


(my $aws_access_key_id, my $aws_secret_access_key) = getS3Keys();


my $s3 = Net::Amazon::S3->new(
    {   
        aws_access_key_id       =>  $aws_access_key_id,
        aws_secret_access_key   =>  $aws_secret_access_key,
        retry                   =>  1,
    }
);

my $bucketname = 'assets.sodalabs.com'; # @TODO change sodalabs to your domain

my $bucket = $s3->add_bucket( { bucket => $bucketname } );

print "Fetching file from the bucket...\n";
my $response = $bucket->get_key_filename('assets/rooster.jpg', 'GET', 'assets/new_rooster.jpg')
    or die $s3->err . ": " . $s3->errstr;

print "Doing conversion...\n";
my $downloaded_file = './assets/new_rooster.jpg';
my ($image, $status);
my $image = new Graphics::Magick;
my $status = $image->Read($downloaded_file);
warn "$status" if "$status";

annotate($image);

$image->write('./assets/converted_rooster.jpg');

undef $image;

sub annotate {
    my ($image) = @_;
    my $font_file = './COOLVETI.TTF';
    my $status = $image->Annotate(text=>"ec2 graphicsmagick perl pwned", geometry=>'5x5+350+350', font=>$font_file, pointsize=>100, fill=>'white');
    warn "$status" if "$status";
}


