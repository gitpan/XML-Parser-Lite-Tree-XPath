use Test::Simple tests => 9;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

my $xml = "<a><b>c</b><b>d</b></a>";
my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

ok(1, "Modules loaded ok");

my @nodes;

@nodes = $xpath->select_nodes('/*');
ok(scalar(@nodes)==1, "Got root node ok by wildcard");

@nodes = $xpath->select_nodes('/a');
ok(scalar(@nodes)==1, "Got root node ok by exact match");

@nodes = $xpath->select_nodes('/*/*');
ok(scalar(@nodes)==2, "Got child nodes ok by wildcard/wildcard");

@nodes = $xpath->select_nodes('/a/*');
ok(scalar(@nodes)==2, "Got child nodes ok by exact/wildcard");

@nodes = $xpath->select_nodes('/*/b');
ok(scalar(@nodes)==2, "Got child nodes ok by wildcard/exact");

@nodes = $xpath->select_nodes('/a/b');
ok(scalar(@nodes)==2, "Got child nodes ok by exact/exact");

@nodes = $xpath->select_nodes('/a/b/*');
ok(scalar(@nodes)==2, "Got grandchild text nodes ok by wild");

@nodes = $xpath->select_nodes('/a/b/c');
ok(scalar(@nodes)==0, "Got grandchild text nodes ok by match");
