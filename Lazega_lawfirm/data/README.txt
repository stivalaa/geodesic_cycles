Law firm data from

Emmanuel Lazega, The Collegial Phenomenon: The Social Mechanisms of Cooperation Among Peers in a Corporate Law Partnership, Oxford University Press (2001).


See also:

Lazega, E., & Pattison, P. E. (1999). Multiplexity, generalized exchange and cooperation in organizations: a case study. Social networks, 21(1), 67-90.

Tom A.B. Snijders, Philippa E. Pattison, Garry L. Robins, and Mark S. Handcock. New specifications for exponential random graph models. Sociological Methodology (2006), 99-153.

Downloaded from

http://moreno.ss.uci.edu/data.html#lazega

on 2 Nov 2017. Information from above address pasted below.


The original files LAZEGA.DAT and LAZATT.DAT contain respectively
the three networks (advice, co-work, friendship) and the actor attributes.

To convert to individual networks and import into R and then save in MPNet format,
the following steps were followed:

1. Load into UCINET (6.640).

2. In UCINET, Unpack (Data -> Unpack) creating the ADVICE.##d, ADVICE.##h,
   CO-WORK.##h, CO-WORK.##d, FRIENDSHIP.##h, FRIENDSHIP.##d files.
   (NB these are UCINET files and are binary, and furthermore they do
   not work with Microsoft OneDrive, give error messages, hence I have
   saved them as ucinet_files.zip and then deleted them to stop errors).

3. Import into R with the read.write.ucinet script by Christian Steglich
   [https://sites.google.com/site/ucinetsoftware/document/faq/connectingwithr/read.write.ucinet.zip?attredirects=0&d=1
    see https://sites.google.com/site/ucinetsoftware/document/faq/connectingwithr]
   This script and its document is saved in this directory. E.g.:

	> source('read.write.ucinet.R')
	> advice <- read.ucinet('ADVICE')
	Warning message:
	In read.ucinet.header(filename) :
	  UCINET file with one level; level name "ADVICE" treated as network name
	> lazatt <- as.data.frame(read.ucinet('lazatt'))


   [I tried the rucinet package (https://github.com/jfaganUK/rucinet)
    but just got error messages "The file does not indicate that it is version 6404. Pleae export a version 6404 file from UCINET." ]

4. Write adjacency matrices for use in MPNet with e.g:

	> write.table(advice, file='advice_adjmatrix.txt', col.names=F, row.names=F)    

5. Make tables of different attribute tyes (binary, categorical, continuous).
   Note GENDER and STATUS and PRACTICE could be used as binary or categorical,
   so I create both, then the choice can be made which to use in modeling.
   Note also binary has to be 0/1 so we subract 1 so now 
   GENDERBINARY is coded as 0=man, 1=woman and STATUSBINARY is coded as
   0=partner, 1=associate and PRACTICE as 0=litigation, 1=corporate.

	> binattr <- lazatt[c("GENDER", "STATUS", "PRACTICE")]
	> names(binattr) <- c("GENDERBINARY", "STATUSBINARY", "PRACTICEBINARY")
	> binattr <- binattr-1
	> write.table(file='lazega_binattr.txt', binattr, quote=F, col.names=T, row.names=F, sep="\t")


	> catattr <- lazatt[c("STATUS", "GENDER", "OFFICE", "PRACTICE", "LAW_SCHOOL")]
	> write.table(file='lazega_catattr.txt', catattr, quote=F, col.names=T, row.names=F, sep="\t")

	> contattr <- lazatt[c("SENIORITY", "AGE")]
	> write.table(file='lazega_contattr.txt', contattr, quote=F, col.names=T, row.names=F, sep="\t")

NB it is very important to have the sep="\t"  on write.table, 
otherwise MPNet will crash.

ADS
Fri, Nov 03, 2017 11:29:58 AM


LAZEGA--LAW FIRM

DATASETS LAZEGA LAZATT

DESCRIPTION

LAZEGA:	Three 71×71 matrices:

ADVICE non-symmetric, binary.
FRIENDSHIP non-symmetric, binary.
CO-WORK non-symmetric, binary.
LAZATT:	One 71×7 valued matrix.
BACKGROUND This data set comes from a network study of corporate law partnership that was carried out in a Northeastern US corporate law firm, referred to as SG&R, 1988-1991 in New England. It includes (among others) measurements of networks among the 71 attorneys (partners and associates) of this firm, i.e. their strong-coworker network, advice network, friendship network, and indirect control networks. Various members' attributes are also part of the dataset, including seniority, formal status, office in which they work, gender, lawschool attended. The ethnography, organizational and network analyses of this case are available in Lazega (2001).

Strong coworkers network:
"Because most firms like yours are also organized very informally, it is difficult to get a clear idea of how the members really work together. Think back over the past year, consider all the lawyers in your Firm. Would you go through this list and check the names of those with whom you have worked with. [By "worked with" I mean that you have spent time together on at least one case, that you have been assigned to the same case, that they read or used your work product or that you have read or used their work product; this includes professional work done within the Firm like Bar association work, administration, etc.]" 
Basic advice network:
"Think back over the past year, consider all the lawyers in your Firm. To whom did you go for basic professional advice? For instance, you want to make sure that you are handling a case right, making a proper decision, and you want to consult someone whose professional opinions are in general of great value to you. By advice I do not mean simply technical advice." 
Friendship network:
"Would you go through this list, and check the names of those you socialize with outside work. You know their family, they know yours, for instance. I do not mean all the people you are simply on a friendly level with, or people you happen to meet at Firm functions." 
Coding:
The three networks refer to cowork, friendship, and advice. The first 36 respondents are the partners in the firm. The attribute variables in the file LAZATT file.dat are:
1. status (1=partner; 2=associate)
2. gender (1=man; 2=woman)
3. office (1=Boston; 2=Hartford; 3=Providence)
4. years with the firm
5. age
6. practice (1=litigation; 2=corporate)
7. law school (1: harvard, yale; 2: ucon; 3: other) 
REFERENCES

Emmanuel Lazega, The Collegial Phenomenon: The Social Mechanisms of Cooperation Among Peers in a Corporate Law Partnership, Oxford University Press (2001).
Tom A.B. Snijders, Philippa E. Pattison, Garry L. Robins, and Mark S. Handcock. New specifications for exponential random graph models. Sociological Methodology (2006), 99-153.


