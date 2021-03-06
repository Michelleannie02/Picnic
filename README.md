# Picnic
App for finding and sharing cool places

This is my largest project as of Jan 2021. It was intended as a learning project with a useful result. The app allows users to create an account or login with their Google account using Firebase Authentication. Users can then view locations near them suitable for a picnic with an interactive map view or a vertical scrolling collection view. Users can filter these results based on any number of useful tags provided, actual radius from their location (see Geo-querying), or rating. Users can save posts to their profile for quick access at a later time. Users can write reviews on any location post which displays a timestamp and their profile picture, taken from Google if they logged in that way. Users can get directions with Apple Maps to any post. Users can search for locations directly, though this feature is incomplete and currently requires an exact text match. Users can post new locations through what I consider to be the most refined part of the app. Lastly, users can view posts they've created and fill out a basic profile page (incomplete).

Geo-querying:
The geo-query functionality is done by storing a relatively precise [Geohash](https://en.wikipedia.org/wiki/Geohash) for each post and generating the smallest Geohash region which contains all four corners of the first Geohash region. Entries in the database which are within this Geohash region and match other criteria provided are returned from a query and then filtered on the client for a precise radius based search. This was the best I could do at the time. The query will generally return a reasonably sized subset of entries around the user. There are issues with the user being too close to one of the bounds of the first Geohash level. This can cause the query to greatly lose specificity and increase client side calculation time.

Future Additions:
The app has some bugs which need to be worked out, particularly with the settings page because I tried to mix SwiftUI with UIKit and that did not go well, and with the map query. The search feature needs to be improved. I would initially do this with string reverse indexing but would like to be able to add natural language querying. As far as deleting/moderating content goes I would like to implement a system similar to stack overflow or reddit which shows only the best version of a post for a given location, allowing for competition. This would require that users be unable to delete their own posts once others add to them, which is odd but should be fine since they can still remove images or propose changes if they wish.

![Image 1](https://github.com/burns534/Picnic/blob/master/IMG_1639.jpeg)
![Image 2](https://github.com/burns534/Picnic/blob/master/IMG_1640.jpeg)
![Image 3](https://github.com/burns534/Picnic/blob/master/IMG_1641.jpeg)
![Image 4](https://github.com/burns534/Picnic/blob/master/IMG_1642.jpeg)


