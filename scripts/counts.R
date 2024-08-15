# Load libraries
library(pacman)
p_load(tools,dplyr,purrr,WriteXLS, fs)

# Take the input commands
args = commandArgs(trailingOnly=TRUE)

# Snakemake inputs

# wig_loc<-file.path("E691C_E691C_330250w_IB10","counts")
wig_loc<-file.path(args[1],"counts")
# print(wig_loc)
# wig_loc<-"."
ref_loc<-args[2]
# ref_loc<-"../../reference/reference_trimmed.fa"
# Read the reference sequence
seq<-read.csv(file = ref_loc, header=T)
# Sample name
sample<-args[1]
# # Break the sequence into single bases
reference<-strsplit(seq$X.refenv,"")[[1]]

# # List wig files
wig_files<-list.files(path=wig_loc, pattern="\\.wig")

## extract wig files for each category
total_counts <- grep("all", wig_files, value = T)
no_strand_counts <- grep("no_strand", wig_files, value = T)
both_strand_counts <- grep("both_strand", wig_files, value = T)

# Function to read files from list
parse_file <-  function(input_file_list,rows_to_skip, col_names, header){
    sapply(seq(1:length(input_file_list)), function(x)
    read.csv(
        file.path(wig_loc, input_file_list[[x]]),
        header = header,
        skip = as.integer(rows_to_skip),
        sep = "\t",
        col.names = col_names
    ), simplify = F, 
    USE.NAMES = T)
}

# Add proportions to merged data frame
add_proportion<- function(df, cols){
    df['total_counts'] <- rowSums(df[,cols])
    df['non_ref_counts'] <- apply(df, 1, function(x) sum(as.integer(x[cols][!cols %in% x['reference']])))
    df['Non_ref_proportion %'] <- df['non_ref_counts']/df['total_counts']
    df['Non_ref_proportion'] <- round(df['Non_ref_proportion %']*100,3)
    return(df)
}

# Bases of interest
cols=c("A","C","G","T","N")

## Read all counts
total_counts_df<-parse_file(total_counts,2,c("Position","counts"),F)
names(total_counts_df)<- fs::path_ext_remove(total_counts)

## Read No strand specific, but base specific
no_strands_df <- parse_file(no_strand_counts,3,col_names = c("Position","A","C","G","T","N","DEL","INS"), header = F)
names(no_strands_df)<-  fs::path_ext_remove(no_strand_counts)
# Remove del and ins columns
no_strands_df <- lapply(no_strands_df, "[", -c(7, 8))

## Read strand specific and base specific
both_strands_df<- parse_file(both_strand_counts, 3, col_names = c("Position", "Positive A", "Positive C", "Positive G", "Positive T", "Positive N", "Positive Strand DEL", "Positive Strand INS", "Negative Strand A", "Negative Strand C", "Negative Strand G", "Negative Strand T", "Negative Strand N", "Negative Strand DEL", "Negative Strand INS"), header = F)
names(both_strands_df)<-  fs::path_ext_remove(both_strand_counts)
both_strands_df <- lapply(both_strands_df, "[", -c(7, 8,14,15))

# Convert reference to dataframe
reference<-as.data.frame(reference)
reference$position<-row.names(reference)
reference<-reference[,c(2,1)]
reference$blank <- NA

# Both strands merged with reference. 
both_strands_df_merged<-sapply(names(both_strands_df), function(x) merge(reference, both_strands_df[[x]], by.x ="position", by.y = "Position", sort = F), simplify = F, USE.NAMES = T)

# No strand specific, only per base merged with reference
no_strands_df_merged<-sapply(names(no_strands_df), function(x) merge(reference, no_strands_df[[x]], by.x ="position", by.y = "Position", sort = F), simplify = F, USE.NAMES = T)

# Add non-reference base counts to dataframe
no_strands_df_merged <- sapply(no_strands_df_merged, function(x) add_proportion(x,cols), simplify = F, USE.NAMES = T) 

# Total counts merged with reference
total_counts_df_merged<-sapply(names(total_counts_df), function(x) merge(reference, total_counts_df[[x]], by.x ="position", by.y = "Position", sort = F), simplify = F, USE.NAMES = T)

# # Aligners used in analysis
aligners=c("bwa","bt2")

#̧ls(pattern = "df_merged")
rm(list = ls(pattern = "df$"))

# Combine all lists
all<-c(mget(sort(ls(pattern = "df_merged"), decreasing = T)))
all<-unlist(all, recursive = F)

# Remove data frames
rm(list=ls(pattern = "df_merged"))
gc()
# Group each aligner data
extract_aligner_data<-sapply(aligners, function(x) all[grepl(x,names(all))], simplify = F, USE.NAMES = T)
rm(all)
gc()
# Merge all the columns by position and reference
extract_aligner_data<-sapply(names(extract_aligner_data), function(x) reduce(extract_aligner_data[[x]], full_join, by=c("position","reference")), simplify = F, USE.NAMES = T)

# # Create headers for each category
header<-c(rep("",3),"Total", rep("",3),"No Strand",  rep("",11), "Both_Strand",rep("",5))

# # Add a header for better spacing
extract_aligner_data<-sapply(names(extract_aligner_data), function(x) rbind(header,extract_aligner_data[[x]]), simplify = F, USE.NAMES = T)


# # Save the results as excel file
WriteXLS::WriteXLS(extract_aligner_data, file.path(wig_loc,paste0(sample,".xlsx")))
# save.image("test.Rdata")
