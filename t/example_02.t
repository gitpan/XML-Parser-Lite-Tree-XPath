use Test::Simple tests => 10;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;
use Data::Dumper;

# http://www.zvon.org/xxl/XPathTutorial/Output/example2.html

my $xml = q!
	<aaa>
		<bbb id="b1" />
		<ccc />
		<bbb id="b2" />
		<ddd>
			<bbb id="b3" />
		</ddd>
		<ccc>
			<ddd>
				<bbb id="b4" />
				<bbb id="b5" />
			</ddd>
		</ccc>
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes('//bbb');
ok(scalar(@nodes) == 5);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b2');
ok($nodes[2]->{name} eq 'bbb' && $nodes[2]->{attributes}->{id} eq 'b3');
ok($nodes[3]->{name} eq 'bbb' && $nodes[3]->{attributes}->{id} eq 'b4');
ok($nodes[4]->{name} eq 'bbb' && $nodes[4]->{attributes}->{id} eq 'b5');

@nodes = $xpath->select_nodes('//ddd/bbb');
ok(scalar(@nodes) == 3);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b3');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b4');
ok($nodes[2]->{name} eq 'bbb' && $nodes[2]->{attributes}->{id} eq 'b5');
