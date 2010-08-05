#!/opt/local/bin/perl
# Upload an image from my local computer to my s3 account.
# Majority of this code was taken from module docs here:
# http://search.cpan.org/dist/Net-Amazon-S3/lib/Net/Amazon/S3.pm
use strict;
use Net::Amazon::S3;
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

# fetch file from the bucket
$response = $bucket->get_key_filename('assets/rooster.jpg', 'GET', 'assets/new_rooster.jpg')
    or die $s3->err . ": " . $s3->errstr;

