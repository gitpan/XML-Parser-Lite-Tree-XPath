use Test::Simple tests => 7;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example1.html

my $xml = q!
	<aaa id="a1">
		<bbb id="b1" />
		<ccc id="c1" />
		<bbb id="b2" />
		<ddd>
			<bbb id="b3" />
		</ddd>
		<ccc id="c2" />
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('/aaa');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'aaa' && $nodes[0]->{attributes}->{id} eq 'a1');

@nodes = $xpath->select_nodes('/aaa/ccc');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'ccc' && $nodes[0]->{attributes}->{id} eq 'c1');
ok($nodes[1]->{name} eq 'ccc' && $nodes[1]->{attributes}->{id} eq 'c2');

@nodes = $xpath->select_nodes('/aaa/ddd/bbb');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b3');
