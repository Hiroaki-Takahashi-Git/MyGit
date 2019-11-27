use utf8;
use strict;
use warnings;

my $PD_ROOTDIR = "F:\\Puzzle_and_Dragons";
my $PD_DATADIR = sprintf("%s\\PD_Data", $PD_ROOTDIR);
my $PD_EVODIR  = sprintf("%s\\PD_EVO", $PD_ROOTDIR);
my $PD_TOOLDIR = "F:\\MyGit\\programing\\Puzzle_And_Dragons";
my $TOOL_PERL  = sprintf("%s\\Perl", $PD_TOOLDIR);
my $TOOL_PYTHON    = sprintf("%s\\Python", $PD_TOOLDIR);

my @FRM_ARRAY = ();

sub Define_Item {
    my ($IN_STRING) = @_;
    if ($IN_STRING eq 'PD_ROOTDIR') {
        return ($PD_ROOTDIR);
    }
    elsif ($IN_STRING eq 'PD_DATADIR') {
        return ($PD_DATADIR);
    }
    elsif ($IN_STRING eq 'PD_TOOLDIR') {
        return ($PD_TOOLDIR);
    }
    elsif ($IN_STRING eq 'TOOL_PERL') {
        return ($PD_TOOLDIR);
    }
    elsif ($IN_STRING eq 'TOOL_PYTHON') {
        return ($TOOL_PYTHON);
    }
    elsif ($IN_STRING eq 'PD_EVODIR') {
        return ($PD_EVODIR);
    }
    return ("NODEFINE");
}

sub Add_Form {
    my ($IN_FROM) = @_;

    push(@FRM_ARRAY, $IN_FROM);
}

sub Init_Form {
    
    if (scalar(@FRM_ARRAY) > 0) {
        foreach my $FRM (@FRM_ARRAY) {
            # print "FORM\t$FRM\n";
            $FRM->withdraw;
        }
    }
}
1;
