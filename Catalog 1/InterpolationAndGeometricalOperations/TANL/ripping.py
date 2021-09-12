import imageio
import numpy as np
from PIL import Image
import math
import moviepy

def resizeImage(M):
    M = M.resize((128, 128), Image.ANTIALIAS) #Do a resize so dont take to much time
    M.save("landscape.jpg")
def setInitialFrames(M,img):
    for i in range(0, 5):   #Sets the first 5 seconds of the video to the initial image

        M[:, :, 0, i] = img[:, :, 0]
        M[:, :, 1, i] = img[:, :, 1]
        M[:, :, 2, i] = img[:, :, 2]
    return M
def setVideo(M):
    rippedVideo = imageio.get_writer("rippingVideo.mp4")
    for cont in range(0, 100):
        rippedVideo.append_data(M[:, :, :, cont])
    rippedVideo.close()
def rippingEffect(img):
    max_row, max_col = img.size #Get the dimentions of the image
    img = imageio.imread("landscape.jpg")
    r = len(img[0][0]) #Get the r because its a color image
    Lx = 75
    Ly = 75
    Ax = 15
    #Generate an white image
    transitionImage = np.zeros((max_row, max_col, r), dtype=np.uint8)
    #Set the video matrix of 50 images
    videoMatrix = np.zeros((max_row, max_col, r, 100), dtype=np.uint8)
    Y = setInitialFrames(videoMatrix, img)
    framwImage = 3
    for Ay in range(15, 200, 5):
        for x in range(0, max_row-1):
            for y in range(0, max_col-1):
                xaux = round(x+Ax*math.sin(2*math.pi*y/Lx))
                yaux = round(y+Ay*math.sin(2*math.pi*x/Ly))
                if 0 <= xaux < max_row:
                    if 0 <= yaux < max_col:
                        transitionImage[xaux, yaux, :] = img[x,y,:]
        Y[:,:,0,framwImage] = transitionImage[:,:,0]
        Y[:,:,1,framwImage] = transitionImage[:,:,1]
        Y[:,:,2,framwImage] = transitionImage[:,:,2]
        Ax += 5
        framwImage += 1
image = Image.open("landscape.jpg")
resizeImage(image)
rippingEffect(image)