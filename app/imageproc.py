from skimage.metrics import structural_similarity
import argparse
import imutils
import cv2

import pytesseract

class imageproc:

	def get_image_similarity(self, img1, img2):

		# load the two input images
		imageA = cv2.imread(img1)
		imageB = cv2.imread(img2)

		# convert the images to grayscale
		grayA = cv2.cvtColor(imageA, cv2.COLOR_BGR2GRAY)
		grayB = cv2.cvtColor(imageB, cv2.COLOR_BGR2GRAY)

		# compute the Structural Similarity Index (SSIM) between the two
		# images, ensuring that the difference image is returned
		(score, diff) = structural_similarity(grayA, grayB, full=True)
		diff = (diff * 255).astype("uint8")
		#print("SSIM: {}".format(score))
		imageproc.save_image_differences(self, img1, img2, diff)

		# Return the structural similarity index.
		return round(float(score), 2)

	def save_image_differences(self, img1, img2, diff):

		# Threshold the difference image, followed by finding contours to
		# obtain the regions of the two input images that differ
		thresh = cv2.threshold(diff, 0, 255,
			cv2.THRESH_BINARY_INV | cv2.THRESH_OTSU)[1]
		contours = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
			cv2.CHAIN_APPROX_SIMPLE)
		contours = imutils.grab_contours(contours)

		# loop over the contours
		for c in contours:
			# compute the bounding box of the contour and then draw the
			# bounding box on both input images to represent where the two
			# images differ
			(x, y, w, h) = cv2.boundingRect(c)
			cv2.rectangle(imageA, (x, y), (x + w, y + h), (0, 0, 255), 2)
			cv2.rectangle(imageB, (x, y), (x + w, y + h), (0, 0, 255), 2)

		# Output images for reference
		cv2.imwrite(img1+"_vs_"+img2+"_Diff.jpg", diff)
		cv2.imwrite(img1+"_vs_"+img2+"_Thresh.jpg", thresh)
		return True


	def fetch_text_in_image(self, img):
		# List of available languages
		print(pytesseract.get_languages(config=''))

		# NOTE: You can just load the image if it is one of the supported formats like:
		# text = pytesseract.image_to_string(img)

		# Load image with OpenCV
		img_cv = cv2.imread(img)
		# pytesseract needs images in RGB, opencv uses BGR - convert it!
		img_rgb = cv2.cvtColor(img_cv, cv2.COLOR_BGR2RGB)

		# Other data sources available from https://github.com/tesseract-ocr/tessdata
		# tessdata_dir_config = r'--tessdata-dir "/tmp/screenshots" --psm 11'
		# text = pytesseract.image_to_string(img_rgb, lang='eng', config=tessdata_dir_config)

		# Inform the OCR engine that the "page" is not a document of text and process
		tessdata_dir_config = r'--psm 11'
		text = pytesseract.image_to_string(img_rgb, lang='eng', config=tessdata_dir_config)
		return text