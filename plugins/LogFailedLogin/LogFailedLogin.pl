package MT::Plugin::LogFailedLogin;
use strict;
use warnings;
use base 'MT::Plugin';

use MT::Auth;
use MT::Auth::MT;
use MT::Author qw( AUTHOR );
use MT::Log;

our $VER  = '0.01';
our $NAME = ( split /::/, __PACKAGE__ )[-1];

my $plugin = __PACKAGE__->new({
    name        => $NAME,
    id          => lc $NAME,
    key         => lc $NAME,
    l10n_class  => $NAME . '::L10N',
    version     => $VER,
    author_name => 'masiuchi',
    author_link => 'https://github.com/masiuchi/',
    plugin_link => 'https://github.com/masiuchi/mt-plugin-log-failed-login/',
    description => '<__trans phrase="Log failed login attempt.">',
});
MT->add_plugin( $plugin );

{
    my $orig = \&MT::Auth::MT::validate_credentials;

    no warnings 'redefine';
    *MT::Auth::MT::validate_credentials = sub {
        my ( $auth, $ctx ) = @_;
        my $res = $orig->( $auth, $ctx );

        if ( MT::Auth::INVALID_PASSWORD() == $res ) {
            my $app = $ctx->{app};
            
            # get author
            my ( $author ) = $app->user_class->search({
                name      => $ctx->{username},
                type      => AUTHOR,
                auth_type => 'MT',
            });

            # log message
            $app->log({
                message   => $plugin->translate(
                    "Failed login attempt by user '[_1]' (ID:[_2])",
                    $author->name,
                    $author->id,
                ),
                author_id => $author->id,
                level     => MT::Log::SECURITY(),
                category  => 'login_user',
                class     => 'author',
            });
        }

        return $res;
    };
}

1;
__END__

