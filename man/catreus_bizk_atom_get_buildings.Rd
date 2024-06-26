% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/atom_bizk_bu.R
\name{catreus_bizk_atom_get_buildings}
\alias{catreus_bizk_atom_get_buildings}
\title{ATOM INSPIRE: Download all the buildings of a municipality in Bizkaia}
\usage{
catreus_bizk_atom_get_buildings(
  munic,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
}
\arguments{
\item{munic}{Municipality to extract, It can be a part of a string or the
buildings code. See \link{catreus_bizk_atom_get_buildings_db_all}.}

\item{cache}{A logical whether to do caching. Default is \code{TRUE}. See
\strong{About caching} section on \code{\link[=catreus_set_cache_dir]{catreus_set_cache_dir()}}.}

\item{update_cache}{A logical whether to update cache. Default is \code{FALSE}.
When set to \code{TRUE} it would force a fresh download of the source file.}

\item{cache_dir}{A path to a cache directory. On missing value the function would store the cached files on a temporary dir (See \code{\link[base:tempfile]{base::tempdir()}}).}

\item{verbose}{Logical, displays information. Useful for debugging, default is \code{FALSE}.}
}
\value{
A \code{\link[sf:sf]{sf}} object.
}
\description{
Get the spatial data of all the buildings belonging to a single
municipality using the INSPIRE ATOM service.
}
\examples{
\donttest{

s <- catreus_bizk_atom_get_buildings("ABADIÑO")

library(ggplot2)

ggplot(s) +
  geom_sf() +
  labs(
    title = "Buildings Zoning",
    subtitle = "ABADIÑO"
  )
}
}
\references{
\href{https://www.bizkaia.eus/es/inspirebizkaia}{INSPIREBIZKAIA}
}
\seealso{
Other ATOM: 
\code{\link{catreus_bizk_atom_get_addresses}()},
\code{\link{catreus_bizk_atom_get_addresses_db_all}()},
\code{\link{catreus_bizk_atom_get_buildings_db_all}()},
\code{\link{catreus_bizk_atom_get_parcels}()},
\code{\link{catreus_bizk_atom_get_parcels_db_all}()}

Other buildings: 
\code{\link{catreus_bizk_atom_get_buildings_db_all}()}
}
\concept{ATOM}
\concept{buildings}
