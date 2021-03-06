# Krona
# Language: R
# Input: TXT
# Output: PREFIX
# Tested with: PluMA 1.1, R 4.0.0
# Dependencies: phyloseq 1.32.0, ape 5.4, psadd 0.1.2, microbiome 1.10.0

PluMA plugin that takes generates a Krona plot based on OTU abundances and a corresponding phylogenetic tree.  The plot is differentiated based on a column in a mapping file.

All of this information is specified in the input TXT file, as tab-delimited keyword-value pairs:

otufile: OTU abundances (CSV)
mapping: Mapping table (CSV)
tree: Phylogenetic tree (CSV)
column: (STRING)

Output will be generated using the provided prefix as a directory.  prefix.html references files in this directory when displaying the Krona plot.

We use a modified version of the plot_krona function provided in psadd 0.1.2 (this modified version has been included), with the last line commented out to avoid interactively displaying the plot.


Format of the otufile CSV:
- Rows are OTUs, columns are samples
- Entry (i,j) is the abundance of OTU in sample j.  Can be absolute or relative.

Format of the mapping CSV:
- Rows are samples, columns are metadata
- One single header row, i.e: sample,subject,visit

Format of the tree CSV;
- Rows are OTUs, columns are classifications
- One single header row, i.e. OTU,Kingdom,Phylum,Class,Order,Family,Genus,Species

