use Test::Simple tests => 2;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

my $tree = XML::Parser::Lite::Tree::instance()->parse("<a />");
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

ok( defined($xpath), "new() returns something" );
ok( ref $xpath eq 'XML::Parser::Lite::Tree::XPath', "new() returns the right object" );
