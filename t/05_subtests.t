use Test::Simple tests => 6;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

my $xml = q!<x><a b="1" c="2" /><a c="3" /></x>!;
my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

ok(1, "Modules loaded ok");

my @nodes;

@nodes = $xpath->select_nodes('/x/a[@b]');
ok(scalar(@nodes)==1);

@nodes = $xpath->select_nodes('/x/a[@c]');
ok(scalar(@nodes)==2);

@nodes = $xpath->select_nodes('/x/a[@b=1]');
ok(scalar(@nodes)==1);

@nodes = $xpath->select_nodes('/x/a');
ok(scalar(@nodes)==2);

@nodes = $xpath->select_nodes('/x/a[@c>1]');
ok(scalar(@nodes)==2);
