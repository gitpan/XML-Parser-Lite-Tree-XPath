use Test::Simple tests => 12;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

# http://www.zvon.org/xxl/XPathTutorial/Output/example10.html

my $xml = q!
	<aaa id="a1">
		<bbb id="b1" />
		<ccc id="c1" />
		<ddd id="d1">
			<ccc id="c2" />
		</ddd>
		<eee id="e1" />
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('//ccc | //bbb');
ok(scalar(@nodes) == 3);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');
ok($nodes[1]->{name} eq 'ccc' && $nodes[1]->{attributes}->{id} eq 'c1');
ok($nodes[2]->{name} eq 'ccc' && $nodes[2]->{attributes}->{id} eq 'c2');

@nodes = $xpath->select_nodes('/aaa/eee | //bbb');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');
ok($nodes[1]->{name} eq 'eee' && $nodes[1]->{attributes}->{id} eq 'e1');

@nodes = $xpath->select_nodes('/aaa/eee | //ddd/ccc | /aaa | //bbb');
ok(scalar(@nodes) == 4);
ok($nodes[0]->{name} eq 'aaa' && $nodes[0]->{attributes}->{id} eq 'a1');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b1');
ok($nodes[2]->{name} eq 'ccc' && $nodes[2]->{attributes}->{id} eq 'c2');
ok($nodes[3]->{name} eq 'eee' && $nodes[3]->{attributes}->{id} eq 'e1');
