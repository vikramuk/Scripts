#!/usr/bin/perl
=cut;
********************************************************************************
#Description: Check for Description and Testcase Match from 
#Singularity table
#
#Author: Vikram
#
#Revision history
********************************************************************************
#rev.no	 Name	  Date 		Description
#0.1 	Vikram 	24 July 14	Generate the IRT/ST from the Objective Sections
#0.5    Vikram  04 Aug 14   Generate Report to map the Objectives with the IRT
#0.6    Vikram  07 Aug 14   Add Generation of the Objectives as per the IRT/ST
#0.7     Vikram  08 Aug 14   Add Min/Zero changes and "Following" change in ST
********************************************************************************
=cut;
package Checklist;
#use strict;
#use warnings;
use File::Find qw(find);
use Test;
use IO::Handle;
use Benchmark qw/cmpthese timethese/;
use Data::Dumper;
#use List::Util 'first'; 
my @ListTestcases =();
my @Testcase =();
my %hash =();
my @TestcaseIRT=();
my @TestcaseST=();
#enter the directory path 
my $dir_path;
my $filename;
my $line ;
my @file_name_arr="";
my $dirname;
#list of Placeholders for the 7 different Parameters listed in IRT
my $list_min ;
my $list_max ;
my $list_Zero ;
my $mid_Pos ;
my $mid_Neg ;
my $OutBou_lo ;
my $OutBou_hi ;
#list of Placeholders for the 4 different Parameters listed in ST
my $STCond;
my $NMinus;
my $NValue;
my $NPosit;
my @identlines = ();
my @identSingLine = ();
my @ListTestcases =();
my @value=();
my @objfiles =();
my @min_list=();
my @midNeg_list=();
my @zero_list=();
my @midpos_List =();
my @max_list=();
my @ob_lolist =();
my @ob_hiList=();
my @Uniqmin_list=();
my @UniqmidNeg_list=();
my @Uniqzero_list=();
my @Uniqmidpos_List =();
my @Uniqmax_list=();
my @Uniqob_lolist =();
my @Uniqob_hiList=();
my @STList=();
my @NNeg=();
my @Nval=();
my @NPlus=();
my @uniqNMinus=();
my @uniqNCond=();
my @uniqNPlus=();
my @objfiles;
my @Rule =("min", "mid-ve", "zero", "mid+ve", "max", "ob low", "ob high");
my @Singularity = ("N-1", "N", "N+1");  # ,'N+1' ,'N-1', 'Singularity');
#enter the directory path 
print ("enter the directory path where the files are present\n"); 
$dir_path = <STDIN>;
chomp($dir_path);
#opens the directory 
opendir( TD, $dir_path ) || die("cannot open directory");
#perfom for all the files in the directory.
while($filename = readdir(TD))
{
    #List all Files but pick only TCF Files 
    @file_name_arr = split(/\./, $filename);
	if ( $file_name_arr[1] eq "tcf" )
    { 
        undef @ListTestcases;
        undef @objfiles;
        undef %hash;
        undef @Testcase;
        undef @ListTestcases;
        undef @objfiles;
        undef %hash;
        undef @Testcase;
        undef @TestcaseIRT;
        undef @TestcaseST;
        local $buffer ;
        local $bufferSing ;
        undef @identlines;
        undef @ListTestcases;
        undef @value;
        undef @identSingLine;
        undef @objfiles;        
        undef @min_list;
        undef @midNeg_list;
        undef @zero_list;
        undef @midpos_List;
        undef @max_list;
        undef @ob_lolist;
        undef @ob_hiList;
        undef @Uniqmin_list;
        undef @UniqmidNeg_list;
        undef @Uniqzero_list;
        undef @Uniqmidpos_List;
        undef @Uniqmax_list;
        undef @Uniqob_lolist;
        undef @Uniqob_hiList;       
        undef @STList;
        undef @NNeg;
        undef @Nval;
        undef @NPlus; 
        undef @uniqNMinus;
        undef @uniqNCond;
        undef @uniqNPlus;
        my $inputLineIRT=0;
        my $inputLineST=0;
        my $flag_blankIRT =1;
        my $flag_blankST =1;
        open(OUTFILE,">",$dirname.$filename."csv") or die $!;
        # Change the Filehandle to redirect Console Output.
        STDOUT->fdopen( \*OUTFILE, 'w' ) or die $!;   
        &ListIRT; 
        &ListTestcases;  # Parse and Create an Array for the Total Number of testcases
        if ($flag_blankIRT) #check if the Section is Present
        {
           print("VariableName|Minimum|MidNegative|Zero|MidPositive|Maximum|OutBoundLow|OutBoundHigh"."\n");
            @identlines = split ("\n", $buffer);
            my $inputLine=0;  
            foreach my $val (@identlines)
            {               
                $list_min = "" ;
                $list_max ="";
                $list_Zero ="" ;
                $mid_Pos ="";
                $mid_Neg ="";
                $OutBou_lo ="";
                $OutBou_hi ="";             
             $val =~ s/^\s+|\s+$//g ;   #remove spaces and Trim the values             
             @value = split (/\|/, $val);        
                #TODO find a method to ensure that End of File is used to Align the Tables
                if (@value[1] !~ m/NA/i)  { $list_var= @value[1];}  else{$list_var=0;}               
                if (@value[4] !~ m/NA/i)  { $list_min= @value[4];}  else{$list_min=0;}              
                if (@value[5] !~ m/NA/i)  { $mid_Neg=  @value[5];}  else{$mid_Neg=0; } 
                if (@value[6] !~ m/NA/i)  { $list_Zero=@value[6];}  else{$list_Zero=0;} 
                if (@value[7] !~ m/NA/i)  { $mid_Pos=  @value[7];}  else{$mid_Pos=0;}   
                if (@value[8] !~ m/NA/i)  { $list_max= @value[8];}  else{$list_max=0;} 
                if (@value[9] !~ m/NA/i)  { $OutBou_lo=@value[9];}  else{$OutBou_lo=0;} 
                if (@value[10] !~ m/NA/i) { $OutBou_hi=@value[10];} else{$OutBou_hi=0;}                 
                # Update the List of Variables into a Buffer here.                
                    
                    my $varname = $list_var; 
                    $varname =~ s/^\s+|\s+$//g;                
                    $list_min =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                    $mid_Neg =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                    $list_Zero =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                    $mid_Pos =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                    $list_max =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                    $OutBou_lo =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                    $OutBou_hi =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values                                
                    #Print the Table
                    print ($inputLine+1);  #TODO   DEBUG Code here
                    print "::".$list_var."\t".$list_min."\t".$mid_Neg."\t".$list_Zero."\t".$mid_Pos."\t".$list_max."\t".$OutBou_lo."\t".$OutBou_hi."\n";                            
               # Create a Unique List of testcases based on the Rule
               #Task#1  -                  #TODO:  Create a Matrix here               
               #Clear the Matrix Elements
               for my $ruleset (0..6)
               {
                   for ($i=0; $i < 1; $i++)
                   {  
                    $TestcaseIRT[$inputLine][$ruleset][$i] = 0;
                   }
               }        # Cleared all the Matrix Elements         
               for my $ruleset (0..6)
               {                     
                                      $TestcaseIRT[$inputLine][$ruleset][0] = $varname;  #Done
                                      $TestcaseIRT[$inputLine][$ruleset][1] = uc($Rule[$ruleset]);                                                                       
                   if ($ruleset==0)  {$TestcaseIRT[$inputLine][$ruleset][2] = $list_min;}
                   if ($ruleset==1)  {$TestcaseIRT[$inputLine][$ruleset][2] = $mid_Neg;}
                   if ($ruleset==2)  {$TestcaseIRT[$inputLine][$ruleset][2] = $list_Zero;}
                   if ($ruleset==3)  {$TestcaseIRT[$inputLine][$ruleset][2] = $mid_Pos;}
                   if ($ruleset==4)  {$TestcaseIRT[$inputLine][$ruleset][2] = $list_max;}
                   if ($ruleset==5)  {$TestcaseIRT[$inputLine][$ruleset][2] = $OutBou_lo;}
                   if ($ruleset==6)  {$TestcaseIRT[$inputLine][$ruleset][2] = $OutBou_hi;}                               
               }              
            $inputLine++;                         
            }       # Complete parsing all Lines
            #print Dumper(@TestcaseIRT);      #TODO: For Debug
            $inputLineIRT = $inputLine;
        }           # End of the IRT Block         
        &ListST; 
        if ($flag_blankST) # if the Singularity Block is Present
        {
           @identSingLine = split ("\n", $bufferSing);                      
           undef @value;           
           my $inputLine=0;
           print("\nSingularity Condition |N-1 Condition|N Condition|N+1 Condition"."\n");          
            foreach my $val (@identSingLine)
            {
                 $STCond="";
                 $NMinus="";
                 $NValue="";
                 $NPosit="";
                 $val =~ s/^\s+|\s+$//g ;   #remove spaces and Trim the values
                 @value = split (/\|/, $val);    
                if (@value[1] !~ m/NA/i) { $STCond= @value[1];}  else{$STCond=0;} #print $NMinus."\t";                
                if (@value[2] !~ m/NA/i) { $NMinus= @value[2];}  else{$NMinus=0;} #print $NMinus."\t";                
                if (@value[3] !~ m/NA/i) { $NValue= @value[3];}  else{$NValue=0;} #print $NValue."\t";                
                if (@value[4] !~ m/NA/i) { $NPosit= @value[4];}  else{$NPosit=0;} #print $NPosit."\t";
                # Update the List of Variables into a Buffer here.    
                $STCond =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                $NMinus =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                $NValue =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values
                $NPosit =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values                
                #Print the Table     
                print ($inputLine+1);  #TODO   DEBUG Code here
                print "::".$STCond."\t".$NMinus."\t".$NValue."\t".$NPosit."\n";                     
                #Task#1  -                  #TODO:  Create a Matrix here
                #Clear the Matrix Elements
                for my $singlty (0..2)
                {
                   for ($i=0; $i < 1; $i++)
                   {  
                    $TestcaseST[$inputLine][$singlty][$i] = 0;
                   }
                }        # Cleared all the Matrix Elements         
                for my $singlty (0..2)
                {   
                                      $TestcaseST[$inputLine][$singlty][0] = $STCond;  #Done
                                      $TestcaseST[$inputLine][$singlty][1] = $Singularity[$singlty];                                                                       
                   if ($singlty==0)  {$TestcaseST[$inputLine][$singlty][2] = $NMinus;}
                   if ($singlty==1)  {$TestcaseST[$inputLine][$singlty][2] = $NValue;}
                   if ($singlty==2)  {$TestcaseST[$inputLine][$singlty][2] = $NPosit;}                               
                }
                $inputLine++;
            }       # Complete parsing all Lines               
            $inputLineST =$inputLine;
        }           # End of the Singularity Table Block
        print "\n";
        print "++++++++++++++++++++++++\n";
        #print Dumper(@TestcaseST);     #TODO: For Debug                   
        print "\n+++++++++++++++++++++++++++++++++\n";
        print "| Input |            Condition  |Testcase    | Result\n";
        # Parse the IRT Table
            foreach my $t (@ListTestcases)
            {
                #Parse the Test Sections to generate the KVP
                &ParseTestSections($t);  #TODO: For Debug
            }
            foreach my $t (@ListTestcases)
            {
                #Parse the Individual testcases t
                &ParseObjectiveList($t);  #TODO: For Debug
            }       
            #DONE  Print the Objectives to the TCFCSV File
            #&printObjectives;
        close(OUTFILE);      # close the OUTFILE per file
    }   # End of the If Loop
}
closedir(TD);
sub ListTestcases
{
#opens the file inside the dir
open(FP,"$dir_path/$filename")or die( "cannot open the file:$filename\n");
#print "\n".$dir_path.$filename."-----------------\n";
#my $TCFFile = $filename;
while (<FP>)	
{
if ( s/ Description = TEST//ig) 
    {
     my $str=$_; 
     $str =~ s/^\s+|\s+$//g ;
     push (@ListTestcases, $str);  
    }
}
close(FP);
}    
sub ParseTestSections
{
    #opens the file inside the dir
    open(FP,"$dir_path/$filename")or die( "cannot open the file:$filename\n");
    #print "\n".$dir_path.$filename."-----------------\n";
    my $buffer =();
    my $testcase =();
    my $TestNumber = "";
    $TestNumber = $_[0];  # Prepare this Array for the testcase
    $TestNumber =~ s/^\s+|\s+$//g ; #remove spaces and Trim the values
    OUTER:
    while (<FP>)	
    {          
    if(m/Description = TEST $TestNumber/i)
        {            
            while(<FP>) 
            {             
             $_ =~ s/[\x0A\x0D]//g; # to Strip lines of Extra Characters
             if (m/Control Flow/i)
              { last OUTER;}
             # skip blank lines
             next if /^[ \t]*$/;
             # skip comment lines
             next if /#/;
             # skip if not starting with a number ..thats the bullet items or objectives ..rest are not the lines to check for rules. 
             next if /^\D[.](.\s)?+/;
             $testcase .=$_;
             $testcase .= "\n";  # Added New line to Split by Order
            }
        }        
    }  
    push (@objfiles,$testcase);
    $Testcase[@objfiles][0] =$TestNumber;
    $Testcase[@objfiles][1] =$testcase; 
    $Testcase[@objfiles][2] =@objfiles;   
    #create the Multi Dimensional Array here
    #print Dumper(@Testcase);  #TODO   Debug to check all Objectives for each Testcase
close(FP);    # Close the opened TCF
}
# for each testcase parse and Fill the details in a Multi Dimensional Array
sub ParseObjectiveList
{
local $testNo = $_[0];
$testNo =~ s/^\s+|\s+$//g ; #remove spaces and Trim the values
    for (my $i=1; $i <= @objfiles; $i++)  
    {
        if ($Testcase[$i][0] eq $testNo)
        {            
            my @lines = split(/(\d[.])+/,$Testcase[$i][1]);
            #print "In loop $i \n\t$Testcase[$i][1]\n";
            #print Dumper (@lines); 
            foreach my $objective (@lines)
            {                 
                #parse the Input and Attributes depending on type of Condition.      
                # Here if this is a Input Range table
                if ($objective =~ m/To Verify.+following/i)
                {
                    #print $objective."\n"; #TODO Debug to check all conditions under Singularity
                    my @conditions = split (/\n/,$objective);
                    my @TestSing = split(/[',"]/,@conditions[0]);
                    my $testSing =@TestSing[1];
                    foreach my $splitsingly (@conditions)
                    { 
                      $splitsingly =~ s/^\s+|\s+$//g;
                      my $temp ="To Verify '".$testSing."' and '".$splitsingly."'\n";
                      #print ($temp);     #TODO   Debug to check all Objectives for Multiple Singularity
                      &LineSplitter($temp,0,1,$testNo);
                    }
                }
                if ($objective =~ m/To Verify/i) #TODO: need help Here to split the Objective into 
                {   
                    #foreach my $rule (@Rule) {
                    if(grep(m/Min|Max|Zero|Mid\+ve|Mid-ve|OB High|OB Low|Mid.\+ve|Mid.\-ve|Min\/Zero/i, $objective))    
                    {
                    #print ("Rule Found : $objective\n");
                    &LineSplitter($objective,1,0,$testNo);
                    next;
                    }
                    #foreach my $sing (@Singularity) {
                    if(grep(m/singularity/i, $objective))     
                    {
                    # Here if this is a Singularity
                    print ("Singularity Found : $objective :"); 
                    &LineSplitter($objective,0,1,$testNo);
                    next;                    
                    }
                }
            }
        }      
    } # end of intitial for loop for the Array Object
}
# Recursively run on each Line/Objective and get the Inputs and Objectives
sub LineSplitter #TODO:  Need help with this here.
{
my $IRT=$ST=$testnumber=0;
my $line = $_[0];    
$IRT = $_[1];
$ST = $_[2];
$testnumber = $_[3];
#$print $testnumber."\n";     #TODO for Debug
my @LineObject ='';
    if ($IRT)
    {
        #if ($line =~ m/\r\n/i)
        {
        @LineObject = split (/[',"]/,$line);        
        local $MinZero = "Min/Zero|Min and Zero";
        #print "+++ ".$LineObject[1]."\t".$LineObject[3]."\t".$testnumber."\n";
        ($LineObject[1] =~ s/$MinZero/Min/i);
        &matchIRT($LineObject[1],$LineObject[3], $testnumber);
        $IRT=0;
        }
    }
    if ($ST)
    {
        #if ($line =~ m/\r\n/i)
        {
        @LineObject = split /[',"]+/,$line;                
        #print "+++ ".$lineObject[1]."\t".$lineObject[3]."\t".$testnumber."\n";
        &matchST($LineObject[1],$LineObject[3], $testnumber);
        $ST =0;
        }
    }    
    #print Dumper(@LineObject);   #TODO: For Debug
}
sub ListIRT
{
    #opens the file inside the dir
    open(FP,"$dir_path/$filename")or die( "cannot open the file:$filename\n");
    #print "-----------------".$dir_path.$filename."-----------------\n";
    #my $TCFFile = $filename;
    while (<FP>)	
    {
        if ( /INPUT RANGE/i) {
        #$buffer .=$_;  # removed as this is Duplicated
            while (<FP>) 
            {                                    
             if ((m/None/i) ||( m/---/) || ( m/Variable/i))
                {
                 next;
                }
                else
                {
                $buffer .=$_;    
                last if /^\n$/;    
                }
            }
        }
        #check for Blank Entries returned
        if (($buffer cmp '' ) || ($buffer =~ m/none/i ))
        {
            $flag_blankIRT = 0;
        }  
    }   
    #print $buffer;    
close(FP);
}
sub ListST
{
 #opens the file inside the dir
    open(FP,"$dir_path/$filename")or die( "cannot open the file:$filename\n");
    #print "\n".$dir_path.$filename."-----------------\n";    
    while (<FP>)	
    {
    if ( /SINGULARITY TABLE/i) 
        {            
        #$buffer .=$_;  # skip the Current string
            while (<FP>) 
            {   
                if ((m/None/i) ||( m/---/) || ( m/Expression/i) ||(m/Test Case Type Table:/i)) # || (m/ /i))
                { next;}
                else
                {
                $bufferSing .=$_;    
                last if ((/^\n$/) ||(m/Test Case Type Table:/i));    
                }
            }
        }
        #check for Blank Entries returned
        if (($bufferSing cmp '' ) ||($bufferSing =~ m/none/i ))
        {
            $flag_blankST = 0;
        }        
    } 
close(FP);
}    
sub matchIRT
{
local $tc_IRT = $_[1];
local $tc_AttrIrt =$_[0];
local $localTestcase = $_[2];  
my $matchedFlag =0;
    #print Dumper(@TestcaseIRT);     #TODO for DEBUG
    #Task#2   - Create a Report Entry here
    if (($tc_IRT ne '') &&($tc_AttrIrt ne ''))  # Check for Blank Calls :-)
    {
       print "Range:  :".$tc_IRT.":  |".$tc_AttrIrt."|  ".$localTestcase.":  |";
       $matchedFlag=0; 
       for my $inputTC (0..$#TestcaseIRT)
        {             
           for my $j (0..6)
           {   
               #Match all the 3 Conditions from the Matrix - Testcase, Input and Rule
            if (                
                ($TestcaseIRT[$inputTC][$j][1] eq (uc($tc_AttrIrt))) # Case Specific Match for the Rule
                &&
                ($TestcaseIRT[$inputTC][$j][2] eq ($localTestcase)) # Case Insensitive match for Testcase
                &&
                ($TestcaseIRT[$inputTC][$j][0] eq ($tc_IRT)) # No Case Match for the Input                
                )
                {
                 $matchedFlag |= 1;
                }
            }            
        }
        if ($matchedFlag){print "Matched in IRT";} else {print "Mismatch in IRT"}; #Reach here and set Flag to True           
    print "\n";
    }  # Check Blank Entries
}
sub matchST
{
local $tc_ST =$_[1];
local $tc_AttrSt =$_[0];
local $localTestcase = $_[2];
my $matchedFlag =0;
    #print Dumper(@TestcaseST);   #TODO for DEBUG
    #Task#2   - Create a Report Entry here
    if (($tc_ST ne '') &&($tc_AttrSt ne ''))
    {
        print "Singularity:  :".$tc_ST.":  |".$tc_AttrSt."|  ".$localTestcase.":  |";
        $matchedFlag = 0; 
        for my $inputTC (0..$#TestcaseST)
        {                            
           for my $j (0..2)
           {              
               #Match all the 3 Conditions from the Matrix - Testcase, Input and Rule
            if (                
                ($TestcaseST[$inputTC][$j][1] eq (uc($tc_AttrSt))) # Case Specific Match for the Rule
                &&
                ($TestcaseST[$inputTC][$j][2] eq ($localTestcase)) # Case Insensitive match for Testcase
                &&
                ($TestcaseST[$inputTC][$j][0] eq ($tc_ST)) # No Case Match for the Input                
                )
                {
                $matchedFlag |= 1;            
                }
           }           
        }
        if ($matchedFlag){print "Matched in ST";} else {print "Mismatch in ST"};  #Reach here and set Flag to True           
    print "\n";
    }  # Check Blank Entries
}

sub printObjectives
{
    for my $inputTC (0..$#TestcaseIRT)
    {             
        for my $j (0..6)
        {   
         &rulevalidator_IRT($TestcaseIRT[$inputTC][$j][1],$TestcaseIRT[$inputTC][$j][0],$TestcaseIRT[$inputTC][$j][2]);
        }            
    }
    for my $inputTC (0..$#TestcaseST)
    {                            
        for my $j (0..2)
        {              
         &rulevalidator_ST($TestcaseST[$inputTC][$j][1],$TestcaseST[$inputTC][$j][0],$TestcaseST[$inputTC][$j][2]); 
        }           
    }   
}

#TODO:  Rules for Maximum, Minimum, Out of Bounds 
sub rulevalidator_IRT
{    
    local $rulepattern = $_[0];  
    local $InputVar = $_[1];
    local $testcase =$_[2]; 
    #my $testcasenumber =$_[3];    
    $InputVar =~ s/^\s+|\s+$//g ; #remove spaces and Trim the values
    $rulepattern =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values        
    if ($testcase ne 0)
    {
        print "    In $testcase :To Verify '".$rulepattern."' input value for the variable '".$InputVar."'.\n";
    }
}
#TODO: Rules for Maximum, Minimum, Out of Bounds and need to be done
sub rulevalidator_ST
{     
    local $Singularity = $_[0];      
    local $InputVar =$_[1];
    local $testcase = $_[2];    
    $Singularity =~ s/^\s+|\s+$//g ; #remove spaces and Trim the values
    $InputVar =~ s/^\s+|\s+$//g ;  #remove spaces and Trim the values        
    if ($testcase ne 0)
    {
        print "           +In $testcase :To Verify '".$Singularity."' singularity for the Expression '".$InputVar."'.\n";
    }
}

# End of File
