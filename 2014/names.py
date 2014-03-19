from xml.dom import minidom

xmldoc = minidom.parse('Data2012.xml')
itemlist = xmldoc.getElementsByTagName('artistName')
print len(itemlist)
for i in itemlist:
    artistName = i.firstChild.wholeText
    cleanArtistName = artistName[2:-2]
    print cleanArtistName    
    with open('nameList.txt', 'a') as text_file:
        text_file.write(cleanArtistName.encode('utf-8')+ '\n')



    
    
    
