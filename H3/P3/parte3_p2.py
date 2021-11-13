import numpy as np
import cv2 as cv
img = cv.imread('imagen1.png')
output = img.copy()
gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
gray = cv.medianBlur(gray, 5)
circles = cv.HoughCircles(gray,  cv.HOUGH_GRADIENT, 0.1, 10,
                          param1=25, param2=24, minRadius=3, maxRadius=25)
detected_circles = np.uint16(np.around(circles))
for (x, y ,r) in detected_circles[0, :]:
    cv.circle(output, (x, y), r, (0, 0, 0), 3)
    cv.circle(output, (x, y), 2, (0, 255, 255), 3)

img2 = cv.imread('imagen2.png')
output2 = img2.copy()
gray2 = cv.cvtColor(img2, cv.COLOR_BGR2GRAY)
gray2 = cv.medianBlur(gray2, 5)
circles2 = cv.HoughCircles(gray2, cv.HOUGH_GRADIENT, 1, 20,
                          param1=50, param2=20, minRadius=0, maxRadius=0)
detected_circles2 = np.uint16(np.around(circles2))
for (x, y ,r) in detected_circles2[0, :]:
    cv.circle(output2, (x, y), r, (0, 0, 0), 3)
    cv.circle(output2, (x, y), 2, (0, 255, 255), 3)


img3 = cv.imread('imagen3.png')
output3 = img3.copy()
gray3 = cv.cvtColor(img3, cv.COLOR_BGR2GRAY)
gray3 = cv.medianBlur(gray3, 5)
circles3 = cv.HoughCircles(gray3, cv.HOUGH_GRADIENT, 1, 20,
                          param1=50, param2=34, minRadius=10, maxRadius=50)
detected_circles3 = np.uint16(np.around(circles3))
for (x, y ,r) in detected_circles3[0, :]:
    cv.circle(output3, (x, y), r, (0, 0, 0), 3)
    cv.circle(output3, (x, y), 2, (0, 255, 255), 3)


cv.imshow('output1',output)
cv.imshow('output2',output2)
cv.imshow('output3',output3)
cv.waitKey(0)
cv.destroyAllWindows()