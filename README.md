# Detect and recognize text in images
In this project I performed text segmentation in a bw image.
<br> I first transformed the image into binary and then calculated the connected components.
<br> I then performed word segmentation.
<br> I visualized the final boxes and then stored the bounding box values in a txt file.
# Results evaluation
We calculated IOU for every word in the image and then calculated TP FP FN based on filtered IOU table results.
We evaluated the best combination of IOU threshold/Gamma Score based on f-measure.
