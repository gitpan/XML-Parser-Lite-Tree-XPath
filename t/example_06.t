use Test::Simple tests => 7;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

# http://www.zvon.org/xxl/XPathTutorial/Output/example6.html

my $xml = q!
	<aaa>
		<bbb id="b1" />
		<bbb id="b2" name=" bbb " />
		<bbb id="b3" name="bbb" />
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes(q!//bbb[@id='b1']!);
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');

@nodes = $xpath->select_nodes(q!//bbb[@name='bbb']!);
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b3');

@nodes = $xpath->select_nodes(q!//bbb[normalize-space(@name)='bbb']!);
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b2');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b3');
