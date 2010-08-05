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

my $response = $s3->buckets;
foreach my $bucket ( @{ $response->{buckets} } ) {
    print "You have a bucket: " . $bucket->bucket . "\n";
}

# create a new bucket 
my $bucket = $s3->add_bucket( { bucket => $bucketname } )
    or die $s3->err . ": " . $s3->errstr;

# store a file in the bucket
$bucket->add_key_filename('assets/rooster.jpg', 'assets/rooster.jpg',
    { content_type => 'image/jpeg', },
) or die $s3->err . ": " . $s3->errstr;

# list files in the bucket
$response = $bucket->list_all
    or die $s3->err . ": " . $s3->errstr;

foreach my $key ( @{ $response->{keys} } ) {
    my $key_name = $key->{key};
    my $key_size = $key->{size};
    print "Bucket contains key '$key_name' of size $key_size\n";
}
