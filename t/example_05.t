use Test::Simple tests => 11;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

# http://www.zvon.org/xxl/XPathTutorial/Output/example5.html

my $xml = q!
	<aaa>
		<bbb id="b1" />
		<bbb id="b2" />
		<bbb name="bbb" />
		<bbb />
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

#@nodes = $xpath->select_attributes('//@id');
#ok(scalar(@nodes)==2);

@nodes = $xpath->select_nodes('//bbb[@id]');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b2');

@nodes = $xpath->select_nodes('//bbb[@name]');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{name} eq 'bbb');

@nodes = $xpath->select_nodes('//bbb[@*]');
ok(scalar(@nodes) == 3);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b2');
ok($nodes[2]->{name} eq 'bbb' && $nodes[2]->{attributes}->{name} eq 'bbb');

@nodes = $xpath->select_nodes('//bbb[not(@*)]');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb' && scalar(keys %{$nodes[0]->{attributes}}) == 0);
