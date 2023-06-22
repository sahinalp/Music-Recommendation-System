import requests
import shutil
from PIL import Image

class AppHelper():
    def __init__(self):
        self.song_link=None

    def getSongImage(self,uri):
        self.song_link="https://open.spotify.com/track/"+uri.split(":")[-1]
        x = requests.get(self.song_link)
        image_link=str(x.content).split('img')[1]
        image_link=image_link.split('src="')[1]
        image_link=image_link.split('"')[0]
        path = "images/"+uri.split(":")[-1]+".png"
        r = requests.get(image_link, stream=True)
        if r.status_code == 200:
            with open(path, 'wb') as f:
                r.raw.decode_content = True
                shutil.copyfileobj(r.raw, f)
        else:
            width = 600
            height = 600
            image = Image.new("RGB", (width, height), color="black")
            image.save(path)
    
    def findFavoriteCluster(self,cluster_numbers):
        clusters = {}
        for num in cluster_numbers:
            clusters[num] = cluster_numbers.count(num)
        user_favorite_cluster = [(k, v) for k, v in sorted(clusters.items(), key=lambda item: item[1])][-1][0]
        return user_favorite_cluster

    def getArtistName(self,song_link):
        x = requests.get(song_link)
        return str(x.content).split('by')[1].split('|')[0].strip()