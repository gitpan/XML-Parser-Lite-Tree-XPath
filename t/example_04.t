use Test::Simple tests => 4;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

# http://www.zvon.org/xxl/XPathTutorial/Output/example4.html

my $xml = q!
	<aaa>
		<bbb id="b1" />
		<bbb id="b2" />
		<bbb id="b3" />
		<bbb id="b4" />
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('/aaa/bbb[1]');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');

@nodes = $xpath->select_nodes('/aaa/bbb[last()]');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b4');
