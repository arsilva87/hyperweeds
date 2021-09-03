[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

## &#x1f4dd; Research project
**Title:** Recognition of weed classes from hyperspectral images of wheat fields

**Abstract:** Understanding the floristic complex of weeds in agricultural production fields is essential to define management strategies, especially because grass and broadleaf species can be controlled with specific products for these two classes. This is even more relevant in areas with an incidence of herbicide resistant biotypes. Currently, automatic weed recognition is one of the most challenging problems for precision phytosanitary management. With this project, a rule will be developed for the classification of weeds at the taxonomic class level (monocotyledons and dicots) using hyperspectral images acquired by unmanned aerial vehicles at grain production fields such as wheat, corn, soybean and common bean. The method consists of combining (i) the fractional distance SLIC algorithm to obtain superpixels, taking into account spectral and spatial characteristics of the superpixels, (ii) the Mahalanobis distance among superpixels, allowing to determine the relative importance of spectral bands for superpixel discrimination, and (iii) machine learning models for automatic classification. Crop rows will be identified by seeder coordinates or automatically applying the Hough transform algorithm. Weed patches will be identified among hypespectral superpixels from images of field plots previously sampled. A superpixel partition will be used for training machine learning models by the methods: convolutional neural network, support vector machine, and mixture discriminant analysis; the other partition will be used for validation. Accuracy will be assessed using the confusion matrix. The normalized squared error will be calculated by comparing image-based weed cover estimates with the weed density observed in the field plots. The proposed method is expected to be more accurate than both the baseline approaches alone for weed detection, and should also be computationally effective for classifying weed classes.

[&#x1f4bb; **Presentation SLIDES**](https://arsilva87.github.io/hyperweeds/slides.html)

## &#x2709; Team and contact
* Prof. Dr. Anderson Rodrigo da Silva. Instituto Federal Goiano (Brazil). E-mail: <anderson.silva@ifgoiano.edu.br>
* Prof. Dr. Jarosław Chormański. Warsaw University of Life Sciences (Poland). E-mail: <jaroslaw_chormanski@sggw.edu.pl>

## &#x2690; Support
<img src="images/logo_IFgoiano.png" width="8%" height="8%"> <img src="images/logo_sggw.png" width="18%" height="18%"> <img src="images/logo_nawa.jpg" width="16%" height="16%">

Grant number (Ulam/NAWA): PPN/ULM/2020/1/00025
