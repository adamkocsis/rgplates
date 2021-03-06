# tectonic - models

#' Class of objects representing plate tectonic models
#' 
#' Meta-object containing paths to a unique plate tectonic model
#' 
#' @rdname platemodel
#' @exportClass platemodel
platemodel <- setClass(
	"platemodel",
	slots=list(name="character", rotation="character", polygons="character", version="character"))

#' @param .Object Constructor argument (not needed).
#' @param path (\code{character}) Path to a .mod unique plate model object.
#' @param rotation (\code{character}) If \code{path} is \code{NULL}, the path to the rotation file-part of the model.
#' @param polygons (\code{character}) If \code{path} is \code{NULL}, the path to the plate polygon file-part of the model.
#' @rdname platemodel 
#' @return A \code{platemodel} class object.
#' @export platemodel
#' @examples
#' # path to provided archive
#' archive <- file.path(
#'   system.file("extdata", package="rgplates"), 
#'   "paleomap_model_v19o_r1c.zip")
#' # extract to temporary directory
#' unzip(archive, exdir=tempdir())
#' # path to the combined model/rotation file
#' path <- file.path(tempdir(), 
#'   "paleomap_model_v19o_r1c/paleomap_model_v19o_r1c.mod")
#' # register in R - to be used in reconstruct()
#' model <- platemodel(path)
setMethod("initialize",signature="platemodel",
	definition=function(.Object,path=NULL, rotation=NULL, polygons=NULL){
		if(!is.null(path)){
			fullPath <- normalizePath(path)

			# replace windows like paths with UNIX paths
			fullPath <- gsub("\\\\","/", fullPath)
	
			# get the directory
			all <- unlist(strsplit(fullPath, "/"))
			dir <- paste(all[-length(all)], collapse="/")
	
			lin <- readLines(path, 4)
			.Object@name <- gsub("name: ", "", lin[1])
			.Object@rotation <- gsub("rotation: ", "", file.path(dir, lin[2]))
			.Object@polygons <- gsub("polygons: ", "", file.path(dir, lin[3]))
			.Object@version <- gsub("version: ", "", lin[4])
		}else{
			if(is.null(rotation) | is.null(polygons))
				stop("You have to provide both a rotation file and a polygons object.")
			.Object@rotation <- rotation
			.Object@polygons <- polygons
			.Object@name <- ""
			.Object@version <- ""
		}

		return(.Object)
	}
)


setMethod("show",signature="platemodel",
	definition=function(object){
		cat("GPlates plate tectonic model.\n")
		if(object@name!="") cat(object@name, "\n - ")
		if(object@version!="") cat( object@version, "\n")

		cat("static polygons: ", paste("\"", fileFromPath(object@polygons),"\"", sep=""), "\n")
		cat("rotation:        ", paste("\"", fileFromPath(object@rotation),"\"", sep=""), "\n")

	}
)

	
