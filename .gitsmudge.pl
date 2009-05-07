#!perl5.11.0.exe -p -w
exit;
use POSIX qw(strftime);
$branch = `git-symbolic-ref HEAD`; chomp($branch);
$rev = `git-rev-list -n 1 $branch`; chomp($rev);
open REV, "git show --pretty=raw $rev|";
$time = time; # default to current time
while (<REV>) {
    if (/^committer.* (\d+) [\-+]\d*$/) {
        $time = $1;
    }
}
close REV;

$date = strftime "%Y-%m-%d %H:%M:%S", localtime($time);
while (<>) {
    s#\$Date$]*\$#\$Date$date\$#;
    print;
}
