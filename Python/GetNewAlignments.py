import sys, os, time, math, shutil, string
from fnmatch import fnmatch
from optparse import OptionParser
from GeneticCode import parseCodons, translateSeq
from Bio import Seq
from Bio import SeqRecord
from Bio import SeqIO
from Bio import Align
from Bio import AlignIO
from subprocess import Popen, PIPE


# Produce alignments that can be used with PAML
#     - Extract sequences for each group from the files created with ExtractDNA.py
#     - Skip groups that have missing sequences for some species
#     - Check translation again with OrthoDB alignments
#     - If there is more than one sequence of a species:
#           * Perform a new alignment on the translated sequences (AA) with the chosen MSA program for 
#             every possible combination of sequences so that the MSA has only one sequence per species
#           * Use Gblocks (with strict settings) to restrict the alignments to the best matching areas only
#           * Select the alignment with the longest well-aligned parts (as determined by Gblocks)
#           * If there are more alignments with disjoint sets of sequences select alignments by longest well aligned parts until 
#             the maximum number is selected
#       Else:
#           * Perform a new alignment on the translated sequences with the chosen MSA program
#     - Trim the alignment:
#           * Using Gblocks
#     - Skip groups where the trimmed alignment is shorter than the minimum length
#     - Save trimmed cDNA alignments in Phylip format so it can be used with PAML
#
# Need to have MSA programs and Gblocks installled.  Check that programs are in your path.  
#     (For prographmsa the path is hardcoded for the moment)
#     (Some problems with Muscle and Prank)
#
# Output
#     - Alignments.csv:  Exactly like Alignments.csv from ExtractDNA.py, but only for groups selected here
#     - Skipped.csv:     Groups which have been skipped for whatever reason
#     - Colsremoved.csv: List of columns removed from each of the alignments
#     For each group that wasn't skipped:
#           - <group>.aa.fa:                          Protein sequences without gaps
#           - <group>.dna.fa:                         Corresponding cDNA sequences
#           - <group>.<msaprogram>.fas:               New alignment (AA, ids remapped)
#           - <group>.<msaprogram>.dna.fas            New alignment (cDNA, ids remapped)
#           - <group>.<msaprogram>.dna.fas-gb         Trimmed alignment from Gblocks
#           - <group>.<msaprogram>.dna.fas-gb.txt     Gblocks statistics
#           - <group>.<msaprogram>.dna.phylip         Trimmed cDNA alignment in Phylip, ready for Paml
#           - <group>.<msaprogram>.phylip             Trimmed AA alignment in phylip
#           - <group>.map                             Mapping of ids to the Phylip files
#           - <group>.ids                             Identifiers of the original sequences used
#           - <group>.combinations.tar                Temporary files from finding the best combination of sequences to use
#
################################################################################################################################
# Parameters
################################################################################################################################

usage = "usage: %prog [option]"
parser = OptionParser(usage=usage)


parser.add_option("-i","--inputpath",
                  dest = "inputpath",
                  default = "",
                  metavar = "filename",
                  help = "Directory containing sequences in Fasta format (from ExtractDNA.py) [default = %default]")

parser.add_option("-l","--minlength",
                  dest = "minlength",
                  default = "300",
                  metavar = "integer",
                  help = "Minimum length for an alignment (in nucleotides, after trimming) [default = %default]")

parser.add_option("-g","--gblockspars",
                  dest = "gblockspars",
                  default = "",
                  metavar = "parameters",
                  help = "Parameters for Gblocks (strict/relaxed/none) - use Gblocks if this is specified [default = %default]")

(options,args) = parser.parse_args()

inputpath    = os.path.abspath(options.inputpath)+'/'
outputpath   = inputpath
minlength    = int(options.minlength)
gblockspars  = options.gblockspars

StopCodons   = ['TAA','TAG','TGA']

print minlength


################################################################################################################################  

def GetDNAAlignment(alignseq, dnaseq):

      dnaalignseq = ''
      codons = list(parseCodons(dnaseq))
      i = 0
      for aa in alignseq:
            if (aa == '-'):
                  dnaalignseq += '---'
            else:
                  dnaalignseq += codons[i]
                  i += 1
            #
      #

      return dnaalignseq

#      


def GetSequences(fname, seqid):
      for record in SeqIO.parse(fname, 'fasta'):
            if (record.description == seqid):
                  return record.seq
#







################################################################################################################################


def runGblocks(fname, pars):
      """Trim alignment using Gblocks

      Returns Alignment object
      """

      print "\n\tStarting Gblocks computation for "+fname[fname.rfind('/')+1:]
      start = time.time()
      
      handle = Popen("Gblocks %s %s " % (fname,pars), stdout=PIPE, stderr=PIPE, shell=True)

      # Read and process errors from MSA program
      out = handle.stdout.read()

      err = handle.stderr.read()
      if (err != ""):
            sys.stderr.write("\tWarning! Errors encountered!\n")
            #sys.stderr.write(err)


      end = time.time()
      print "\tGblocks finished ("+str(end-start)+" seconds)\n"

      statfile = open(fname+'-gb.txt','r')
      line = statfile.readline()
      while (line.find("New number of positions") < 0):
            line = statfile.readline()
      trimlength = int(line[line.find(':')+1:line.find('(')])
      return trimlength
##



################################################################################################################################  
start = time.time()

if (not os.path.exists(outputpath)):
      os.mkdir(outputpath)
#

statfile = open(outputpath+'Alignments.csv','w')
statfile.write('Alignment\tLength\n')
skipfile = open(outputpath+'Skipped.csv','w')
skipfile.write('Alignment\tLength\n')


for filename in os.listdir(inputpath):
      if (fnmatch(filename,'*.fasta')):
                        
            sys.stdout.write("Processing "+filename+"\n")

            ##################
            # Trim alignment #
            ##################
            # (on DNA MSA this time)
            if (gblockspars == "strict"):
                  strict = '-t=c -p=t -b3=8  -b4=10 -b5=n'
                  runGblocks(inputputpath+filename, strict)
                  dnamsa = AlignIO.read(inputpath+filename+' -gb','fasta')

            elif (gblockspars == "relaxed"): 
                  n = math.floor(len(dnamsa)/2+1)
                  relaxed = '-t=c -p=t -b2=%d -b3=10 -b4=5  -b5=h' % n
                  runGblocks(inputputpath+filename, strict)
                  dnamsa = AlignIO.read(inputpath+filename+' -gb','fasta')

            else:
                  sys.stdout.write("\tUnknown Gblocks parameters, not trimming\n")
                  dnamsa = AlignIO.read(inputpath+filename,'fasta')


            #############################
            # Check length of alignment #
            ############################# 
            if (len(dnamsa[0]) < minlength):
                  sys.stdout.write('Alignment too short...skipping\n')
                  skipfile.write(filename+'\t%d\n' % (len(dnamsa[0])))                  
            else:
                  statfile.write(filename+'\t%d\n' % (len(dnamsa[0])))

            filename = filename[:filename.rfind('.')]


            ################################
            # Save Phylip cDNA output file #
            ################################
            # (PAML needs "I" on first line of phylip output file)
            AlignIO.write(dnamsa,outputpath+filename+'.dna.phylip_temp',"phylip")
            infile  = open(outputpath+filename+'.dna.phylip_temp','r')
            outfile = open(outputpath+filename+'.dna.phylip','w')
            i = 0
            for line in infile:
                  if (i == 0):
                        outfile.write(line[:-1]+' I\n')
                  else:
                        outfile.write(line)
                  i += 1
            outfile.close()
            infile.close()
            os.remove(outputpath+filename+'.dna.phylip_temp')


            #########################################################
            # Translate to AA alignment and save Phylip output file #
            #########################################################
            aaseqs = []
            for dnaseq in dnamsa:
                  #aaseq = SeqRecord.SeqRecord(Seq.Seq(translateSeq(str(dnaseq.seq))), id = dnaseq.id[:5])
                  aaseq = SeqRecord.SeqRecord(Seq.Seq(translateSeq(str(dnaseq.seq))), id = dnaseq.id)
                  aaseqs.append(aaseq)
            aamsa = Align.MultipleSeqAlignment(aaseqs)
            AlignIO.write(aamsa, outputpath+filename+'.aa.phylip',"phylip")


     #
skipfile.close()
statfile.close()


end = time.time()

print "Total time taken: "+str(end-start)+" seconds"