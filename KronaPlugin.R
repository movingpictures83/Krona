
dyn.load(paste("RPluMA", .Platform$dynlib.ext, sep=""))
source("RPluMA.R")

library(microbiome)
#library(SpiecEasi)
#library(ggplot2)
library(phyloseq)
library(ape)
#library(philr)
library(psadd)

plot_krona <-
function (physeq, output, variable, trim = F) 
{
    if (system(command = "which ktImportText", intern = FALSE, 
        ignore.stdout = TRUE)) {
        stop("KronaTools are not installed. Please see https://github.com/marbl/Krona/wiki/KronaTools.")
    }
    if (is.null(tax_table(physeq))) {
        stop("No taxonomy table available.")
    }
    if (!variable %in% colnames(sample_data(physeq))) {
        stop(paste(variable, "is not a variable in the sample data."))
    }
    if (trim == FALSE) {
        spec.char <- grepl(" |\\(|\\)", as(sample_data(physeq), 
            "data.frame")[, variable])
        if (sum(spec.char > 0)) {
            message("The following lines contains spaces or brackets.")
            print(paste(which(spec.char)))
            stop("Use trim=TRUE to convert them automatically or convert manually before re-run")
        }
    }
    df <- psmelt(physeq)
    df <- df[, c("Abundance", variable, rank_names(physeq))]
    df[, 2] <- gsub(" |\\(|\\)", "", df[, 2])
    df[, 2] <- as.factor(df[, 2])
    dir.create(output)
    for (lvl in levels(df[, 2])) {
        write.table(unique(df[which(df[, 2] == lvl), -2]), file = paste0(output, 
            "/", lvl, "taxonomy.txt"), sep = "\t", row.names = F, 
            col.names = F, na = "", quote = F)
    }
    krona_args <- paste(output, "/", levels(df[, 2]), "taxonomy.txt,", 
        levels(df[, 2]), sep = "", collapse = " ")
    output <- paste(output, ".html", sep = "")
    system(paste("ktImportText", krona_args, "-o", output, sep = " "))
    #browseURL(output)
}


input <- function(inputfile) {
  pfix = prefix()
  if (length(pfix) != 0) {
     pfix <- paste(pfix, "/", sep="")
  }
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1]; 
   # Need to get the three files
   otu.path <<- parameters["otufile", 2]
   tree.path <<- parameters["tree", 2]
   map.path <<- parameters["mapping", 2]
   diffcol <<- parameters["column", 2]
  if (!(startsWith(otu.path, "/"))) {
   otu.path <<- paste(pfix, otu.path, sep="")
  }
  if (!(startsWith(tree.path, "/"))) {
   tree.path <<- paste(pfix, tree.path, sep="")
  }
  if (!(startsWith(map.path, "/"))) {
   map.path <<- paste(pfix, map.path, sep="")
  }
   print(otu.path)
   print(tree.path)
   print(map.path)
   #HMP <<- import_qiime(otu.path, map.path, tree.path, parseFunction = parse_taxonomy_qiime)
}


run <- function() {
   p0 <<- read_csv2phyloseq(otu.file=otu.path, taxonomy.file=tree.path, metadata.file=map.path)
   #samples.to.keep <- sample_sums(HMP) >= 1000
   #HMP <<- prune_samples(samples.to.keep, HMP)
   #HMP <<- filter_taxa(HMP, function(x) sum(x >3) > (0.01*length(x)), TRUE)
   #phy_tree(HMP) <- makeNodeLabel(phy_tree(HMP), method='number', prefix='n')
    
   #trans_output <<- philr(t(otu_table(HMP)), phy_tree(HMP), part.weights='enorm.x.gm.counts', ilr.weights='blw.sqrt', return.all=FALSE)
}


output <- function(outputfile) {
  # This at the moment does not include any information about OTUs
  # For now I am only interested in the structure of the network.
  # This *needs* to change eventually.
  #print(HMP@sam_data)
  #pdf("helloworld.pdf")
  plot_krona(p0, outputfile, diffcol)
  #ggsave("helloworld.pdf", plot=last_plot(), device="pdf")
  #dev.off()
  
  #quit()
  #write.table(trans_output, file=outputfile, sep=",", append=FALSE, na="");  
}



