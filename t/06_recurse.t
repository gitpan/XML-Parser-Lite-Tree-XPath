use Test::Simple tests => 5;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

my $xml = q!<x><a b="1" c="2"><b b="foo" /></a><a c="3" /></x>!;
my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

ok(1, "Modules loaded ok");

my @nodes;

@nodes = $xpath->select_nodes('//*');
ok(scalar(@nodes)==4);

@nodes = $xpath->select_nodes('//*/b');
ok(scalar(@nodes)==1);

@nodes = $xpath->select_nodes('//a');
ok(scalar(@nodes)==2);

@nodes = $xpath->select_nodes('//*[@b]');
ok(scalar(@nodes)==2);
