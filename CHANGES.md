# Change log

## 0.6.0
* Added `fps` to `Pexels::Video::File`.

## 0.5.0
* Expose timeout options

## 0.4.0
* Add support for returning featured collections.

## 0.3.0
* Add support for photo and video search with filters.
* Added `avg_color` attribute to `Photo` object.

## 0.2.1
* Added `type`, `photo?` and `video?` helper methods to `Photo` and `Video` classes.

## 0.2.0
* Fixed incorrect URL for collections endpoints.
* Added pagination methods `next_page` and `prev_page` to `PaginatedResponse`.
* Added `total_pages` to `PaginatedResponse`.
* Extracted `Request` and `Response` objects for reusability.
* Added `Pexels/Ruby` `User-Agent` header to requests.

## 0.1.0
* Add support for returning collections belonging to the API user.
* Add support for returning media from a collection.

## 0.0.4
* Add `find` as an alias for `photos[]` and `videos[]`.

## 0.0.3
* Initial release.
