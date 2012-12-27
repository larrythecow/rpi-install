#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

sub error{
        print "ERROR Line: $_[0]";
        exit -1;
}

sub warning{
	print "WARN Line: $_[0]\n";
}

my $err;
my $device;
my $input;

print "please enter device\n\t";
$device=<stdin>;
print "WARNING!\n";
print "========\n";
print "This will overwrite data on $device irrevocably.\n\n";
print "Are you sure? (Type uppercase yes): ";
$input = <stdin>;
chomp($input);
if($input eq "YES"){
        print "\t OK\n";
}
else{
	print "Abort";
	error(__LINE__);
}



print "\t|-->installing necesserry programms\n";
#print `\tapt-get install debootstrap dosfstools` or error(__LINE__);

print "\t|-->formating partitions\n";
#`mkfs.vfat $device'1'` or error(__LINE__);
#`mkfs.ext4 $device'2'` or error(__LINE__);
#`mkswap $device'3'` or error(__LINE__);

print "\t|-->mounting partitions\n";
#`mount $device'2' /mnt` or warning(__LINE__);
#`mkdir /mnt/boot`;
#`mount $device'1' /mnt/boot` or warning(__LINE__);

print "\t|-->debootstrap, take a coffee\n";
#print `debootstrap --arch armhf wheezy /mnt/ http://mirrordirector.raspbian.org/raspbian/` or error(__LINE__);

print "\t|-->copying files\n";
$err = `install /etc/fstab /mnt/etc/fstab` or warning(__LINE__);
print $err;
$err = `install /etc/hosts /mnt/etc/` or error(__LINE__);
print $err;
`cp /proc/mounts  /mnt/etc/mtab` or error(__LINE__);
`cp -a /etc/apt/* /mnt/etc/apt/` or error(__LINE__);
`cp -a /root/rpi-install  /mnt/root/` or error(__LINE__);

print "\t|-->preparing and entering chroot\n";
`mount --bind /dev/ /mnt/dev/` or error(__LINE__);
`mount --bind /proc/ /mnt/proc/` or error(__LINE__);
`mount --bind /sys/ /mnt/sys/` or error(__LINE__);
#`chroot /mnt /root/rpi-install/chroot.sh` or error(__LINE__);

