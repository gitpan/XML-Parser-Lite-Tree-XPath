use Test::Simple tests => 5;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

my $xml = "<a><b>c</b><b>d<e /></b></a>";
my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

ok(1, "Modules loaded ok");

my @nodes;

@nodes = $xpath->select_nodes('/a/text()');
ok(scalar(@nodes)==0, "Text search on nodes ok");

@nodes = $xpath->select_nodes('/a/node()');
ok(scalar(@nodes)==2, "Node search on nodes ok");

@nodes = $xpath->select_nodes('/a/b/text()');
ok(scalar(@nodes)==2, "Text search on text ok");

@nodes = $xpath->select_nodes('/a/b/node()');
ok(scalar(@nodes)==3, "Node search on text ok");
