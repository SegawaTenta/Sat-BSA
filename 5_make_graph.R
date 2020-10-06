Arg<-commandArgs(TRUE)
data<-c(Arg[1])
# s_posi
# e_posi
# tig
# gene_id

#############################################
# setwd(dir)

x_bar<-c()
y_bar<-c()

for(i in s_posi:e_posi){
	x_bar<-c(x_bar,i/1000)
	y_bar<-c(y_bar,0.05)
}
############################################
output_name<-paste("gene_id",".png")

png(output_name, width = 1100, height = 400)

par(las=1,
	xaxs="i",
	yaxs="i",
	cex.main=2.5,
	cex.lab=2,
	cex.axis=1.5,
	font.lab=2,
	font.axis=2,
	lwd = 5,
	mar=c(5,5,5,5),
	bty="l"
)

plot(x_bar,y_bar,
	xlim=c(min(x_bar),max(x_bar)),ylim=c(0,1.05),
	type="l",col=8,lwd=4,
	main="tig",xlab="Position(kb)",ylab="p-value"
)
###########################################
ReadsDATA<-read.table(data,header=F)
# print(ReadsDATA)
line_num<-nrow(ReadsDATA)

for(i in 1:line_num){
	path<-ReadsDATA[i,1]
	col<-ReadsDATA[i,2]

	compare<-path
	compare_m <- as.character(compare)
	compare_mm <-basename(compare_m)
	# print(compare_mm)
	compare_mmm<-strsplit(compare_mm,"_vs_")
	P1_name<-compare_mmm[1]
	P2_name<-compare_mmm[2]

	file_name<-paste(path,"/filter_InDel_size_Fishered_",compare_mm,".pileup",sep="")
	PileupDATA<-read.table(file_name,header=F)
	print(file_name)

	line<-c()
	line_num<-nrow(PileupDATA)
	for(i in 1:line_num){
		if(PileupDATA[i,1] == "tig" ){
			if(s_posi <=PileupDATA[i,2]){
				if(PileupDATA[i,2]<= e_posi){
					line<-c(line,i)
				}
			}
		}
	}

	x1<-PileupDATA[line,2]/1000
	y1<-PileupDATA[line,7]

	par(new=T)

	col_m<-paste("#",col,sep="")
	print(col_m)

	plot(x1,y1,
		xlim=c(min(x_bar),max(x_bar)),ylim=c(0,1.05),
		type="b",col=col_m,pch=3,lwd=4,
		main="tig",xlab="Position(kb)",ylab="p-value"
	)
}

dev.off()
