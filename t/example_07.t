use Test::Simple tests => 8;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

# http://www.zvon.org/xxl/XPathTutorial/Output/example7.html

my $xml = q!
	<aaa id="a1">
		<ccc id="c1">
			<bbb />
			<bbb />
			<bbb />
		</ccc>
		<ddd id="d1">
			<bbb />
			<bbb />
		</ddd>
		<eee id="e1">
			<ccc id="c2" />
			<ddd id="d2" />
		</eee>
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('//*[count(bbb)=2]');
ok(scalar(@nodes) == 1);
ok($nodes[0]->{name} eq 'ddd' && $nodes[0]->{attributes}->{id} eq 'd1');

@nodes = $xpath->select_nodes('//*[count(*)=2]');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'ddd' && $nodes[0]->{attributes}->{id} eq 'd1');
ok($nodes[1]->{name} eq 'eee' && $nodes[1]->{attributes}->{id} eq 'e1');

@nodes = $xpath->select_nodes('//*[count(*)=3]');
ok(scalar(@nodes) == 2);
ok($nodes[0]->{name} eq 'aaa' && $nodes[0]->{attributes}->{id} eq 'a1');
ok($nodes[1]->{name} eq 'ccc' && $nodes[1]->{attributes}->{id} eq 'c1');
