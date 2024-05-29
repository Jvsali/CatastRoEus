#' Retrieve Address Data in Pais Vasco Based on Bounding Box Coordinates
#'
#' @description
#' Fetches address data within a specified bounding box. The function determines
#' the province based on the provided coordinates and fetches address data for
#' Bizkaia or Gipuzkoa accordingly. It checks if the bounding box
#' falls within a single province and handles different CRS inputs.
#'
#' @param x Bounding box coordinates or a spatial object, which could be:
#'   - A numeric vector of length 4 with the coordinates defining the bounding box:
#'     `c(latitude1, longitude1, latitude2, longitude2)`.
#'   - An `sf/sfc` object from the \CRANpkg{sf} package.
#' @param srs Spatial Reference System (SRS) or Coordinate Reference System (CRS) code 
#'   to be used in the query. For best results, ensure the coordinates are in ETRS89
#'   (EPSG:4258) or WGS84 (EPSG:4326) when using latitude and longitude.
#' @param verbose Logical; if `TRUE`, additional information about function operations 
#'   is printed. Useful for debugging. Default is `FALSE`.
#' @param count Integer specifying the maximum number of address records to return,
#'   or `NULL` to use default settings of the API service.
#'
#' @return Depending on the input and geographic location, this function may return:
#'   - A message detailing the success of the query and the province fetched.
#'   - A warning message if the bounding box spans multiple provinces.
#'   - An error message if the coordinates are not within Pais Vasco.
#'
#' @seealso \link[sf::st_bbox]{sf::st_bbox()}, which is used to manage spatial bounding boxes.
#'
#' @details
#' This function uses reverse geocoding to determine the province within the Basque Country
#' from the coordinates provided. Based on the province, it delegates the data fetching to
#' specific functions handling each province's data. It supports flexible input types and
#' handles geographical coordinate transformations internally if needed.
#'
#' @examples
#' \donttest{
#' # Define bounding box coordinates for an urban location in Gipuzkoa
#' coords_gipuzkoa <- c(43.026899, -2.433164, 43.308497, -2.063099)
#'
#' # Fetch address data using the bounding box
#' addresses_gipuzkoa <- catreus_wfs_get_address_bbox(coords_gipuzkoa, srs = 25830, count = 10)
#' 
#' #' library(ggplot2)
#' # Plot the buildings data
#' ggplot(addresses_gipuzkoa) +
#'   geom_sf() + ggtitle("Addresses Data for Gipuzkoa")
#'
#' # Define bounding box coordinates for a location in Bizkaia
#' coords_bizkaia <- c(43.312, -2.994, 43.313, -2.993)
#' 
#' # Fetch address data using the bounding box
#' addresses_bizkaia <- catreus_wfs_get_address_bbox(coords_bizkaia, srs = 4326)
#' 
#' library(ggplot2)
#' # Plot the buildings data
#' ggplot(addresses_bizkaia) +
#'   geom_sf() + ggtitle("Addresses Data for Bizkaia")
#' 
#' }
#'   
#' @export

catreus_wfs_get_address_bbox <- function(x, srs, verbose = FALSE,
                                               count = NULL){
  if ((x[2]<90) & (x[2]>-90)){
    lat1 = x[1]
    long1 = x[2]
    lat2 = x[3]
    long2 = x[4]
  }
  else {
    crs = 25830
    coords <- matrix(x, ncol = 2, byrow = TRUE)
    sf_object <- st_as_sf(data.frame(x = coords[,1], y = coords[,2]), coords = c("x", "y"), crs = crs)
    transformed_sf <- st_transform(sf_object, crs = 4326)
    coords <- st_coordinates(transformed_sf)
    lat1 = coords[1, "X"]
    long1 = coords[1, "Y"]
    lat2 = coords[2, "X"]
    long2 = coords[2, "Y"]
  }
  town_data1 = tidygeocoder::reverse_geo(lat = lat1,long = long1,method = "osm", full_results = TRUE)
  town_data2 = tidygeocoder::reverse_geo(lat = lat2,long = long2,method = "osm", full_results = TRUE)
  province1<- town_data1$province
  province2<- town_data2$province
  
  if ((province1 == "Bizkaia") & (province2 == "Bizkaia")){
    print("Province of Bizkaia:")
    print("-------------------------------")
    catreus_bizk_wfs_get_address_bbox(x, srs, count=count)
  }
  else if ((province1 == "Gipuzkoa") & (province2 == "Gipuzkoa")){
    print("Province of Gipuzkoa:")
    print("-------------------------------")
    catreus_gipu_wfs_get_address_bbox(x, srs, count=count)
  }
  else if (province1 != province2){
    print("This coordinates englobe 2 differente province, please select coordinates for 1 province")
  }
  else {
    print("This coordinates aren't from Pais Vasco")
  }
}