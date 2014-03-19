import os
import sys
import time
from urllib import FancyURLopener
import urllib2
import simplejson

# Open Name List and Read each One of them
file = open('nameList.txt', 'r')
for line in file:

    #Define search term
    folderName = line[:-1]
    searchTerm = folderName + " music"
    newpath = r'/Users/VEGLIGI/Desktop/MUSIC FESTIVAL/Pictures/'+folderName

    # Replace spaces ' ' in search term for '%20' in order to comply with request
    searchTerm = searchTerm.replace(' ','%20')
 
    # Start FancyURLopener with defined version 
    class MyOpener(FancyURLopener):
        version = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; it; rv:1.8.1.11) Gecko/20071127 Firefox/2.0.0.11'
    myopener = MyOpener()

    # Set count to 0
    count= 0

    # Notice that the start changes for each iteration in order to request a new set of images for each loop
    url = ('https://ajax.googleapis.com/ajax/services/search/images?' + 'v=1.0&imgsz=xlarge&q='+searchTerm+'&start='+str(0)+'&userip=MyIP')
    #print url
    request = urllib2.Request(url, None, {'Referer': 'testing'})
    response = urllib2.urlopen(request)

    # Get results using JSON
    results = simplejson.load(response)
    data = results['responseData']
    
    #if there is no data from Json.
    if data is None:
        #save it to the text file
        with open('unsussesfulUrls.txt', 'a') as text_file:
            text_file.write(folderName + '\n')
            print 'not saving   ' + folderName
            continue
    dataInfo = data['results']
    print 'saving  ' + folderName

        
    # Iterate for each result and get unescaped url
    for myUrl in dataInfo:
        count = count + 1
        
        #save image to new directory
        if not os.path.exists(newpath): os.makedirs(newpath)
        try:
            myopener.retrieve(myUrl['unescapedUrl'],newpath+'/'+str(count)+'.jpg')
        except:
            with open('unsussesfulUrls.txt', 'a') as text_file:
            text_file.write(folderName + '\n')
            print 'problem at saving pictures of artist ' + folderName
            
        #save URLS to text file
        #print myUrl['unescapedUrl']
        with open(newpath+'/'+ 'Urls.txt', 'a') as text_file:
            text_file.write(myUrl['unescapedUrl'] + '\n')

# Sleep for one second to prevent IP blocking from Google
time.sleep(1)
print 'ALL FINISHED !!!'







