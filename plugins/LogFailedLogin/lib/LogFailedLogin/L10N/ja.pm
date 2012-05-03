package LogFailedLogin::L10N::ja;
use strict;
use warnings;
use base 'LogFailedLogin::L10N';

our %Lexicon = (
    "Log failed login attempt."
        => "ログインの失敗をログに記録します。",
    "Failed login attempt by user '[_1]' (ID:[_2])",
        => "ユーザー'[_1]'(ID[_2])がログインに失敗しました。",
);

1;
__END__;
