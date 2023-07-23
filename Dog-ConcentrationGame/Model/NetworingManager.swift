import Alamofire

class NetworkingManager {
    static func fetchImagesFromFlickr(completion: @escaping ([String]?) -> Void) {
        let apiKey = "010f686dfb818c5d85ea7433a365477e"
        let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&tags=scenic&per_page=12&format=json&nojsoncallback=1"

        AF.request(url).responseJSON { response in
            // Handle API response and extract image URLs
            if let data = response.data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let photos = json["photos"] as? [String: Any],
               let photoArray = photos["photo"] as? [[String: Any]] {

                // Use a set to store unique image URLs
                var uniqueImageUrls = Set<String>()

                for photo in photoArray {
                    if let farmId = photo["farm"] as? Int,
                       let serverId = photo["server"] as? String,
                       let photoId = photo["id"] as? String,
                       let secret = photo["secret"] as? String {
                        let imageUrl = "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secret).jpg"
                        uniqueImageUrls.insert(imageUrl)

                        // If we have fetched 12 unique image URLs, we can stop fetching more
                        if uniqueImageUrls.count == 6 {
                            break
                        }
                    }
                }

                // Ensure that we have exactly 12 unique image URLs
                if uniqueImageUrls.count == 6 {
                    let imageUrls = Array(uniqueImageUrls)
                    // Double the imageUrls array to match 6 pairs
                    let doubledImageUrls = imageUrls + imageUrls
                    let shuffledImageUrls = doubledImageUrls.shuffled()
                    completion(shuffledImageUrls)
                } else {
                    print("Error: Did not receive 12 unique image URLs.")
                    completion(nil)
                }
            } else {
                print("Error: Failed to parse API response.")
                completion(nil)
            }
        }
    }
}
