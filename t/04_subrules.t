use Test::Simple tests => 7;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

my $xml = "<a><b><c /><c>foo</c></b><b><c />bar</b></a>";
my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

ok(1, "Modules loaded ok");

my @nodes;

@nodes = $xpath->select_nodes('/a/b[1]');
ok(scalar(@nodes)==1, "Subrule [1] ok");

@nodes = $xpath->select_nodes('/a/b/c');
ok(scalar(@nodes)==3, "Check search ok");

@nodes = $xpath->select_nodes('/a/b[1]/c');
ok(scalar(@nodes)==2, "Subrule [1] ok");

@nodes = $xpath->select_nodes('/a/b[2]/c');
ok(scalar(@nodes)==1, "Subrule [2] ok");

@nodes = $xpath->select_nodes('/a/b[last()]/c');
ok(scalar(@nodes)==1, "Subrule [last()] ok");

@nodes = $xpath->select_nodes('/a[1]/b[1]/c[2]/text()');
ok(scalar(@nodes)==1, "Chained subruled ok");
