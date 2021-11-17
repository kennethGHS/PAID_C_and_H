import cv2
import numpy as np
import matplotlib.pyplot as plt
 
img_original = cv2.imread('linea3.jpg')
img = cv2.imread('linea3.jpg')
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(gray,50,150,apertureSize = 3)

#Detect the lines in the image 
lines = cv2.HoughLines(edges,1,np.pi/180,75)#the last number is the
                                    #detection umbral
#Calculate and draw each line detected
for x in lines:
    for rho,theta in x:
        a = np.cos(theta)
        b = np.sin(theta)
        x0 = a*rho
        y0 = b*rho
        x1 = int(x0 + 1000*(-b))
        y1 = int(y0 + 1000*(a))
        x2 = int(x0 - 1000*(-b))
        y2 = int(y0 - 1000*(a))

        cv2.line(img,(x1,y1),(x2,y2),(255,0,0),1)

fig=plt.figure()

subplot1=fig.add_subplot(1,2,1)
subplot1.imshow(img_original,cmap='gray',vmin=0,vmax=255)
subplot1.title.set_text('Imagen Original')

subplot2=fig.add_subplot(1,2,2)
subplot2.imshow(img,cmap='gray',vmin=0,vmax=255)
subplot2.title.set_text('Transformada de Hough para líneas rectas')
