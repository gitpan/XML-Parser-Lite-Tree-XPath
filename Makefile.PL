use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'		=> 'XML::Parser::Lite::Tree::XPath',
	'VERSION_FROM'	=> 'XPath.pm',
	'PREREQ_PM'	=> {
				'XML::Parser::Lite::Tree' => 0,
				'Test::Simple',
			},
);
