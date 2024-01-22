use utf8;
use v5.30;
use feature qw(signatures state);
use warnings;
use Test::Most;

use IO::Socket;
use Path::Tiny;

require './gisp';
no warnings qw(experimental::signatures redefine);
{
    no warnings qw(once);
    $main::LOG_LEVEL = 1;
}

subtest 'make_uri()' => sub {

    subtest 'should return URI object' => sub {
        my $uri = make_uri('あ');
        isa_ok $uri, 'URI::http', 'make_uri() should return URI object';
    };

    subtest 'should contain valid URI string' => sub {
        my $uri = make_uri('あ');
        is $uri->as_string, 'http://www.google.com/transliterate?langpair=ja-Hira%7Cja&text=%E3%81%82%2C', 'make_uri() should contain valid URI string'
    };
};

subtest 'google_ime()' => sub {

    subtest 'when Google returns valid response' => sub {

        subtest 'should return valid result' => sub {
            local *HTTP::Tiny::get = sub {
                +{ success => 1, content => encode(utf8 => <<EOF) };
[["あ",["あ","亜","在","有","ア"]]]
EOF
            };

            is google_ime('あ'), 'あ/亜/在/有/ア';
        };
    };

    subtest 'when Google returns invalid response' => sub {

        subtest 'should return undef' => sub {
            local *HTTP::Tiny::get = sub { +{ success => 0 }, };

            is google_ime('あ'), undef, 'google_ime() should return undef';
        };
    };

    subtest 'when HTTP::Tiny::get occurs error' => sub {

        subtest 'should return undef' => sub {
            local *HTTP::Tiny::get = sub { die 'hoge error' };

            my $result;
            lives_ok sub { $result = google_ime('あ') }, 'google_ime() does not die';
            is $result, undef, 'google_ime() should return undef';
        };
    };
};

subtest 'search()' => sub {

    my $mock_result;
    local *google_ime = sub { $mock_result };
    my $cache_path = Path::Tiny->tempfile;

    subtest 'when cache hit' => sub {

        subtest 'should return cached result' => sub {
            $mock_result = 'foo';
            is search('あ', $cache_path), 'foo', 'search() should return "foo" at the first time';
            $mock_result = 'bar';
            is search('あ', $cache_path), 'foo', 'search() should return "foo" again';
        };
    };

    subtest 'when cache not hit' => sub {

        subtest 'should return valid result' => sub {
            $mock_result = 'foo';
            is search('あ', $cache_path), 'foo', 'search() should return "foo" at the first time';
            $mock_result = 'bar';
            is search('い', $cache_path), 'bar', 'search() should return "bar" time time';
        };
    };

    subtest 'when cache expired' => sub {

        subtest 'should return valid result' => sub {
            my $now = time;
            $mock_result = 'foo';
            is search('あ', $cache_path, $now), 'foo', 'search() should return "foo" at the first time';
            $mock_result = 'bar';
            is search('あ', $cache_path, $now + CACHE_EXPIRATION()), 'bar', 'search() should return "bar" time time';
        };
    };

    {
        no warnings 'once';
        undef $main::CACHE;
    }
};

subtest 'process()' => sub {

    my $json_file = Path::Tiny->tempfile;
    state sub load {
        decode_json($json_file->slurp);
    }
    state sub save($code, $data) {
        $json_file->spew(encode_json(+{ code => $code, data => $data }));
    }

    my $original_search = \&search;
    local *search = sub ($kana, $cache_path) {
        my $response = load;
        if ($response->{code} == -1) {
            die 'hoge error';
        } else {
            $original_search->($kana, $cache_path);
        }
    };

    local *HTTP::Tiny::get = sub {
        my $response = load;
        my $content = encode_json($response->{data}) . "\n";
        +{ success => int($response->{code} / 100) == 2, content => $content };
    };

    local *main::CACHE_EXPIRATION = sub { -1 };

    my $host = '127.0.0.1';
    my $port = do {
        my $tmp = IO::Socket::INET->new(
            Proto => 'tcp',
            LocalAddr => $host,
            LocalPort => 0,
        );
        $tmp->sockport;
    };
    note "using $host:$port";

    if (!defined (my $pid = fork)) {
        die "can't fork: $!";
    } elsif ($pid == 0) {
        process($host, $port, Path::Tiny->tempfile)
    } else {

        set_failure_handler(sub { kill TERM => $pid });

        state sub request($command) {
            my $handle = IO::Socket::INET->new(
                Proto => 'tcp',
                PeerAddr => $host,
                PeerPort => $port,
            );
            isa_ok $handle, 'IO::Socket::INET';
            print $handle encode(eucjp => $command);
            decode(eucjp => <$handle>);
        };

        subtest 'when CLIENT_REQUEST' => sub {

            subtest 'when Google returns valid response' => sub {
                save(200, [['あ', ['あ', '亜', '在', '有', 'ア']]]);
                is request("1あ \n") => "1/あ/亜/在/有/ア\n";
            };

            subtest 'when Google returns invalid response' => sub {
                save(200, []);
                is request("1い \n") => "4い \n";
            };

            subtest 'when Google returns 500 error' => sub {
                save(500, []);
                is request("1う \n") => "4う \n";
            };

            subtest 'when search() dies' => sub {
                save(-1, []);
                is request("1え \n") => "0\n";
            };
        };

        subtest 'when CLIENT_VERSION' => sub {
            no warnings qw(once);
            is request("2 \n"), "$main::VERSION_STRING ";
        };

        subtest 'when CLIENT_HOST' => sub {
            is request("3 \n"), "$host:$port: ";
        };

        kill TERM => $pid;
    }
};

done_testing;
