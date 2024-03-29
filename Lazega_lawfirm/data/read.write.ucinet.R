#################################################
# Script providing R functions to export UCINET
# network files from simple R matrix objects.
# version of 18 June 2015
# written by Christian Steglich
#################################################

# This R script creates two functions 'read.ucinet()' and
# write.ucinet() that facilitate import and export of
# UCINET files in R sessions.

read.ucinet <- function(filename) {
# function for reading UCINET data files (recent versions only)
# filename = UCINET filename (without ## extension)

	read.ucinet.header <- function(filename) {
	# function for reading UCINET header files (recent versions only)
		UCINET.header <- file(paste(filename,".##h",sep=''),"rb")
		ignore <- readBin(UCINET.header,what="int",size=1)
		headerversion <- paste(
			rawToChar(readBin(UCINET.header,what="raw",size=1)),
			rawToChar(readBin(UCINET.header,what="raw",size=1)),
			rawToChar(readBin(UCINET.header,what="raw",size=1)),
			rawToChar(readBin(UCINET.header,what="raw",size=1)),
			rawToChar(readBin(UCINET.header,what="raw",size=1)),
			sep='')
		if (!(headerversion %in% c('DATE:','V6404'))) {
			close(UCINET.header)
			stop(paste('unknown header type; try more recent UCINET file types'))
		}
		year <- 2000+readBin(UCINET.header,what="int",size=2)
		month <- c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug',
			'Sep','Oct','Nov','Dec')[readBin(UCINET.header,what="int",size=2)]
		day <- readBin(UCINET.header,what="int",size=2)
		dow <- c('Monday','Tuesday','Wednesday','Thursday','Friday',
			'Saturday','Sunday')[readBin(UCINET.header,what="int",size=2)]
		labtype <- readBin(UCINET.header,what="int",size=2)
		infile.dt <- c('nodt','bytedt','booleandt','shortintdt','worddt',
			'smallintdt','longintdt',' singledt','realdt','doubledt',
			'compdt','extendeddt','labeldt','setdt','stringdt','pointerdt',
			'chardt','integerdt','nodelistdt','sparsedt','int64dt')[
			readBin(UCINET.header,what="int",size=1)]
		ndim <- readBin(UCINET.header,what="int",size=2)
		if (headerversion=='V6404') {fct=2} else {fct=1}
		dims <- c(readBin(UCINET.header,what="int",size=2*fct),
			readBin(UCINET.header,what="int",size=2*fct))
		if (ndim==3) {
			dims[3] <- readBin(UCINET.header,what="int",size=2*fct)
		}
		if (!(ndim==2|ndim==3&dims[3]==1)) {
			close(UCINET.header)
			stop(paste('UCINET file with',dims[3],'levels; please convert separately'))
		}
		t.length <- readBin(UCINET.header,what="int",size=1)
		if (t.length>0){
			titl <- sapply(1:t.length,function(i){
				rawToChar(readBin(UCINET.header,what="raw",size=1))
			})
			titl <- paste(titl,collapse='')
		} else {titl <- ''}
		haslab <- c(readBin(UCINET.header,what="logical",size=1),
			readBin(UCINET.header,what="logical",size=1))
		if (ndim==3) {
			haslab[3] <- readBin(UCINET.header,what="logical",size=1)
		}
		dim.labels <- list()
		for (arr.dim in 1:length(dims)) {
		if (haslab[arr.dim]) {
			dim.labels[[arr.dim]] <- rep(NA,dims[arr.dim])
			for (i in 1:dims[arr.dim]) {
				lab <- ''
				lablen <- readBin(UCINET.header,what="int",size=2)
				for (let in 1:lablen) {
					lab <- paste(lab,
						rawToChar(readBin(UCINET.header,what="raw",size=1)),
						sep='')
				}
				dim.labels[[arr.dim]][i] <- lab
			}
		}}
		close(UCINET.header)
		if (ndim==3&dims[3]==1) {
			titl <- dim.labels[[3]][1]
			warning(paste('UCINET file with one level; level name "',
				titl,'" treated as network name',sep=''))
			ndim <- 2
			dims <- dims[1:2]
			haslab <- haslab[1:2]
			dim.labels <- dim.labels[1:2]
		}
		return(list(
			headerversion=headerversion,
			date=paste(dow,paste(day,month,year,sep='-')),
			labtype=labtype,
			infile.dt=infile.dt,
			ndim=ndim,
			dims=dims,
			title=titl,
			haslab=haslab,
			dim.labels=dim.labels
		))
	}

	# begin of main function code:
	header <- read.ucinet.header(filename)
	UCINET.data <- file(paste(filename,".##d",sep=''),"rb")
	thedata <- c()
	for (i in 1:(header$dims[1]*header$dims[2]))
		thedata[i] <- readBin(UCINET.data,what="numeric",size=4,endian='little')
	close(UCINET.data)
	mat <- matrix(thedata,nr=header$dims[2],nc=header$dims[1],
		dimnames=header$dim.labels[c(2,1)],byrow=TRUE)
	# put additional info from header file on matrix
	if (header$title!='') {attr(mat,'title') <- header$title}
	attr(mat,'date') <- header$date
	#attr(mat,'labtype') <- header$labtype
	#attr(mat,'infile.dt') <- header$infile.dt
	return(mat)
}

write.ucinet <- function(mat,filename,name=deparse(substitute(mat))) {
# function for writing UCINET files in V6404 file format;
# mat = matrix to be exported
# filename = UCINET filename (without ## extension)
# name = name of matrix to be known in UCINET

	# start with UCINET header file:
	UCINET.header <- file(paste(filename,".##h",sep=''),"wb")
	writeBin(as.integer(5),UCINET.header,size=1)
	writeBin(charToRaw('V'),UCINET.header,size=1)
	writeBin(charToRaw('6'),UCINET.header,size=1)
	writeBin(charToRaw('4'),UCINET.header,size=1)
	writeBin(charToRaw('0'),UCINET.header,size=1)
	writeBin(charToRaw('4'),UCINET.header,size=1)
	year <- as.integer(substr(Sys.Date(),3,4))
	writeBin(year,UCINET.header,size=2)
	month <- as.integer(substr(Sys.Date(),6,7))
	writeBin(month,UCINET.header,size=2)
	day <- as.integer(substr(Sys.Date(),9,10))
	writeBin(day,UCINET.header,size=2)
	dow <- which(c('Mon','Tue','Wed','Thu','Fri','Sat','Sun')==substr(date(),1,3))
	writeBin(dow,UCINET.header,size=2)
	writeBin(as.integer(3),UCINET.header,size=2) # labtype, unused in V6404 files
	writeBin(as.integer(7),UCINET.header,size=1) # infile.dt = 7 'longintdt'
	writeBin(as.integer(2),UCINET.header,size=2) # ndim = 2 for matrix
	writeBin(ncol(mat),UCINET.header,size=4) # number of columns of matrix
	writeBin(nrow(mat),UCINET.header,size=4) # number of rows of matrix
	writeBin(nchar(name),UCINET.header,size=1) # length of matrix name
	if (nchar(name)>0) {
	for (i in 1:nchar(name)) {
		writeBin(charToRaw(substr(name,i,i)),UCINET.header,size=1)
	}}
	labc <- colnames(mat)
	#Encoding(labc) <- "UTF-8"
	if (!is.null(labc)) {
	if (length(table(labc))!=length(labc)) {
		labc <- NULL
		warning('non-unique column labels, all column labels are dropped')
	}}
	writeBin(!is.null(labc),UCINET.header,size=1)
	labr <- rownames(mat)
	#Encoding(labr) <- "UTF-8"
	if (!is.null(labr)) {
	if (length(table(labr))!=length(labr)) {
		labr <- NULL
		warning('non-unique row labels, all row labels are dropped')
	}}
	writeBin(!is.null(labr),UCINET.header,size=1)
	if (!is.null(labc)) {
	for (i in 1:ncol(mat)) {
		writeBin(as.integer(2*nchar(labc[i])),UCINET.header,size=2)
		for (let in 1:nchar(labc[i])) {
			writeBin(charToRaw(substr(labc[i],let,let)),
				UCINET.header,size=1)
			writeBin(raw(1),UCINET.header,size=1)
		}
	}}
	if (!is.null(labr)) {
	for (i in 1:nrow(mat)) {
		writeBin(as.integer(2*nchar(labr[i])),UCINET.header,size=2)
		for (let in 1:nchar(labr[i])) {
			writeBin(charToRaw(substr(labr[i],let,let)),
				UCINET.header,size=1)
			writeBin(raw(1),UCINET.header,size=1)
		}
	}}
	close(UCINET.header)
	
	# continue with UCINET data file:
	UCINET.data <- file(paste(filename,".##d",sep=''),"wb")
	for (i in 1:length(mat))
		writeBin(t(mat)[i],UCINET.data,size=4,endian='little')
	close(UCINET.data)
}
