use Test::Simple tests => 18;

use XML::Parser::Lite::Tree;
use XML::Parser::Lite::Tree::XPath;

# http://www.zvon.org/xxl/XPathTutorial/Output/example8.html

my $xml = q!
	<aaa>
		<bcc>
			<bbb id="b1" />
			<bbb id="b2" />
			<bbb id="b3" />
		</bcc>
		<ddb>
			<bbb id="b4" />
			<bbb id="b5" />
		</ddb>
		<bec>
			<ccc />
			<dbd />
		</bec>
	</aaa>
!;

$xml =~ s/>\s+</></sg;

my $tree = XML::Parser::Lite::Tree::instance()->parse($xml);
my $xpath = new XML::Parser::Lite::Tree::XPath($tree);

my @nodes;

@nodes = $xpath->select_nodes(q!//*[name()='bbb']!);
ok(scalar(@nodes) == 5);
ok($nodes[0]->{name} eq 'bbb' && $nodes[0]->{attributes}->{id} eq 'b1');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b2');
ok($nodes[2]->{name} eq 'bbb' && $nodes[2]->{attributes}->{id} eq 'b3');
ok($nodes[3]->{name} eq 'bbb' && $nodes[3]->{attributes}->{id} eq 'b4');
ok($nodes[4]->{name} eq 'bbb' && $nodes[4]->{attributes}->{id} eq 'b5');

@nodes = $xpath->select_nodes(q!//*[starts-with(name(),'b')]!);
ok(scalar(@nodes) == 7);
ok($nodes[0]->{name} eq 'bcc');
ok($nodes[1]->{name} eq 'bbb' && $nodes[1]->{attributes}->{id} eq 'b1');
ok($nodes[2]->{name} eq 'bbb' && $nodes[2]->{attributes}->{id} eq 'b2');
ok($nodes[3]->{name} eq 'bbb' && $nodes[3]->{attributes}->{id} eq 'b3');
ok($nodes[4]->{name} eq 'bbb' && $nodes[4]->{attributes}->{id} eq 'b4');
ok($nodes[5]->{name} eq 'bbb' && $nodes[5]->{attributes}->{id} eq 'b5');
ok($nodes[6]->{name} eq 'bec');

@nodes = $xpath->select_nodes(q!//*[contains(name(),'c')]!);
ok(scalar(@nodes) == 3);
ok($nodes[0]->{name} eq 'bcc');
ok($nodes[1]->{name} eq 'bec');
ok($nodes[2]->{name} eq 'ccc');
