# NextMovies App

Application to see upcoming movies on US and it's details. Powered by [TheMovieDataBase](https://www.themoviedb.org) website.

## Build instructions

It's necessary to install and run cocoapods.

## Libraries

### Alamofire

It's used in **MovieApi.swift** file only. It has been added to simplify all request to TMDb Api.

### AlamofireImage

It's a library used make easier to download image and keep it in cache for future reuse.

It's used on:

* MovieCell.swift
* DetailViewController.swift
* HighlightCollectionItemCell

### SwiftLint

It's used in all files from the project, except for files from pod. It has been added to keep the project clean from code smell.
