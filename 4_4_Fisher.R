Arg<-commandArgs(TRUE)
dir<-c(Arg[1])
pileup<-c(Arg[2])
data_size1<-c(Arg[3])
data_size2<-c(Arg[4])
OUTPUT_name<-c(Arg[5])
#############################################
setwd(dir)
DATA<-read.table(pileup,header=F)
SIZE1<-read.table(data_size1,header=F)
SIZE2<-read.table(data_size2,header=F)

P1_theoretical_size<-SIZE1[1,1]
P2_theoretical_size<-SIZE2[1,1]

demo_p_value1<-c()
demo_p_value2<-c()

for(a in 1:30){
	mx=matrix(c(P1_theoretical_size,P2_theoretical_size,0,a),nrow=2,byrow=T)
	demo_p_value1<-c(demo_p_value1,fisher.test(mx)$p.value)
}

for(a in 1:30){
 	mx=matrix(c(P1_theoretical_size,P2_theoretical_size,a,0),nrow=2,byrow=T)
 	demo_p_value2<-c(demo_p_value2,fisher.test(mx)$p.value)
}

line_num<-nrow(DATA)
for(i in 1:line_num){
	P1_measured_depth<-DATA[i,3]
	P1_mut<-DATA[i,4]
	P2_measured_depth<-DATA[i,5]
	P2_mut<-DATA[i,6]
	
	if(P1_measured_depth == 0){
		if(P2_measured_depth<=30){
			# print(DATA[i,4])
			p_value<-demo_p_value1[P2_measured_depth]
		}else{
			mx=matrix(c(P1_theoretical_size,P2_theoretical_size,0,P2_measured_depth),nrow=2,byrow=T)
			p_value<-fisher.test(mx)$p.value
		}
	}else if(P2_measured_depth == 0){
		if(P1_measured_depth<=30){
			p_value<-demo_p_value2[P1_measured_depth]
		}else{
			mx=matrix(c(P1_theoretical_size,P2_theoretical_size,P1_measured_depth,0),nrow=2,byrow=T)
			p_value<-fisher.test(mx)$p.value
		}
	}else{
		mx=matrix(c(P1_measured_depth,P2_measured_depth,P1_mut,P2_mut),nrow=2,byrow=T)
		p_value<-fisher.test(mx)$p.value
	}
	
	p_value<-p_value*1000
	p_value<-floor(p_value)
	p_value<-p_value/1000
	
	x<-c(DATA[i,], p_value)
	write.table(x,OUTPUT_name,quote=F,,row.names=F,col.names=F,append=T)
	
	
}


