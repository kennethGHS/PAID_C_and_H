import numpy as np
import matplotlib.pyplot as plt
from PIL import Image


def medianFilter(image):

    rows, columns = image.size
    m_image = np.array(image, dtype=np.uint8)
    for row in range(rows):
        for col in range(columns):
            if m_image[row, col] == np.uint8(0):
                window = np.squeeze(np.asarray(m_image[row - 1:row + 2, col - 1:col + 2]))
                m_image[row, col] = np.uint8(np.median(window))
    finalImage = Image.fromarray(m_image, 'L')


    return finalImage

def getNewPos(comp,angle,pix_x,pix_y,rot_x,rot_y): #Makes all the translation of the old components to the rotated components
    if (comp == 'x'):
        a0 = np.cos(angle)
        a1 = np.sin(angle)
        a2 = rot_x - a0 * rot_x - a1 * rot_y
        new_x = round(a0 * pix_x + a1 * pix_y + a2)
        return new_x
    else:
        b0 = -np.sin(angle)
        b1 = np.cos(angle)
        b2 = rot_y - b0 * rot_y - b1 * rot_y
        new_y = round(b0 * pix_x + b1 * pix_y + b2)
        return new_y

def rotacion(img, angle):

    imageM = np.array(img, dtype=np.uint8)
    max_rows, max_cols = img.size
    imageRot = np.zeros((max_rows, max_cols), dtype=np.uint8)
    centerX = max_rows // 2 #Get the x component center about which it will rotate
    centerY = max_cols // 2 #Get the y component center about which it will rotate

    for x in range(max_rows - 1):
        for y in range(max_cols - 1):

            x_new = getNewPos('x',angle,x,y,centerX,centerY)
            y_new = getNewPos('y', angle, x, y, centerX, centerY)

            if x_new >= 0 and y_new >= 0 : ##the transformation is not out of scope
                if x_new < max_rows and y_new < max_cols: #Checks that the image dont gets out of the matrix size
                    imageRot[x_new, y_new] = np.uint8(imageM[x, y])#Sets the components
    finalImage = Image.fromarray(imageRot, 'L')
    return finalImage

def draw():


    gf = plt.figure()
    img = Image.open('landscape.jpg', 'r').convert('L')
    angle = np.pi / 1.8
    rotatedImage = rotacion(img, angle)
    rotatedImage.save("rotationImage.jpg")
    filtertedImage = medianFilter(rotatedImage.convert('L'))
    gf.add_subplot(1, 3, 1)
    filtertedImage.save("medianFilterResult.jpg")

    plt.imshow(img.convert('L'), cmap='gray')
    plt.title("Original")
    gf.add_subplot(1, 3, 2)
    plt.imshow(rotatedImage.convert('L'), cmap='gray')

    plt.title("Rotated")
    gf.add_subplot(1, 3, 3)
    plt.imshow(filtertedImage.convert('L'), cmap='gray')
    plt.title("Filtered rotated")
    plt.show()

draw()