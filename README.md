# Detect and recognize text in images
In this project we gonna perform text segmentation in a bw image.
<br> We first transformed the image into binary and then calculated the connected components.
<br> We then performed word segmentation.
<br> We visualize the final boxes and then stored the bounding box values in a txt file.

# Results evaluation
<br> We calculated IOU for every word in the image and then calculated TP FP FN based on filtered IOU table results.
We evaluated the best combination of IOU threshold/Gamma Score based on f-measure.
